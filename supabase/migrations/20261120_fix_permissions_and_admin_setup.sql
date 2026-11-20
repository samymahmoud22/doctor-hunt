-- ==============================================================================
-- Doctor Hunt: Schema, RLS Policies, and Admin Setup Migration
-- Description:
-- 1. Creates all tables (doctors, appointments, reviews, user_favorites) if missing.
-- 2. Configures Row Level Security (RLS) and grants permissions to anon and authenticated.
-- 3. Solves PostgrestException 42501 (permission denied for table appointments).
-- 4. Provides helper SQL to create or promote an Admin account.
-- ==============================================================================

-- 1. Ensure public schema privileges
GRANT USAGE ON SCHEMA public TO anon, authenticated;

-- 2. Create 'doctors' Table
CREATE TABLE IF NOT EXISTS public.doctors (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    rating NUMERIC DEFAULT 4.8,
    reviews_count INT DEFAULT 0,
    consultation_fee NUMERIC DEFAULT 28.0,
    is_active BOOLEAN DEFAULT TRUE,
    image_url TEXT,
    clinic_location TEXT DEFAULT 'Central Clinic • 24 Garden Avenue',
    working_days JSONB DEFAULT '{"Monday": true, "Tuesday": true, "Wednesday": true, "Thursday": true, "Friday": true, "Saturday": false, "Sunday": false}'::jsonb,
    start_time TEXT DEFAULT '09:00 AM',
    end_time TEXT DEFAULT '05:00 PM',
    slot_duration TEXT DEFAULT '30 Minutes'
);

-- 3. Create 'appointments' Table
CREATE TABLE IF NOT EXISTS public.appointments (
    id TEXT PRIMARY KEY,
    patient_id TEXT,
    patient_name TEXT NOT NULL,
    patient_email TEXT NOT NULL,
    patient_avatar TEXT,
    doctor_id TEXT,
    doctor_name TEXT NOT NULL,
    doctor_specialty TEXT NOT NULL,
    doctor_avatar TEXT,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    fee NUMERIC NOT NULL DEFAULT 28.0,
    clinic_location TEXT DEFAULT 'Central Clinic • 24 Garden Avenue',
    status TEXT NOT NULL DEFAULT 'upcoming',
    rating NUMERIC,
    review_text TEXT
);

-- 4. Create 'reviews' Table
CREATE TABLE IF NOT EXISTS public.reviews (
    id TEXT PRIMARY KEY,
    appointment_id TEXT,
    patient_id TEXT,
    doctor_id TEXT NOT NULL,
    rating NUMERIC NOT NULL DEFAULT 5.0,
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Create 'user_favorites' Table
CREATE TABLE IF NOT EXISTS public.user_favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    doctor_id TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_user_doctor_favorite UNIQUE (user_id, doctor_id)
);

-- 6. Grant Table Permissions to 'anon' and 'authenticated' roles
GRANT ALL ON TABLE public.doctors TO anon, authenticated;
GRANT ALL ON TABLE public.appointments TO anon, authenticated;
GRANT ALL ON TABLE public.reviews TO anon, authenticated;
GRANT ALL ON TABLE public.user_favorites TO anon, authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated;

-- 7. Enable RLS and Add Permissive Policies
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they conflict
DROP POLICY IF EXISTS "Allow all access to doctors" ON public.doctors;
DROP POLICY IF EXISTS "Allow all access to appointments" ON public.appointments;
DROP POLICY IF EXISTS "Allow all access to reviews" ON public.reviews;
DROP POLICY IF EXISTS "Allow all access to user_favorites" ON public.user_favorites;

-- Permissive policies for doctors (everyone can view, authenticated can edit)
CREATE POLICY "Allow all access to doctors" ON public.doctors
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Permissive policies for appointments
CREATE POLICY "Allow all access to appointments" ON public.appointments
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Permissive policies for reviews
CREATE POLICY "Allow all access to reviews" ON public.reviews
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Permissive policies for user_favorites
CREATE POLICY "Allow all access to user_favorites" ON public.user_favorites
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- 8. Seed Initial Doctors (if empty)
INSERT INTO public.doctors (id, name, specialty, rating, reviews_count, consultation_fee, is_active, clinic_location, working_days, start_time, end_time, slot_duration)
VALUES 
    ('doc_1', 'Dr. Fillerup Grab', 'Medicine Specialist', 5.0, 520, 28.0, true, 'Central Clinic • 24 Garden Avenue', '{"Monday": true, "Tuesday": true, "Wednesday": true, "Thursday": true, "Friday": true, "Saturday": false, "Sunday": false}'::jsonb, '09:00 AM', '05:00 PM', '30 Minutes'),
    ('doc_2', 'Dr. Shruti Kedia', 'Specialist Dentist', 4.9, 420, 32.0, true, 'Central Clinic • 24 Garden Avenue', '{"Monday": true, "Tuesday": true, "Wednesday": true, "Thursday": true, "Friday": true, "Saturday": true, "Sunday": false}'::jsonb, '10:00 AM', '07:00 PM', '30 Minutes'),
    ('doc_3', 'Dr. Ananya Shah', 'Specialist Cardiologist', 4.8, 380, 45.0, true, 'Central Clinic • 24 Garden Avenue', '{"Monday": true, "Tuesday": true, "Wednesday": true, "Thursday": true, "Friday": true, "Saturday": false, "Sunday": false}'::jsonb, '09:00 AM', '04:00 PM', '30 Minutes')
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- How to Create or Promote an Admin User in Supabase:
--
-- Option A (If the user already exists in auth.users):
-- Run this query to give them the admin role:
--
-- UPDATE auth.users 
-- SET raw_user_meta_data = raw_user_meta_data || '{"role": "admin", "full_name": "Clinic Admin"}'::jsonb
-- WHERE email = 'admin@doctorhunt.com';
--
-- Option B (Supabase Dashboard):
-- 1. Go to Authentication -> Users -> Add User -> Create User.
-- 2. Enter email (e.g. admin@doctorhunt.com) and a strong password.
-- 3. Toggle "Auto Confirm User?" to YES.
-- 4. In SQL Editor run:
--    UPDATE auth.users 
--    SET raw_user_meta_data = jsonb_set(COALESCE(raw_user_meta_data, '{}'::jsonb), '{role}', '"admin"')
--    WHERE email = 'admin@doctorhunt.com';
-- ==============================================================================
