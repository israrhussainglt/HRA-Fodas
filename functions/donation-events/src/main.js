const { Client, TablesDB, Functions, Query } = require('node-appwrite');

// Main function handler
module.exports = async ({ req, res, log, error }) => {
  try {
    log('🎯 Donation Event Handler Started');

    // Initialize Appwrite client
    const client = new Client()
      .setEndpoint(process.env.APPWRITE_FUNCTION_ENDPOINT)
      .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
      .setKey(process.env.APPWRITE_API_KEY);

    const tablesDB = new TablesDB(client);
    const functions = new Functions(client);

    // Parse the event data
    const eventType = req.headers['x-appwrite-trigger'] || 'unknown';
    const eventData = JSON.parse(req.body || '{}');
    const collectionId = req.headers['x-appwrite-collection-id'] || '';
    
    log(`📋 Event Type: ${eventType}`);
    log(`📦 Collection: ${collectionId}`);
    log(`📄 Event Data: ${JSON.stringify(eventData, null, 2)}`);

    // Handle NGO Request events
    if (collectionId === 'ngo_requests' && eventType.includes('create')) {
      return await handleNGORequestCreated(eventData, tablesDB, functions, log, error, res);
    }

    // Handle Donation events (existing logic)
    return await handleDonationEvent(eventData, eventType, tablesDB, functions, log, error, res);

  } catch (err) {
    error('❌ Function error:', err);
    return res.json({
      success: false,
      error: err.message,
      timestamp: new Date().toISOString()
    }, 500);
  }
};

// Handle NGO Request Created Event
async function handleNGORequestCreated(request, tablesDB, functions, log, error, res) {
  try {
    log('🏢 NGO Request Created Event');
    
    const requestId = request.$id;
    const donationId = request.donation_id;
    const recipientId = request.recipient_id;
    
    if (!donationId) {
      log('⚠️ No donation_id in request, skipping donor notification');
      return res.json({
        success: true,
        message: 'NGO request processed (no donation link)',
        timestamp: new Date().toISOString()
      });
    }

    // Fetch donation to get donor ID
    let donation;
    try {
      const donationResponse = await tablesDB.getRow(
        process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
        'donations',
        donationId
      );
      donation = donationResponse.data;
    } catch (fetchError) {
      error(`❌ Failed to fetch donation ${donationId}:`, fetchError);
      return res.json({
        success: false,
        error: `Donation not found: ${donationId}`,
        timestamp: new Date().toISOString()
      }, 404);
    }

    const donorId = donation.donor_id;
    if (!donorId) {
      log('⚠️ No donor_id in donation, skipping notification');
      return res.json({
        success: true,
        message: 'NGO request processed (no donor)',
        timestamp: new Date().toISOString()
      });
    }

    // Get recipient name for notification
    let recipientName = 'An organization';
    try {
      const recipientResponse = await tablesDB.getRow(
        process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
        'user_profiles',
        recipientId
      );
      recipientName = recipientResponse.data.full_name || recipientName;
    } catch (e) {
      log('⚠️ Could not fetch recipient name, using default');
    }

    // Create bell notification with retry
    const notificationCreated = await createBellNotificationWithRetry(
      tablesDB,
      donorId,
      recipientName,
      donation,
      requestId,
      log,
      error
    );

    // Send push notification with retry
    const pushSent = await sendPushNotificationWithRetry(
      functions,
      donorId,
      recipientName,
      donation,
      requestId,
      log,
      error
    );

    return res.json({
      success: true,
      message: 'NGO request notification processed',
      request_id: requestId,
      donation_id: donationId,
      donor_id: donorId,
      bell_notification: notificationCreated,
      push_notification: pushSent,
      timestamp: new Date().toISOString()
    });

  } catch (err) {
    error('❌ NGO Request handler error:', err);
    return res.json({
      success: false,
      error: err.message,
      timestamp: new Date().toISOString()
    }, 500);
  }
}

// Create bell notification with retry logic
async function createBellNotificationWithRetry(tablesDB, donorId, recipientName, donation, requestId, log, error) {
  const maxRetries = 3;
  let attempts = 0;

  while (attempts < maxRetries) {
    try {
      log(`📧 Creating bell notification (attempt ${attempts + 1}/${maxRetries})`);
      
      await tablesDB.createRow(
        process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
        'notifications',
        'unique()',
        {
          user_id: donorId,
          title: 'NGO Request for Your Donation',
          message: `${recipientName} has requested your ${donation.quantity || ''} ${donation.unit || ''} of ${donation.food_categories || 'food'}`,
          type: 'ngo_requested',
          is_read: false,
          data: JSON.stringify({
            request_id: requestId,
            donation_id: donation.$id || donation.id,
            recipient_name: recipientName
          })
        }
      );

      log('✅ Bell notification created successfully');
      return true;
    } catch (err) {
      attempts++;
      error(`❌ Bell notification attempt ${attempts} failed:`, err);
      
      if (attempts >= maxRetries) {
        error('❌ Max retries reached for bell notification');
        return false;
      }

      // Exponential backoff: 100ms, 200ms, 400ms
      const delay = 100 * Math.pow(2, attempts);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }

  return false;
}

// Send push notification with retry logic
async function sendPushNotificationWithRetry(functions, donorId, recipientName, donation, requestId, log, error) {
  const maxRetries = 3;
  let attempts = 0;

  while (attempts < maxRetries) {
    try {
      log(`📱 Sending push notification (attempt ${attempts + 1}/${maxRetries})`);
      
      await functions.createExecution(
        'notification-sender',
        JSON.stringify({
          userIds: [donorId],
          title: 'NGO Request for Your Donation',
          body: `${recipientName} has requested your ${donation.quantity || ''} ${donation.unit || ''} of ${donation.food_categories || 'food'}`,
          type: 'ngo_requested',
          data: {
            request_id: requestId,
            donation_id: donation.$id || donation.id,
            action: 'view_donation'
          }
        }),
        false,
        '/',
        'POST',
        {}
      );

      log('✅ Push notification sent successfully');
      return true;
    } catch (err) {
      attempts++;
      error(`❌ Push notification attempt ${attempts} failed:`, err);
      
      if (attempts >= maxRetries) {
        error('❌ Max retries reached for push notification');
        return false;
      }

      // Exponential backoff: 100ms, 200ms, 400ms
      const delay = 100 * Math.pow(2, attempts);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }

  return false;
}

// Handle Donation Event (existing logic)
async function handleDonationEvent(donation, eventType, tablesDB, functions, log, error, res) {
    const donationId = donation.$id || donation.id;
    const donorId = donation.donor_id;
    const status = donation.status;
    const title = donation.title;
    const assignedVolunteerId = donation.assigned_volunteer_id;
    const assignedRecipientId = donation.assigned_recipient_id;

    log(`🎁 Processing donation: ${title} (${donationId})`);
    log(`📊 Status: ${status}`);

    // Determine notification recipients and content based on event and status
    let notifications = [];

    if (eventType.includes('create')) {
      // New donation created - notify volunteers and recipients
      log('🆕 New donation created - notifying volunteers and recipients');
      
      // Get all volunteers
      const volunteersResponse = await tablesDB.listRows(
        process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
        'user_profiles',
        [
          Query.equal('role', 'volunteer'),
          Query.equal('is_active', true)
        ]
      );

      // Get all recipients
      const recipientsResponse = await tablesDB.listRows(
        process.env.APPWRITE_DATABASE_ID || 'hra_fodas_main',
        'user_profiles',
        [
          Query.equal('role', 'recipient'),
          Query.equal('is_active', true)
        ]
      );

      const volunteerIds = volunteersResponse.rows.map(row => row.$id);
      const recipientIds = recipientsResponse.rows.map(row => row.$id);

      notifications.push({
        userIds: volunteerIds,
        title: '🎁 New Donation Available',
        body: `"${title}" is ready for pickup. Tap to view details.`,
        type: 'new_donation',
        data: {
          donation_id: donationId,
          donor_id: donorId,
          action: 'view_donation'
        }
      });

      notifications.push({
        userIds: recipientIds,
        title: '🎁 New Donation Available',
        body: `"${title}" has been donated. A volunteer will deliver it soon.`,
        type: 'new_donation',
        data: {
          donation_id: donationId,
          donor_id: donorId,
          action: 'view_donation'
        }
      });

    } else if (eventType.includes('update')) {
      // Donation status updated
      log(`🔄 Donation status updated to: ${status}`);

      switch (status) {
        case 'assigned':
          // Volunteer assigned - notify donor and recipient
          if (assignedVolunteerId) {
            notifications.push({
              userIds: [donorId],
              title: '👥 Volunteer Assigned',
              body: `A volunteer has been assigned to pickup "${title}".`,
              type: 'volunteer_assigned',
              data: {
                donation_id: donationId,
                volunteer_id: assignedVolunteerId,
                action: 'view_donation'
              }
            });
          }
          
          if (assignedRecipientId) {
            notifications.push({
              userIds: [assignedRecipientId],
              title: '🎁 Donation Assigned to You',
              body: `"${title}" has been assigned to your organization.`,
              type: 'donation_assigned',
              data: {
                donation_id: donationId,
                donor_id: donorId,
                action: 'view_donation'
              }
            });
          }
          break;

        case 'picked_up':
          // Donation picked up - notify donor and recipient
          notifications.push({
            userIds: [donorId],
            title: '📦 Donation Picked Up',
            body: `"${title}" has been picked up by the volunteer.`,
            type: 'pickup_confirmed',
            data: {
              donation_id: donationId,
              volunteer_id: assignedVolunteerId,
              action: 'view_donation'
            }
          });

          if (assignedRecipientId) {
            notifications.push({
              userIds: [assignedRecipientId],
              title: '🚚 Donation On The Way',
              body: `"${title}" is being delivered to you now.`,
              type: 'delivery_started',
              data: {
                donation_id: donationId,
                volunteer_id: assignedVolunteerId,
                action: 'track_delivery'
              }
            });
          }
          break;

        case 'delivered':
          // Donation delivered - notify donor
          notifications.push({
            userIds: [donorId],
            title: '✅ Donation Delivered',
            body: `"${title}" has been successfully delivered. Thank you for your generosity!`,
            type: 'delivery_completed',
            data: {
              donation_id: donationId,
              recipient_id: assignedRecipientId,
              action: 'view_donation'
            }
          });

          // Also notify volunteer
          if (assignedVolunteerId) {
            notifications.push({
              userIds: [assignedVolunteerId],
              title: '🎉 Delivery Completed',
              body: `You successfully delivered "${title}". Great job!`,
              type: 'delivery_completed',
              data: {
                donation_id: donationId,
                action: 'view_donation'
              }
            });
          }
          break;

        case 'cancelled':
          // Donation cancelled - notify assigned parties
          const notifyUsers = [];
          if (assignedVolunteerId) notifyUsers.push(assignedVolunteerId);
          if (assignedRecipientId) notifyUsers.push(assignedRecipientId);

          if (notifyUsers.length > 0) {
            notifications.push({
              userIds: notifyUsers,
              title: '❌ Donation Cancelled',
              body: `The donation "${title}" has been cancelled.`,
              type: 'donation_cancelled',
              data: {
                donation_id: donationId,
                donor_id: donorId,
                action: 'view_donations'
              }
            });
          }
          break;

        case 'expired':
          // Donation expired - notify donor
          notifications.push({
            userIds: [donorId],
            title: '⏰ Donation Expired',
            body: `"${title}" has expired and been removed from the system.`,
            type: 'donation_expired',
            data: {
              donation_id: donationId,
              action: 'create_new_donation'
            }
          });
          break;
      }
    }

    // Send all notifications
    log(`📤 Sending ${notifications.length} notification batches`);
    
    const notificationResults = [];
    
    for (const notification of notifications) {
      try {
        log(`📧 Sending notification: "${notification.title}" to ${notification.userIds.length} users`);
        
        // Call the notification sender function
        const result = await functions.createExecution(
          'notification-sender',
          JSON.stringify({
            userIds: notification.userIds,
            title: notification.title,
            body: notification.body,
            type: notification.type,
            data: notification.data
          }),
          false, // not async
          '/', // path
          'POST', // method
          {} // headers
        );

        notificationResults.push({
          notification: notification.title,
          users: notification.userIds.length,
          success: true,
          executionId: result.$id
        });

        log(`✅ Notification sent successfully: ${result.$id}`);

      } catch (notificationError) {
        log(`❌ Failed to send notification "${notification.title}": ${notificationError.message}`);
        notificationResults.push({
          notification: notification.title,
          users: notification.userIds.length,
          success: false,
          error: notificationError.message
        });
      }
    }

    // Summary
    const successCount = notificationResults.filter(r => r.success).length;
    const totalNotifications = notificationResults.length;
    
    log(`📊 Notification Summary: ${successCount}/${totalNotifications} batches sent successfully`);

    return res.json({
      success: true,
      message: `Processed donation event: ${eventType}`,
      donation: {
        id: donationId,
        title: title,
        status: status,
        donor_id: donorId
      },
      notifications: notificationResults,
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