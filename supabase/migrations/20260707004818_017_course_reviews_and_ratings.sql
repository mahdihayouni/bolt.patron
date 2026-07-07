/*
# Part 6: Course Reviews and Update Pattern Ratings
*/

DO $$
DECLARE
  course_rec RECORD;
  counter INT := 0;
BEGIN
  -- Add reviews for courses
  FOR course_rec IN SELECT id FROM courses LOOP
    FOR counter IN 1..random_between(10, 30) LOOP
      INSERT INTO reviews (
        entity_type, entity_id, rating, title, content,
        reviewer_name, reviewer_location,
        is_verified, helpful_count, created_at
      ) VALUES (
        'course',
        course_rec.id,
        random_between(4, 5),
        (ARRAY['Excellent course!', 'Very helpful', 'Great instructor', 'Learned so much', 'Highly recommended'])[1 + (counter % 5)],
        (ARRAY[
          'This course really helped me improve my sewing skills. The instructor explains everything clearly.',
          'I learned so much from this course. The lessons are well-structured and easy to follow.',
          'Great content and professional presentation. Will definitely take more courses.',
          'Exactly what I needed to take my skills to the next level. Highly recommend it.',
          'Wonderful experience. The downloadable resources were very helpful.'
        ])[1 + (counter % 5)],
        (ARRAY['Emma', 'Sophia', 'Olivia', 'Ava', 'Isabella', 'Mia', 'Charlotte', 'Amelia', 'Harper', 'Evelyn'])[1 + (counter % 10)],
        (ARRAY['NYC', 'LA', 'London', 'Paris', 'Sydney', 'Toronto', 'Berlin', 'Tokyo', 'Dubai', 'Singapore'])[1 + (counter % 10)],
        true,
        random_between(5, 50),
        random_past_date()
      );
    END LOOP;
  END LOOP;
  
  -- Update pattern ratings based on reviews
  UPDATE patterns p SET
    rating_average = COALESCE(
      (SELECT AVG(r.rating) FROM reviews r WHERE r.entity_id = p.id AND r.entity_type = 'pattern'),
      4.5
    ),
    rating_count = COALESCE(
      (SELECT COUNT(*) FROM reviews r WHERE r.entity_id = p.id AND r.entity_type = 'pattern'),
      0
    );
  
  -- Update course ratings
  UPDATE courses c SET
    rating_average = COALESCE(
      (SELECT AVG(r.rating)::numeric FROM reviews r WHERE r.entity_id = c.id AND r.entity_type = 'course'),
      4.5
    ),
    rating_count = COALESCE(
      (SELECT COUNT(*)::int FROM reviews r WHERE r.entity_id = c.id AND r.entity_type = 'course'),
      0
    );
  
  RAISE NOTICE 'Updated ratings for all patterns and courses';
END $$;
