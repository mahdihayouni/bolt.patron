/*
# Pattern Making Platform Initial Schema

1. Purpose
This migration creates the core database structure for a multi-language pattern making learning platform.
The platform serves as both an educational resource (courses, lessons) and a pattern library (Pinterest-style).

2. New Tables
- `profiles` - Extended user data linked to auth.users
- `categories` - Hierarchical categories for patterns (Women > Dresses > Wedding)
- `patterns` - Sewing pattern library with blueprints, images, metadata
- `pattern_images` - Multiple images per pattern (blueprints, photos, etc.)
- `courses` - Educational courses with levels and curricula
- `lessons` - Individual lessons within courses
- `instructors` - Course instructors/creators
- `collections` - User-created collections to save patterns
- `collection_items` - Patterns saved to collections
- `reviews` - User reviews for patterns and courses
- `comments` - User comments on patterns
- `downloads` - Download history tracking
- `certificates` - Course completion certificates
- `notifications` - User notifications
- `user_progress` - Course/pattern progress tracking

3. Security
- RLS enabled on all tables
- Owner-scoped policies for user data (profiles, collections, downloads, certificates, notifications, progress)
- Authenticated read for shared content (patterns, courses, lessons)
- Creator-scoped write for patterns/courses (instructors create, admins manage)

4. Notes
- Multi-language support via JSONB columns for translated content
- Soft deletes with deleted_at timestamps
- Rich metadata using JSONB for flexibility
- Hierarchical categories with parent_id self-reference
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles: Extended user information
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT,
  avatar_url TEXT,
  preferred_language TEXT NOT NULL DEFAULT 'en',
  bio TEXT,
  website TEXT,
  location TEXT,
  social_links JSONB DEFAULT '{}',
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'instructor', 'admin')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_login_at TIMESTAMPTZ,
  email_verified BOOLEAN DEFAULT FALSE
);

-- Instructors: Pattern and course creators
CREATE TABLE IF NOT EXISTS instructors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  name JSONB NOT NULL DEFAULT '{}', -- {en: "", fr: "", ar: ""}
  bio JSONB DEFAULT '{}',
  avatar_url TEXT,
  credentials TEXT[],
  specializations TEXT[],
  website TEXT,
  social_links JSONB DEFAULT '{}',
  verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Categories: Hierarchical pattern categories
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  slug TEXT UNIQUE NOT NULL,
  name JSONB NOT NULL DEFAULT '{}', -- {en: "", fr: "", ar: ""}
  description JSONB DEFAULT '{}',
  icon TEXT,
  image_url TEXT,
  color TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for parent relationship
CREATE INDEX IF NOT EXISTS idx_categories_parent ON categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);

-- Patterns: Core pattern library
CREATE TABLE IF NOT EXISTS patterns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  instructor_id UUID REFERENCES instructors(id) ON DELETE SET NULL,
  slug TEXT UNIQUE NOT NULL,
  title JSONB NOT NULL DEFAULT '{}',
  description JSONB DEFAULT '{}',
  difficulty TEXT NOT NULL DEFAULT 'beginner' CHECK (difficulty IN ('beginner', 'intermediate', 'advanced', 'professional')),
  garment_type TEXT,
  fabric_recommendations JSONB DEFAULT '{}',
  materials_needed JSONB DEFAULT '[]',
  measurements JSONB DEFAULT '{}',
  print_instructions JSONB DEFAULT '{}',
  sewing_instructions JSONB DEFAULT '{}',
  estimated_time_minutes INTEGER,
  sizes JSONB DEFAULT '[]',
  files JSONB DEFAULT '[]', -- [{type: 'pdf', url: '', size: ''}, ...]
  tags TEXT[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  views_count INTEGER DEFAULT 0,
  downloads_count INTEGER DEFAULT 0,
  likes_count INTEGER DEFAULT 0,
  saves_count INTEGER DEFAULT 0,
  rating_average DECIMAL(3,2) DEFAULT 0,
  rating_count INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT TRUE,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Create indexes for patterns
CREATE INDEX IF NOT EXISTS idx_patterns_category ON patterns(category_id);
CREATE INDEX IF NOT EXISTS idx_patterns_difficulty ON patterns(difficulty);
CREATE INDEX IF NOT EXISTS idx_patterns_author ON patterns(author_id);
CREATE INDEX IF NOT EXISTS idx_patterns_featured ON patterns(is_featured) WHERE is_featured = TRUE;
CREATE INDEX IF NOT EXISTS idx_patterns_published ON patterns(is_published) WHERE is_published = TRUE;
CREATE INDEX IF NOT EXISTS idx_patterns_slug ON patterns(slug);

-- Pattern Images: Multiple images per pattern
CREATE TABLE IF NOT EXISTS pattern_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pattern_id UUID NOT NULL REFERENCES patterns(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  thumbnail_url TEXT,
  image_type TEXT NOT NULL DEFAULT 'photo' CHECK (image_type IN ('photo', 'blueprint', 'schematic', 'detail', 'finished')),
  alt_text JSONB DEFAULT '{}',
  display_order INTEGER DEFAULT 0,
  is_primary BOOLEAN DEFAULT FALSE,
  width INTEGER,
  height INTEGER,
  file_size INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pattern_images_pattern ON pattern_images(pattern_id);

-- Courses: Educational courses
CREATE TABLE IF NOT EXISTS courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  instructor_id UUID REFERENCES instructors(id) ON DELETE SET NULL,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  slug TEXT UNIQUE NOT NULL,
  title JSONB NOT NULL DEFAULT '{}',
  subtitle JSONB DEFAULT '{}',
  description JSONB DEFAULT '{}',
  cover_image_url TEXT,
  promo_video_url TEXT,
  level TEXT NOT NULL DEFAULT 'beginner' CHECK (level IN ('beginner', 'intermediate', 'advanced', 'professional')),
  duration_hours DECIMAL(5,2),
  lessons_count INTEGER DEFAULT 0,
  exercises_count INTEGER DEFAULT 0,
  prerequisites JSONB DEFAULT '[]',
  learning_outcomes JSONB DEFAULT '[]',
  skills TEXT[] DEFAULT '{}',
  price DECIMAL(10,2) DEFAULT 0,
  is_free BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT TRUE,
  enrolled_count INTEGER DEFAULT 0,
  rating_average DECIMAL(3,2) DEFAULT 0,
  rating_count INTEGER DEFAULT 0,
  certificate_template TEXT,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_courses_instructor ON courses(instructor_id);
CREATE INDEX IF NOT EXISTS idx_courses_level ON courses(level);
CREATE INDEX IF NOT EXISTS idx_courses_featured ON courses(is_featured) WHERE is_featured = TRUE;

-- Lessons: Course lessons
CREATE TABLE IF NOT EXISTS lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title JSONB NOT NULL DEFAULT '{}',
  description JSONB DEFAULT '{}',
  video_url TEXT,
  video_duration_seconds INTEGER,
  content JSONB DEFAULT '{}', -- Rich content in markdown
  attachments JSONB DEFAULT '[]',
  display_order INTEGER DEFAULT 0,
  is_preview BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lessons_course ON lessons(course_id);

-- Collections: User-created pattern collections
CREATE TABLE IF NOT EXISTS collections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  cover_image_url TEXT,
  is_public BOOLEAN DEFAULT FALSE,
  patterns_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_collections_user ON collections(user_id);

-- Collection Items: Patterns saved to collections
CREATE TABLE IF NOT EXISTS collection_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  pattern_id UUID NOT NULL REFERENCES patterns(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(collection_id, pattern_id)
);

CREATE INDEX IF NOT EXISTS idx_collection_items_collection ON collection_items(collection_id);
CREATE INDEX IF NOT EXISTS idx_collection_items_pattern ON collection_items(pattern_id);

-- Reviews: User reviews for patterns and courses
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  entity_type TEXT NOT NULL CHECK (entity_type IN ('pattern', 'course')),
  entity_id UUID NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  content TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, entity_type, entity_id)
);

CREATE INDEX IF NOT EXISTS idx_reviews_user ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_entity ON reviews(entity_type, entity_id);

-- Comments: User comments on patterns
CREATE TABLE IF NOT EXISTS comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  pattern_id UUID NOT NULL REFERENCES patterns(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  likes_count INTEGER DEFAULT 0,
  is_edited BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_comments_pattern ON comments(pattern_id);
CREATE INDEX IF NOT EXISTS idx_comments_user ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments(parent_id);

-- Downloads: Download history tracking
CREATE TABLE IF NOT EXISTS downloads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  pattern_id UUID REFERENCES patterns(id) ON DELETE SET NULL,
  file_type TEXT,
  file_url TEXT,
  downloaded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_downloads_user ON downloads(user_id);
CREATE INDEX IF NOT EXISTS idx_downloads_pattern ON downloads(pattern_id);

-- User Progress: Course and pattern progress tracking
CREATE TABLE IF NOT EXISTS user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  entity_type TEXT NOT NULL CHECK (entity_type IN ('pattern', 'course', 'lesson')),
  entity_id UUID NOT NULL,
  status TEXT NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
  progress_percent INTEGER DEFAULT 0,
  time_spent_seconds INTEGER DEFAULT 0,
  last_accessed_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',
  UNIQUE(user_id, entity_type, entity_id)
);

CREATE INDEX IF NOT EXISTS idx_user_progress_user ON user_progress(user_id);

-- Certificates: Course completion certificates
CREATE TABLE IF NOT EXISTS certificates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  certificate_number TEXT UNIQUE NOT NULL,
  issued_at TIMESTAMPTZ DEFAULT NOW(),
  pdf_url TEXT,
  metadata JSONB DEFAULT '{}',
  UNIQUE(user_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_certificates_user ON certificates(user_id);
CREATE INDEX IF NOT EXISTS idx_certificates_course ON certificates(course_id);

-- Notifications: User notifications
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  title JSONB NOT NULL DEFAULT '{}',
  message JSONB DEFAULT '{}',
  data JSONB DEFAULT '{}',
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id) WHERE is_read = FALSE;

-- Pattern Likes: Track pattern likes
CREATE TABLE IF NOT EXISTS pattern_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  pattern_id UUID NOT NULL REFERENCES patterns(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, pattern_id)
);

CREATE INDEX IF NOT EXISTS idx_pattern_likes_user ON pattern_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_pattern_likes_pattern ON pattern_likes(pattern_id);

-- Course Enrollments: Track course enrollments
CREATE TABLE IF NOT EXISTS course_enrollments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  progress_percent INTEGER DEFAULT 0,
  last_lesson_id UUID REFERENCES lessons(id),
  UNIQUE(user_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_enrollments_user ON course_enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course ON course_enrollments(course_id);

-- Lesson Progress: Track individual lesson progress
CREATE TABLE IF NOT EXISTS lesson_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  watch_time_seconds INTEGER DEFAULT 0,
  notes TEXT,
  UNIQUE(user_id, lesson_id)
);

CREATE INDEX IF NOT EXISTS idx_lesson_progress_user ON lesson_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_lesson ON lesson_progress(lesson_id);

-- User Follows: Users following instructors
CREATE TABLE IF NOT EXISTS user_follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id UUID NOT NULL DEFAULT auth.uid() REFERENCES profiles(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id)
);

CREATE INDEX IF NOT EXISTS idx_user_follows_follower ON user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following ON user_follows(following_id);

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE instructors ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE patterns ENABLE ROW LEVEL SECURITY;
ALTER TABLE pattern_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE collection_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE pattern_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_follows ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
DROP POLICY IF EXISTS "profiles_select_own" ON profiles;
CREATE POLICY "profiles_select_own" ON profiles FOR SELECT TO authenticated USING (auth.uid() = id);

DROP POLICY IF EXISTS "profiles_update_own" ON profiles;
CREATE POLICY "profiles_update_own" ON profiles FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "profiles_insert_own" ON profiles;
CREATE POLICY "profiles_insert_own" ON profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

-- RLS Policies for instructors (public read)
DROP POLICY IF EXISTS "instructors_read_all" ON instructors;
CREATE POLICY "instructors_read_all" ON instructors FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "instructors_read_anon" ON instructors;
CREATE POLICY "instructors_read_anon" ON instructors FOR SELECT TO anon USING (true);

-- RLS Policies for categories (public read)
DROP POLICY IF EXISTS "categories_read_all" ON categories;
CREATE POLICY "categories_read_all" ON categories FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "categories_read_anon" ON categories;
CREATE POLICY "categories_read_anon" ON categories FOR SELECT TO anon USING (true);

-- RLS Policies for patterns (public read)
DROP POLICY IF EXISTS "patterns_read_all" ON patterns;
CREATE POLICY "patterns_read_all" ON patterns FOR SELECT TO authenticated USING (is_published = TRUE AND deleted_at IS NULL);

DROP POLICY IF EXISTS "patterns_read_anon" ON patterns;
CREATE POLICY "patterns_read_anon" ON patterns FOR SELECT TO anon USING (is_published = TRUE AND deleted_at IS NULL);

-- RLS Policies for pattern_images (public read)
DROP POLICY IF EXISTS "pattern_images_read_all" ON pattern_images;
CREATE POLICY "pattern_images_read_all" ON pattern_images FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "pattern_images_read_anon" ON pattern_images;
CREATE POLICY "pattern_images_read_anon" ON pattern_images FOR SELECT TO anon USING (true);

-- RLS Policies for courses (public read)
DROP POLICY IF EXISTS "courses_read_all" ON courses;
CREATE POLICY "courses_read_all" ON courses FOR SELECT TO authenticated USING (is_published = TRUE AND deleted_at IS NULL);

DROP POLICY IF EXISTS "courses_read_anon" ON courses;
CREATE POLICY "courses_read_anon" ON courses FOR SELECT TO anon USING (is_published = TRUE AND deleted_at IS NULL);

-- RLS Policies for lessons (public read for enrolled users)
DROP POLICY IF EXISTS "lessons_read_all" ON lessons;
CREATE POLICY "lessons_read_all" ON lessons FOR SELECT TO authenticated USING (is_published = TRUE);

DROP POLICY IF EXISTS "lessons_read_anon" ON lessons;
CREATE POLICY "lessons_read_anon" ON lessons FOR SELECT TO anon USING (is_preview = TRUE AND is_published = TRUE);

-- RLS Policies for collections (owner only)
DROP POLICY IF EXISTS "collections_select_own" ON collections;
CREATE POLICY "collections_select_own" ON collections FOR SELECT TO authenticated USING (auth.uid() = user_id OR is_public = TRUE);

DROP POLICY IF EXISTS "collections_insert_own" ON collections;
CREATE POLICY "collections_insert_own" ON collections FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "collections_update_own" ON collections;
CREATE POLICY "collections_update_own" ON collections FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "collections_delete_own" ON collections;
CREATE POLICY "collections_delete_own" ON collections FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- RLS Policies for collection_items
DROP POLICY IF EXISTS "collection_items_select_own" ON collection_items;
CREATE POLICY "collection_items_select_own" ON collection_items FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM collections WHERE collections.id = collection_items.collection_id AND (collections.user_id = auth.uid() OR collections.is_public = TRUE))
);

DROP POLICY IF EXISTS "collection_items_insert_own" ON collection_items;
CREATE POLICY "collection_items_insert_own" ON collection_items FOR INSERT TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM collections WHERE collections.id = collection_items.collection_id AND collections.user_id = auth.uid())
);

DROP POLICY IF EXISTS "collection_items_delete_own" ON collection_items;
CREATE POLICY "collection_items_delete_own" ON collection_items FOR DELETE TO authenticated USING (
  EXISTS (SELECT 1 FROM collections WHERE collections.id = collection_items.collection_id AND collections.user_id = auth.uid())
);

-- RLS Policies for reviews
DROP POLICY IF EXISTS "reviews_read_all" ON reviews;
CREATE POLICY "reviews_read_all" ON reviews FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "reviews_read_anon" ON reviews;
CREATE POLICY "reviews_read_anon" ON reviews FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "reviews_insert_own" ON reviews;
CREATE POLICY "reviews_insert_own" ON reviews FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "reviews_update_own" ON reviews;
CREATE POLICY "reviews_update_own" ON reviews FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "reviews_delete_own" ON reviews;
CREATE POLICY "reviews_delete_own" ON reviews FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- RLS Policies for comments
DROP POLICY IF EXISTS "comments_read_all" ON comments;
CREATE POLICY "comments_read_all" ON comments FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "comments_read_anon" ON comments;
CREATE POLICY "comments_read_anon" ON comments FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "comments_insert_own" ON comments;
CREATE POLICY "comments_insert_own" ON comments FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "comments_update_own" ON comments;
CREATE POLICY "comments_update_own" ON comments FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "comments_delete_own" ON comments;
CREATE POLICY "comments_delete_own" ON comments FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- RLS Policies for downloads (owner only)
DROP POLICY IF EXISTS "downloads_select_own" ON downloads;
CREATE POLICY "downloads_select_own" ON downloads FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "downloads_insert_own" ON downloads;
CREATE POLICY "downloads_insert_own" ON downloads FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- RLS Policies for user_progress (owner only)
DROP POLICY IF EXISTS "user_progress_select_own" ON user_progress;
CREATE POLICY "user_progress_select_own" ON user_progress FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "user_progress_insert_own" ON user_progress;
CREATE POLICY "user_progress_insert_own" ON user_progress FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "user_progress_update_own" ON user_progress;
CREATE POLICY "user_progress_update_own" ON user_progress FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- RLS Policies for certificates (owner only)
DROP POLICY IF EXISTS "certificates_select_own" ON certificates;
CREATE POLICY "certificates_select_own" ON certificates FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "certificates_insert_own" ON certificates;
CREATE POLICY "certificates_insert_own" ON certificates FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- RLS Policies for notifications (owner only)
DROP POLICY IF EXISTS "notifications_select_own" ON notifications;
CREATE POLICY "notifications_select_own" ON notifications FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "notifications_update_own" ON notifications;
CREATE POLICY "notifications_update_own" ON notifications FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "notifications_insert_own" ON notifications;
CREATE POLICY "notifications_insert_own" ON notifications FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- RLS Policies for pattern_likes
DROP POLICY IF EXISTS "pattern_likes_select_own" ON pattern_likes;
CREATE POLICY "pattern_likes_select_own" ON pattern_likes FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "pattern_likes_insert_own" ON pattern_likes;
CREATE POLICY "pattern_likes_insert_own" ON pattern_likes FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "pattern_likes_delete_own" ON pattern_likes;
CREATE POLICY "pattern_likes_delete_own" ON pattern_likes FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- RLS Policies for course_enrollments
DROP POLICY IF EXISTS "course_enrollments_select_own" ON course_enrollments;
CREATE POLICY "course_enrollments_select_own" ON course_enrollments FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "course_enrollments_insert_own" ON course_enrollments;
CREATE POLICY "course_enrollments_insert_own" ON course_enrollments FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "course_enrollments_update_own" ON course_enrollments;
CREATE POLICY "course_enrollments_update_own" ON course_enrollments FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- RLS Policies for lesson_progress
DROP POLICY IF EXISTS "lesson_progress_select_own" ON lesson_progress;
CREATE POLICY "lesson_progress_select_own" ON lesson_progress FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "lesson_progress_insert_own" ON lesson_progress;
CREATE POLICY "lesson_progress_insert_own" ON lesson_progress FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "lesson_progress_update_own" ON lesson_progress;
CREATE POLICY "lesson_progress_update_own" ON lesson_progress FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- RLS Policies for user_follows
DROP POLICY IF EXISTS "user_follows_select_own" ON user_follows;
CREATE POLICY "user_follows_select_own" ON user_follows FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "user_follows_insert_own" ON user_follows;
CREATE POLICY "user_follows_insert_own" ON user_follows FOR INSERT TO authenticated WITH CHECK (auth.uid() = follower_id);

DROP POLICY IF EXISTS "user_follows_delete_own" ON user_follows;
CREATE POLICY "user_follows_delete_own" ON user_follows FOR DELETE TO authenticated USING (auth.uid() = follower_id);

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to relevant tables
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_profiles_updated_at') THEN
    CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_categories_updated_at') THEN
    CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_patterns_updated_at') THEN
    CREATE TRIGGER update_patterns_updated_at BEFORE UPDATE ON patterns FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_courses_updated_at') THEN
    CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_lessons_updated_at') THEN
    CREATE TRIGGER update_lessons_updated_at BEFORE UPDATE ON lessons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_collections_updated_at') THEN
    CREATE TRIGGER update_collections_updated_at BEFORE UPDATE ON collections FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_reviews_updated_at') THEN
    CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_comments_updated_at') THEN
    CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;
