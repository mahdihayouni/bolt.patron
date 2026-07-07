/*
# Part 3d: Men's Patterns - Shirts (120), Pants (100), Suits (60), Jackets (80)
*/

DO $$
DECLARE
  cat_id UUID;
  inst_ids UUID[];
  pattern_id UUID;
  i INT;
  difficulties TEXT[] := ARRAY['beginner', 'intermediate', 'advanced', 'professional'];
BEGIN
  SELECT array_agg(id) INTO inst_ids FROM instructors;
  
  -- SHIRTS (120)
  SELECT id INTO cat_id FROM categories WHERE slug = 'shirts' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..120 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-shirt-' || i,
        jsonb_build_object('en', 'Classic Shirt Pattern ' || i, 'fr', 'Chemise Classique ' || i, 'ar', 'قميص كلاسيكي ' || i),
        jsonb_build_object('en', 'Professional mens shirt pattern with collar and cuffs.', 'fr', 'Patron de chemise homme professionnelle.', 'ar', 'نمط قميص رجالي احترافي بياقة وأكمام.'),
        difficulties[1 + ((i-1) % 4)], 'shirt',
        jsonb_build_object('en', 'Cotton Poplin', 'fr', 'Popeline Coton', 'ar', 'بوبلين قطن'),
        random_between(90, 240), '["S", "M", "L", "XL", "XXL", "XXXL"]'::jsonb,
        ARRAY['shirt', 'menswear', 'sewing', 'pattern', 'fashion', 'men'],
        random_between(300, 35000), random_between(60, 10000), random_between(30, 3000), random_between(10, 1000),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(5, 350), (i % 24 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (7000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (7000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Shirt photo", "fr": "Photo chemise", "ar": "صورة قميص"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;
  
  -- SUITS (60)
  SELECT id INTO cat_id FROM categories WHERE slug = 'suits' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..60 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-suit-' || i,
        jsonb_build_object('en', 'Tailored Suit Pattern ' || i, 'fr', 'Costume Sur Mesure ' || i, 'ar', 'بدلة مفصلة ' || i),
        jsonb_build_object('en', 'Professional suit pattern with jacket and trousers.', 'fr', 'Patron de costume complet avec veste et pantalon.', 'ar', 'نمط بدلة احترافية مع جاكيت وبنطلون.'),
        difficulties[1 + ((i-1) % 4)], 'suit',
        jsonb_build_object('en', 'Wool Suiting', 'fr', 'Tissu Costume', 'ar', 'قماش بدلات'),
        random_between(300, 600), '["S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['suit', 'menswear', 'sewing', 'pattern', 'fashion', 'formal', 'men'],
        random_between(500, 50000), random_between(100, 15000), random_between(50, 5000), random_between(20, 2000),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(10, 500), (i % 15 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (7100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (7100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Suit photo", "fr": "Photo costume", "ar": "صورة بدلة"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;
  
  RAISE NOTICE 'Created mens shirts and suits patterns';
END $$;
