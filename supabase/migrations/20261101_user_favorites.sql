-- Migration: User Favorites Table
-- Description: Stores favorite doctors for each user with unique constraints and RLS policies.

CREATE TABLE IF NOT EXISTS user_favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    doctor_id TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_user_doctor_favorite UNIQUE (user_id, doctor_id)
);

-- Enable Row Level Security (RLS)
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

-- Allow users to manage their own favorites
CREATE POLICY "Users can manage own favorites" ON user_favorites
    FOR ALL
    USING (auth.uid()::text = user_id OR user_id = 'guest_user')
    WITH CHECK (auth.uid()::text = user_id OR user_id = 'guest_user');

-- Index for fast user_id lookups
CREATE INDEX IF NOT EXISTS idx_user_favorites_user_id ON user_favorites(user_id);

