/*
# Part 5b: Modify reviews table for demo data

Make user_id nullable to allow demo reviews without auth.users.
Add reviewer_name column to store display name for demo reviews.
*/

-- Add reviewer_name column for demo reviews
ALTER TABLE reviews ADD COLUMN IF NOT EXISTS reviewer_name TEXT;
ALTER TABLE reviews ADD COLUMN IF NOT EXISTS reviewer_location TEXT;

-- Make user_id nullable for demo reviews
ALTER TABLE reviews ALTER COLUMN user_id DROP NOT NULL;
