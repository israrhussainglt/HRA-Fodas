const { Client, TablesDB, Users, Messaging, Query, ID } = require('node-appwrite');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
let firebaseApp = null;

function initializeFirebase() {
  if (firebaseApp) return firebaseApp;

  try {
    const serviceAccount = {
      type: "service_account",
      project_id: process.env.FIREBASE_PROJECT_ID || "hra-fodas",
      private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
      private_key: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
      client_email: process.env.FIREBASE_CLIENT_EMAIL,
      client_id: process.env.FIREBASE_CLIENT_ID,
      auth_uri: "https://accounts.google.com/o/oauth2/auth",
      token_uri: "https://oauth2.googleapis.com/token",
      auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
      client_x509_cert_url: process.env.FIREBASE_CLIENT_X509_CERT_URL,
      universe_domain: "googleapis.com"
    };

    firebaseApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId: serviceAccount.project_id
    });

    console.log('✅ Firebase Admin SDK initialized');
    return firebaseApp;
  } catch (error) {
    console.error('❌ Firebase initialization failed:', error);
    throw error;
  }
}

// Main function handler
module.exports = async ({ req, res, log, error }) => {
  try {
    log('🚀 Notification Sender Function Started');

    // Initialize Appwrite client
    const client = new Client()
      .setEndpoint(process.env.APPWRITE_FUNCTION_ENDPOINT)
      .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
      .setKey(process.env.APPWRITE_API_KEY);

    const tablesDB = new TablesDB(client);
    const users = new Users(client);
    const messaging = new Messaging(client);

    // Parse request body
    const bodyData = JSON.parse(req.body || '{}');
    const {
      title,
      body,
      type,
      imageUrl,
      sendToAll = false,
      userIds = [],
      sendToRoles = [],
      excludeUserId = null
    } = bodyData;

    // Support both userId (function call) and user_id (database trigger)
    const userId = bodyData.userId || bodyData.user_id;
    let data = bodyData.data || {};

    // If data is a string (from database), try to parse it
    if (typeof data === 'string') {
      try {
        data = JSON.parse(data);
      } catch (e) {
        log('⚠️ Could not parse data string, using as is');
      }
    }

    log(`📧 Processing notification: ${title}`);

    // Initialize Firebase
    initializeFirebase();

    let targetUserIds = [];

    if (sendToAll) {
      // Get all users (for broadcast)
      const allUsers = await users.list();
      targetUserIds = allUsers.users.map(user => user.$id);
      log(`📢 Broadcasting to ${targetUserIds.length} users`);
    } else if (sendToRoles && sendToRoles.length > 0) {
      // Send to users with specific roles
      log(`👥 Getting users with roles: ${sendToRoles.join(', ')}`);

      const usersWithRoles = await tablesDB.listRows(
        process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
        'user_profiles',
        [
          Query.equal('role', sendToRoles),
          Query.equal('is_active', true)
        ]
      );

      targetUserIds = usersWithRoles.rows.map(row => row.$id);

      // Exclude specific user if provided
      if (excludeUserId) {
        targetUserIds = targetUserIds.filter(id => id !== excludeUserId);
        log(`🚫 Excluded user: ${excludeUserId}`);
      }

      log(`👥 Sending to ${targetUserIds.length} users with roles: ${sendToRoles.join(', ')}`);
    } else if (userIds && userIds.length > 0) {
      // Send to specific users
      targetUserIds = userIds;
      log(`👥 Sending to ${targetUserIds.length} specific users`);
    } else if (userId) {
      // Send to single user
      targetUserIds = [userId];
      log(`👤 Sending to single user: ${userId}`);
    } else {
      throw new Error('No target users specified');
    }

    const results = [];

    // Process each user
    for (const targetUserId of targetUserIds) {
      try {
        log(`Processing user: ${targetUserId}`);

        // Get user's FCM tokens from database
        const fcmTokensResponse = await tablesDB.listRows(
          process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
          'fcm_tokens',
          [
            Query.equal('user_id', targetUserId),
            Query.equal('is_active', true)
          ]
        );

        const fcmTokens = fcmTokensResponse.rows.map(row => row.data.token);

        if (fcmTokens.length === 0) {
          log(`⚠️ No FCM tokens found for user ${targetUserId}`);

          // Try to get user targets from Appwrite Messaging
          try {
            const userTargets = await users.listTargets(targetUserId);
            const pushTargets = userTargets.targets.filter(target =>
              target.providerType === 'fcm' || target.providerType === 'apns'
            );

            if (pushTargets.length > 0) {
              log(`📱 Found ${pushTargets.length} Appwrite targets for user ${targetUserId}`);

              // Send via Appwrite Messaging
              const pushMessage = await messaging.createPush(
                ID.unique(),
                title,
                body,
                pushTargets.map(t => t.$id), // target IDs
                data,
                null, // action
                null, // icon
                null, // image
                null, // badge
                null, // color
                null, // sound
                null, // tag
                null, // click_action
                null, // priority
                null, // content_available
                null, // critical
                false, // draft
                null // scheduled_at
              );

              log(`✅ Sent via Appwrite Messaging: ${pushMessage.$id}`);
              results.push({ userId: targetUserId, success: true, method: 'appwrite', messageId: pushMessage.$id });
              continue;
            }
          } catch (targetError) {
            log(`⚠️ Could not get Appwrite targets for user ${targetUserId}: ${targetError.message}`);
          }

          results.push({ userId: targetUserId, success: false, error: 'No FCM tokens or targets' });
          continue;
        }

        log(`📱 Found ${fcmTokens.length} FCM tokens for user ${targetUserId}`);

        // Create Firebase message
        const message = {
          notification: {
            title: title,
            body: body,
            ...(imageUrl && { imageUrl })
          },
          data: {
            type: type || 'general',
            user_id: targetUserId,
            ...data
          },
          android: {
            notification: {
              channelId: 'high_importance_channel',
              priority: 'high',
              defaultSound: true,
              defaultVibrateTimings: true,
            },
          },
          apns: {
            payload: {
              aps: {
                alert: {
                  title: title,
                  body: body,
                },
                sound: 'default',
                badge: 1,
              },
            },
          },
        };

        // Send to all tokens for this user
        const tokenResults = [];
        for (const token of fcmTokens) {
          try {
            await admin.messaging().send({
              ...message,
              token: token
            });
            tokenResults.push({ token: token.substring(0, 20) + '...', success: true });
            log(`✅ Sent to token: ${token.substring(0, 20)}...`);
          } catch (tokenError) {
            tokenResults.push({ token: token.substring(0, 20) + '...', success: false, error: tokenError.message });
            log(`❌ Failed to send to token ${token.substring(0, 20)}...: ${tokenError.message}`);

            // If token is invalid, mark it as inactive in database
            if (tokenError.code === 'messaging/registration-token-not-registered' ||
              tokenError.code === 'messaging/invalid-registration-token') {
              try {
                const tokenRows = await tablesDB.listRows(
                  process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
                  'fcm_tokens',
                  [Query.equal('token', token)]
                );

                if (tokenRows.rows.length > 0) {
                  await tablesDB.updateRow(
                    process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
                    'fcm_tokens',
                    tokenRows.rows[0].$id,
                    { is_active: false }
                  );
                  log(`🗑️ Marked invalid token as inactive`);
                }
              } catch (updateError) {
                log(`⚠️ Could not update invalid token: ${updateError.message}`);
              }
            }
          }
        }

        const successCount = tokenResults.filter(r => r.success).length;
        results.push({
          userId: targetUserId,
          success: successCount > 0,
          method: 'firebase',
          tokenResults: tokenResults,
          successCount: successCount,
          totalTokens: fcmTokens.length
        });

      } catch (userError) {
        log(`❌ Error processing user ${targetUserId}: ${userError.message}`);
        results.push({ userId: targetUserId, success: false, error: userError.message });
      }
    }

    // Summary
    const totalSuccess = results.filter(r => r.success).length;
    const totalUsers = results.length;

    log(`📊 Notification Summary: ${totalSuccess}/${totalUsers} users reached`);

    // If this was triggered by a document in pending_push_notifications, update its status
    const eventType = req.headers['x-appwrite-trigger'] || '';
    if (eventType.includes('collections.pending_push_notifications.documents')) {
      const docId = bodyData.$id;
      if (docId) {
        try {
          await tablesDB.updateRow(
            process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
            'pending_push_notifications',
            docId,
            {
              status: totalSuccess > 0 ? 'sent' : 'failed',
              processed_at: new Date().toISOString(),
              error_message: totalSuccess > 0 ? null : 'Failed to reach any tokens/targets'
            }
          );
          log(`📝 Updated status for pending notification: ${docId}`);
        } catch (updateError) {
          log(`⚠️ Failed to update pending notification status: ${updateError.message}`);
        }
      }
    }

    return res.json({
      success: true,
      message: `Notifications sent to ${totalSuccess}/${totalUsers} users`,
      results: results,
      timestamp: new Date().toISOString()
    });

  } catch (err) {
    error('❌ Function error:', err);
    return res.json({
      success: false,
      error: err.message,
      timestamp: new Date().toISOString()
    }, 500);
  }
};
