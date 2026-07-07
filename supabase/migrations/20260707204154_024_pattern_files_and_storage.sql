/*
# Pattern Files Table and Storage Bucket Setup

1. New Tables
- `pattern_files` - stores downloadable pattern files (PDFs, ZIPs, SVGs, DXFs, etc.)
  - id (uuid, primary key)
  - pattern_id (uuid, FK to patterns)
  - storage_path (text) - path within pattern-assets bucket
  - public_url (text) - generated public URL
  - file_name (text) - original filename
  - file_type (text) - enum: pdf, zip, svg, dxf, ai, video, image
  - file_size (integer) - size in bytes
  - display_name (jsonb) - multilingual display name
  - description (jsonb) - multilingual description
  - display_order (integer) - order for display
  - is_primary (boolean) - marks the main download file
  - created_at (timestamp)

2. Modified Tables
- `pattern_images` - add storage_path column for Supabase Storage tracking
  - storage_path (text, nullable) - path within pattern-assets bucket

3. Storage Bucket
- Create 'pattern-assets' bucket for all pattern assets
- Public read access

4. Security
- Enable RLS on pattern_files
- Allow public read (anon + authenticated) for browsing
- Only authenticated users can insert/update/delete

5. Folder Structure Convention
- Images: pattern-assets/{category}/{subcategory}/{pattern-slug}/images/
- Files: pattern-assets/{category}/{subcategory}/{pattern-slug}/files/
*/

-- Add storage_path to pattern_images
ALTER TABLE pattern_images 
ADD COLUMN IF NOT EXISTS storage_path text;

-- Create pattern_files table
CREATE TABLE IF NOT EXISTS pattern_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pattern_id uuid NOT NULL REFERENCES patterns(id) ON DELETE CASCADE,
  storage_path text NOT NULL,
  public_url text NOT NULL,
  file_name text NOT NULL,
  file_type text NOT NULL CHECK (file_type IN ('pdf', 'zip', 'svg', 'dxf', 'ai', 'video', 'image', 'other')),
  file_size integer,
  display_name jsonb DEFAULT '{}'::jsonb,
  description jsonb DEFAULT '{}'::jsonb,
  display_order integer DEFAULT 0,
  is_primary boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE pattern_files ENABLE ROW LEVEL SECURITY;

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_pattern_files_pattern_id ON pattern_files(pattern_id);
CREATE INDEX IF NOT EXISTS idx_pattern_files_type ON pattern_files(file_type);

-- Policies for pattern_files (public read, authenticated write)
DROP POLICY IF EXISTS "anon_read_pattern_files" ON pattern_files;
CREATE POLICY "anon_read_pattern_files" ON pattern_files FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "authenticated_insert_pattern_files" ON pattern_files;
CREATE POLICY "authenticated_insert_pattern_files" ON pattern_files FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "authenticated_update_pattern_files" ON pattern_files;
CREATE POLICY "authenticated_update_pattern_files" ON pattern_files FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "authenticated_delete_pattern_files" ON pattern_files;
CREATE POLICY "authenticated_delete_pattern_files" ON pattern_files FOR DELETE
  TO authenticated USING (true);

-- Create storage bucket for pattern assets
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'pattern-assets',
  'pattern-assets',
  true,
  52428800, -- 50MB limit
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'application/pdf', 'application/zip', 'image/svg+xml', 'application/dxf', 'application/postscript', 'video/mp4']
) ON CONFLICT (id) DO NOTHING;

-- Storage policies for public read
DROP POLICY IF EXISTS "Public read pattern assets" ON storage.objects;
CREATE POLICY "Public read pattern assets" ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'pattern-assets');

-- Authenticated users can upload
DROP POLICY IF EXISTS "Authenticated upload pattern assets" ON storage.objects;
CREATE POLICY "Authenticated upload pattern assets" ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'pattern-assets');

-- Authenticated users can update their uploads
DROP POLICY IF EXISTS "Authenticated update pattern assets" ON storage.objects;
CREATE POLICY "Authenticated update pattern assets" ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'pattern-assets');

-- Authenticated users can delete their uploads
DROP POLICY IF EXISTS "Authenticated delete pattern assets" ON storage.objects;
CREATE POLICY "Authenticated delete pattern assets" ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'pattern-assets');