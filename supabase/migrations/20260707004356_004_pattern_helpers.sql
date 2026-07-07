/*
# Part 2: Pattern Generation Function

Creates a helper function to generate patterns programmatically.
This approach avoids the JSON escaping issues.
*/

-- Helper functions
CREATE OR REPLACE FUNCTION random_between(low INT, high INT) 
RETURNS INT AS $$
BEGIN
  RETURN floor(random() * (high - low + 1) + low);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_past_date() 
RETURNS TIMESTAMPTZ AS $$
BEGIN
  RETURN now() - (random() * 365 || ' days')::interval;
END;
$$ LANGUAGE plpgsql;

-- Get category and instructor IDs for use in pattern generation
CREATE TABLE IF NOT EXISTS temp_pattern_ids (
  category_id UUID,
  instructor_id UUID,
  priority INT
);

-- Populate temp table with category-instructor pairs
INSERT INTO temp_pattern_ids (category_id, instructor_id, priority)
SELECT c.id, i.id, row_number() OVER (PARTITION BY c.id ORDER BY random())
FROM categories c
CROSS JOIN instructors i
WHERE c.parent_id IS NOT NULL;

-- Clear existing patterns to start fresh (optional - comment out if you want to keep)
-- DELETE FROM pattern_images;
-- DELETE FROM patterns WHERE id NOT IN (SELECT MIN(id) FROM patterns);
