/*
# Part 3c: Women's Patterns - Skirts (120), Pants (120), Jackets (80)
*/

DO $$
DECLARE
  cat_id UUID;
  inst_ids UUID[];
  pattern_slug TEXT;
  pattern_id UUID;
  i INT;
  difficulties TEXT[] := ARRAY['beginner', 'intermediate', 'advanced', 'professional'];
BEGIN
  SELECT array_agg(id) INTO inst_ids FROM instructors;
  
  -- SKIRTS (120)
  SELECT id INTO cat_id FROM categories WHERE slug = 'skirts' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..120 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'skirt-pattern-' || i,
        jsonb_build_object('en', 'A-Line Skirt Pattern ' || i, 'fr', 'Jupe Trapèze ' || i, 'ar', 'تنورة خط A ' || i),
        jsonb_build_object('en', 'Elegant skirt pattern suitable for all occasions.', 'fr', 'Patron de jupe élégant pour toutes occasions.', 'ar', 'نمط تنورة أنيق مناسب لجميع المناسبات.'),
        difficulties[1 + ((i-1) % 4)], 'skirt',
        jsonb_build_object('en', 'Cotton Blend', 'fr', 'Coton Mélangé', 'ar', 'مخلوط قطن'),
        random_between(60, 180), '["XS", "S", "M", "L", "XL"]'::jsonb,
        ARRAY['skirt', 'sewing', 'pattern', 'fashion', 'women'],
        random_between(300, 30000), random_between(70, 10000), random_between(30, 3000), random_between(10, 1000),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(5, 300), (i % 24 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (6200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (6200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Skirt photo", "fr": "Photo jupe", "ar": "صورة تنورة"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;
  
  -- PANTS (120)
  SELECT id INTO cat_id FROM categories WHERE slug = 'pants' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..120 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'pants-pattern-' || i,
        jsonb_build_object('en', 'Wide-Leg Pants Pattern ' || i, 'fr', 'Pantalon Large ' || i, 'ar', 'بنطلون واسع ' || i),
        jsonb_build_object('en', 'Comfortable and stylish pants pattern with professional fit.', 'fr', 'Patron de pantalon confortable et élégant.', 'ar', 'نمط بنطلون مريح وأنيق بقصة احترافية.'),
        difficulties[1 + ((i-1) % 4)], 'pants',
        jsonb_build_object('en', 'Denim', 'fr', 'Jean', 'ar', 'دينيم'),
        random_between(90, 300), '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['pants', 'sewing', 'pattern', 'fashion', 'women'],
        random_between(350, 35000), random_between(80, 12000), random_between(35, 3500), random_between(12, 1200),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(6, 350), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (6300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (6300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Pants photo", "fr": "Photo pantalon", "ar": "صورة بنطلون"}'::jsonb, 800, 1100);
    END LOOP;
  END IF;
  
  -- JACKETS & COATS (80)
  SELECT id INTO cat_id FROM categories WHERE slug = 'jackets-coats' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..80 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'jacket-pattern-' || i,
        jsonb_build_object('en', 'Classic Jacket Pattern ' || i, 'fr', 'Veste Classique ' || i, 'ar', 'جاكيت كلاسيكي ' || i),
        jsonb_build_object('en', 'Professional jacket pattern with lined construction.', 'fr', 'Patron de veste professionnelle avec doublure.', 'ar', 'نمط جاكيت احترافي مع بطانة.'),
        difficulties[1 + ((i-1) % 4)], 'jacket',
        jsonb_build_object('en', 'Wool Blend', 'fr', 'Mélange Laine', 'ar', 'مخلوط صوف'),
        random_between(180, 480), '["XS", "S", "M", "L", "XL"]'::jsonb,
        ARRAY['jacket', 'coat', 'sewing', 'pattern', 'fashion', 'outerwear'],
        random_between(400, 40000), random_between(90, 13000), random_between(40, 4000), random_between(15, 1500),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(8, 400), (i % 16 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (6400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (6400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Jacket photo", "fr": "Photo veste", "ar": "صورة جاكيت"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;
  
  RAISE NOTICE 'Created skirts, pants, and jackets patterns';
END $$;
