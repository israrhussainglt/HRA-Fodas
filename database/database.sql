-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.analytics_events (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid,
  event_type text NOT NULL,
  event_data jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT analytics_events_pkey PRIMARY KEY (id),
  CONSTRAINT analytics_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.chat_logs (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  session_id text NOT NULL,
  role text NOT NULL,
  content text NOT NULL,
  is_offline boolean DEFAULT false,
  synced_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_logs_pkey PRIMARY KEY (id),
  CONSTRAINT chat_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.chat_messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  content text NOT NULL,
  type text DEFAULT 'text'::text,
  metadata jsonb DEFAULT '{}'::jsonb,
  is_read boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_messages_pkey PRIMARY KEY (id),
  CONSTRAINT chat_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id),
  CONSTRAINT chat_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES auth.users(id)
);
CREATE TABLE public.conversations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  participant_ids ARRAY NOT NULL,
  donation_id uuid,
  delivery_id uuid,
  last_message text,
  last_message_at timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT conversations_pkey PRIMARY KEY (id),
  CONSTRAINT conversations_donation_id_fkey FOREIGN KEY (donation_id) REFERENCES public.donations(id),
  CONSTRAINT conversations_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.deliveries(id)
);
CREATE TABLE public.daily_statistics (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  date date NOT NULL UNIQUE,
  total_donations integer DEFAULT 0,
  total_deliveries integer DEFAULT 0,
  total_weight_kg numeric DEFAULT 0,
  active_donors integer DEFAULT 0,
  active_volunteers integer DEFAULT 0,
  active_recipients integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT daily_statistics_pkey PRIMARY KEY (id)
);
CREATE TABLE public.deliveries (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  donation_id uuid NOT NULL,
  volunteer_id uuid NOT NULL,
  recipient_id uuid NOT NULL,
  status USER-DEFINED DEFAULT 'assigned'::delivery_status,
  pickup_time timestamp with time zone,
  delivery_time timestamp with time zone,
  current_latitude double precision,
  current_longitude double precision,
  route_data jsonb,
  estimated_arrival timestamp with time zone,
  pickup_photo_url text,
  delivery_photo_url text,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT deliveries_pkey PRIMARY KEY (id),
  CONSTRAINT deliveries_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteer_profiles(id),
  CONSTRAINT deliveries_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.recipient_organizations(id),
  CONSTRAINT deliveries_donation_id_fkey FOREIGN KEY (donation_id) REFERENCES public.donations(id)
);
CREATE TABLE public.delivery_logs (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  delivery_id uuid NOT NULL,
  status USER-DEFINED NOT NULL,
  latitude double precision,
  longitude double precision,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT delivery_logs_pkey PRIMARY KEY (id),
  CONSTRAINT delivery_logs_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.deliveries(id)
);
CREATE TABLE public.donations (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  donor_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  food_category USER-DEFINED NOT NULL,
  quantity numeric NOT NULL,
  unit text NOT NULL,
  expiration_date date NOT NULL,
  pickup_address text NOT NULL,
  latitude double precision NOT NULL,
  longitude double precision NOT NULL,
  pickup_start_time timestamp with time zone NOT NULL,
  pickup_end_time timestamp with time zone NOT NULL,
  special_instructions text,
  images jsonb DEFAULT '[]'::jsonb,
  status USER-DEFINED DEFAULT 'pending'::donation_status,
  assigned_volunteer_id uuid,
  assigned_recipient_id uuid,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT donations_pkey PRIMARY KEY (id),
  CONSTRAINT donations_donor_id_fkey FOREIGN KEY (donor_id) REFERENCES public.user_profiles(id),
  CONSTRAINT donations_assigned_volunteer_id_fkey FOREIGN KEY (assigned_volunteer_id) REFERENCES public.volunteer_profiles(id),
  CONSTRAINT donations_assigned_recipient_id_fkey FOREIGN KEY (assigned_recipient_id) REFERENCES public.recipient_organizations(id)
);
CREATE TABLE public.fcm_tokens (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  token text NOT NULL UNIQUE,
  device_type text NOT NULL CHECK (device_type = ANY (ARRAY['android'::text, 'ios'::text, 'web'::text])),
  device_info jsonb,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  last_used_at timestamp with time zone DEFAULT now(),
  CONSTRAINT fcm_tokens_pkey PRIMARY KEY (id),
  CONSTRAINT fcm_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.feedback (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  feedback_type text NOT NULL,
  subject text NOT NULL,
  message text NOT NULL,
  status text DEFAULT 'pending'::text,
  admin_response text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT feedback_pkey PRIMARY KEY (id),
  CONSTRAINT feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.feedback_ratings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  from_user_id uuid NOT NULL,
  to_user_id uuid NOT NULL,
  donation_id uuid,
  delivery_id uuid,
  type text NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text,
  is_anonymous boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT feedback_ratings_pkey PRIMARY KEY (id),
  CONSTRAINT feedback_ratings_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES auth.users(id),
  CONSTRAINT feedback_ratings_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES auth.users(id),
  CONSTRAINT feedback_ratings_donation_id_fkey FOREIGN KEY (donation_id) REFERENCES public.donations(id),
  CONSTRAINT feedback_ratings_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.deliveries(id)
);
CREATE TABLE public.inventory (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  organization_id uuid NOT NULL,
  donation_id uuid,
  food_category USER-DEFINED NOT NULL,
  item_name text NOT NULL,
  quantity numeric NOT NULL,
  unit text NOT NULL,
  expiration_date date,
  received_date timestamp with time zone DEFAULT now(),
  status text DEFAULT 'available'::text,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT inventory_pkey PRIMARY KEY (id),
  CONSTRAINT inventory_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.recipient_organizations(id),
  CONSTRAINT inventory_donation_id_fkey FOREIGN KEY (donation_id) REFERENCES public.donations(id)
);
CREATE TABLE public.inventory_v2 (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  donation_id uuid,
  name text NOT NULL,
  category text NOT NULL,
  quantity numeric NOT NULL DEFAULT 0,
  unit text NOT NULL DEFAULT 'kg'::text,
  expiration_date date,
  received_date date DEFAULT CURRENT_DATE,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT inventory_v2_pkey PRIMARY KEY (id),
  CONSTRAINT inventory_v2_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT inventory_v2_donation_id_fkey FOREIGN KEY (donation_id) REFERENCES public.donations(id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  sender_id uuid NOT NULL,
  receiver_id uuid NOT NULL,
  donation_id uuid,
  content text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.user_profiles(id),
  CONSTRAINT messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.user_profiles(id),
  CONSTRAINT messages_donation_id_fkey FOREIGN KEY (donation_id) REFERENCES public.donations(id)
);
CREATE TABLE public.notification_preferences (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE,
  new_donation_alerts boolean DEFAULT true,
  pickup_reminders boolean DEFAULT true,
  status_updates boolean DEFAULT true,
  chat_messages boolean DEFAULT true,
  all_notifications_enabled boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT notification_preferences_pkey PRIMARY KEY (id),
  CONSTRAINT notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.notifications (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  title text NOT NULL,
  message text NOT NULL,
  type text NOT NULL,
  data jsonb DEFAULT '{}'::jsonb,
  is_read boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.ratings (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  delivery_id uuid NOT NULL,
  rater_id uuid NOT NULL,
  rated_user_id uuid NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text,
  rating_type text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ratings_pkey PRIMARY KEY (id),
  CONSTRAINT ratings_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.deliveries(id),
  CONSTRAINT ratings_rater_id_fkey FOREIGN KEY (rater_id) REFERENCES public.user_profiles(id),
  CONSTRAINT ratings_rated_user_id_fkey FOREIGN KEY (rated_user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.recipient_organizations (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  organization_name text NOT NULL,
  organization_type text NOT NULL,
  registration_number text,
  description text,
  address text NOT NULL,
  latitude double precision NOT NULL,
  longitude double precision NOT NULL,
  capacity integer,
  food_preferences jsonb DEFAULT '[]'::jsonb,
  operating_hours jsonb DEFAULT '{}'::jsonb,
  is_verified boolean DEFAULT false,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT recipient_organizations_pkey PRIMARY KEY (id),
  CONSTRAINT recipient_organizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.scheduled_notifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  donation_id uuid,
  notification_type text NOT NULL,
  scheduled_for timestamp with time zone NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  data jsonb,
  status text DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'sent'::text, 'failed'::text, 'cancelled'::text])),
  sent_at timestamp with time zone,
  error_message text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT scheduled_notifications_pkey PRIMARY KEY (id),
  CONSTRAINT scheduled_notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.spatial_ref_sys (
  srid integer NOT NULL CHECK (srid > 0 AND srid <= 998999),
  auth_name character varying,
  auth_srid integer,
  srtext character varying,
  proj4text character varying,
  CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid)
);
CREATE TABLE public.user_profiles (
  id uuid NOT NULL,
  email text NOT NULL,
  full_name text NOT NULL,
  phone text,
  role USER-DEFINED NOT NULL DEFAULT 'donor'::user_role,
  avatar_url text,
  address text,
  latitude double precision,
  longitude double precision,
  is_verified boolean DEFAULT false,
  is_active boolean DEFAULT true,
  preferences jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT user_profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.volunteer_profiles (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  vehicle_type text,
  max_capacity integer,
  availability jsonb DEFAULT '{}'::jsonb,
  service_areas jsonb DEFAULT '[]'::jsonb,
  latitude double precision,
  longitude double precision,
  is_available boolean DEFAULT true,
  total_deliveries integer DEFAULT 0,
  rating numeric DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT volunteer_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT volunteer_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);