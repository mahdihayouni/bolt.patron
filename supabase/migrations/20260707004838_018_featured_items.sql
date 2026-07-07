/*
# Part 7: Set Featured Items for Homepage

Mark specific patterns and courses as featured to display on homepage.
*/

-- Set featured patterns (top rated with high engagement)
UPDATE patterns 
SET is_featured = true 
WHERE id IN (
  SELECT id FROM patterns 
  WHERE rating_average >= 4.5 AND downloads_count > 1000
  ORDER BY rating_average DESC, downloads_count DESC
  LIMIT 30
);

-- Set featured courses
UPDATE courses 
SET is_featured = true 
WHERE id IN (
  SELECT id FROM courses 
  WHERE rating_average >= 4.5
  ORDER BY rating_average DESC, enrolled_count DESC
  LIMIT 15
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_patterns_category_featured 
ON patterns(category_id) WHERE is_featured = true AND is_published = true;

CREATE INDEX IF NOT EXISTS idx_patterns_published_rating 
ON patterns(rating_average DESC) WHERE is_published = true;

CREATE INDEX IF NOT EXISTS idx_courses_featured 
ON courses(rating_average DESC) WHERE is_featured = true AND is_published = true;

CREATE INDEX IF NOT EXISTS idx_patterns_created_at 
ON patterns(created_at DESC) WHERE is_published = true;

CREATE INDEX IF NOT EXISTS idx_patterns_downloads 
ON patterns(downloads_count DESC) WHERE is_published = true;
