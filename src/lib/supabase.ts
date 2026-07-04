import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Types
export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface MultilingualText {
  en: string;
  fr: string;
  ar: string;
}

export interface Profile {
  id: string;
  email: string;
  name: string | null;
  avatar_url: string | null;
  preferred_language: string;
  bio: string | null;
  website: string | null;
  location: string | null;
  social_links: Json;
  role: 'user' | 'instructor' | 'admin';
  created_at: string;
  updated_at: string;
  last_login_at: string | null;
  email_verified: boolean;
}

export interface Instructor {
  id: string;
  user_id: string | null;
  name: MultilingualText;
  bio: MultilingualText;
  avatar_url: string | null;
  credentials: string[];
  specializations: string[];
  website: string | null;
  social_links: Json;
  verified: boolean;
  created_at: string;
  updated_at: string;
}

export interface Category {
  id: string;
  parent_id: string | null;
  slug: string;
  name: MultilingualText;
  description: MultilingualText;
  icon: string | null;
  image_url: string | null;
  color: string | null;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Pattern {
  id: string;
  author_id: string | null;
  category_id: string | null;
  instructor_id: string | null;
  slug: string;
  title: MultilingualText;
  description: MultilingualText;
  difficulty: 'beginner' | 'intermediate' | 'advanced' | 'professional';
  garment_type: string | null;
  fabric_recommendations: MultilingualText;
  materials_needed: Json;
  measurements: Json;
  print_instructions: MultilingualText;
  sewing_instructions: MultilingualText;
  estimated_time_minutes: number | null;
  sizes: Json;
  files: Json;
  tags: string[];
  metadata: Json;
  views_count: number;
  downloads_count: number;
  likes_count: number;
  saves_count: number;
  rating_average: number;
  rating_count: number;
  is_featured: boolean;
  is_published: boolean;
  published_at: string | null;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
}

export interface PatternImage {
  id: string;
  pattern_id: string;
  image_url: string;
  thumbnail_url: string | null;
  image_type: 'photo' | 'blueprint' | 'schematic' | 'detail' | 'finished';
  alt_text: MultilingualText;
  display_order: number;
  is_primary: boolean;
  width: number | null;
  height: number | null;
  file_size: number | null;
  created_at: string;
}

export interface Course {
  id: string;
  instructor_id: string | null;
  category_id: string | null;
  slug: string;
  title: MultilingualText;
  subtitle: MultilingualText;
  description: MultilingualText;
  cover_image_url: string | null;
  promo_video_url: string | null;
  level: 'beginner' | 'intermediate' | 'advanced' | 'professional';
  duration_hours: number | null;
  lessons_count: number;
  exercises_count: number;
  prerequisites: Json;
  learning_outcomes: Json;
  skills: string[];
  price: number;
  is_free: boolean;
  is_featured: boolean;
  is_published: boolean;
  enrolled_count: number;
  rating_average: number;
  rating_count: number;
  certificate_template: string | null;
  published_at: string | null;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
}

export interface Lesson {
  id: string;
  course_id: string;
  title: MultilingualText;
  description: MultilingualText;
  video_url: string | null;
  video_duration_seconds: number | null;
  content: Json;
  attachments: Json;
  display_order: number;
  is_preview: boolean;
  is_published: boolean;
  created_at: string;
  updated_at: string;
}

export interface Collection {
  id: string;
  user_id: string;
  name: string;
  description: string | null;
  cover_image_url: string | null;
  is_public: boolean;
  patterns_count: number;
  created_at: string;
  updated_at: string;
}

export interface CollectionItem {
  id: string;
  collection_id: string;
  pattern_id: string;
  added_at: string;
}

export interface Review {
  id: string;
  user_id: string;
  entity_type: 'pattern' | 'course';
  entity_id: string;
  rating: number;
  title: string | null;
  content: string | null;
  is_verified: boolean;
  helpful_count: number;
  created_at: string;
  updated_at: string;
}

export interface Comment {
  id: string;
  user_id: string;
  pattern_id: string;
  parent_id: string | null;
  content: string;
  likes_count: number;
  is_edited: boolean;
  created_at: string;
  updated_at: string;
}

export interface CourseEnrollment {
  id: string;
  user_id: string;
  course_id: string;
  enrolled_at: string;
  completed_at: string | null;
  progress_percent: number;
  last_lesson_id: string | null;
}

export interface PatternLike {
  id: string;
  user_id: string;
  pattern_id: string;
  created_at: string;
}
