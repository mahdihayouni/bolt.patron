/*
# Add patterns for MEN new subcategories
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
  
  -- MEN: Pants (50)
  SELECT id INTO cat_id FROM categories WHERE slug = 'pants-men' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..50 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-pants-' || i,
        jsonb_build_object('en', 'Classic Dress Pants ' || i, 'fr', 'Pantalon Habille ' || i, 'ar', 'بنطلون رسمي ' || i),
        jsonb_build_object('en', 'Professional dress pants with tailored fit.', 'fr', 'Pantalon habille avec coupe ajustee.', 'ar', 'بنطلون رسمي بقصة مفصلة.'),
        difficulties[1 + ((i-1) % 4)], 'pants',
        jsonb_build_object('en', 'Wool Blend', 'fr', 'Melange Laine', 'ar', 'مخلوط صوف'),
        random_between(90, 240), '["S", "M", "L", "XL", "XXL", "XXXL"]'::jsonb,
        ARRAY['pants', 'menswear', 'sewing', 'pattern', 'formal', 'men'],
        random_between(300, 30000), random_between(50, 8000), random_between(25, 2500), random_between(8, 800),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(4, 200), (i % 25 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (7300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (7300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Pants photo", "fr": "Photo pantalon", "ar": "صورة بنطلون"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;

  -- MEN: Jackets (50)
  SELECT id INTO cat_id FROM categories WHERE slug = 'jackets-men' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..50 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-jacket-' || i,
        jsonb_build_object('en', 'Blazer Pattern ' || i, 'fr', 'Blazer ' || i, 'ar', 'بليزر ' || i),
        jsonb_build_object('en', 'Sharp blazer pattern with professional tailoring.', 'fr', 'Blazer avec tailoring professionnel.', 'ar', 'نمط بليزر أنيق بتفصيل احترافي.'),
        difficulties[1 + ((i-1) % 4)], 'jacket',
        jsonb_build_object('en', 'Wool Tweed', 'fr', 'Tweed Laine', 'ar', 'تويد صوف'),
        random_between(180, 420), '["S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['jacket', 'blazer', 'menswear', 'sewing', 'pattern', 'formal', 'men'],
        random_between(400, 40000), random_between(80, 10000), random_between(40, 4000), random_between(15, 1200),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(8, 350), (i % 25 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (7400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (7400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Jacket photo", "fr": "Photo veste", "ar": "صورة جاكيت"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;

  -- MEN: Hoodies (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'hoodies-men' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-hoodie-' || i,
        jsonb_build_object('en', 'Mens Hoodie Pattern ' || i, 'fr', 'Hoodie Homme ' || i, 'ar', 'هودي رجالي ' || i),
        jsonb_build_object('en', 'Casual hoodie with front pocket.', 'fr', 'Hoodie decontracte avec poche avant.', 'ar', 'هودي كاجوال مع جيب أمامي.'),
        difficulties[1 + ((i-1) % 4)], 'hoodie',
        jsonb_build_object('en', 'Fleece', 'fr', 'Polaire', 'ar', 'فليس'),
        random_between(90, 200), '["S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['hoodie', 'menswear', 'sewing', 'pattern', 'casual', 'men'],
        random_between(250, 25000), random_between(50, 7000), random_between(25, 2500), random_between(8, 700),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(4, 180), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (7500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (7500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Hoodie photo", "fr": "Photo hoodie", "ar": "صورة هودي"}'::jsonb, 800, 900);
    END LOOP;
  END IF;

  -- MEN: Sportswear (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'sportswear-men' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-sportswear-' || i,
        jsonb_build_object('en', 'Athletic Shorts ' || i, 'fr', 'Short Sportif ' || i, 'ar', 'شورت رياضي ' || i),
        jsonb_build_object('en', 'Performance athletic shorts pattern.', 'fr', 'Patron de short sportif performance.', 'ar', 'نمط شورت رياضي عالي الأداء.'),
        difficulties[1 + ((i-1) % 4)], 'activewear',
        jsonb_build_object('en', 'Athletic Knit', 'fr', 'Maille Athletique', 'ar', 'تريكو رياضي'),
        random_between(45, 120), '["S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['sportswear', 'activewear', 'menswear', 'sewing', 'pattern', 'men'],
        random_between(200, 20000), random_between(40, 6000), random_between(20, 2000), random_between(6, 600),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(3, 150), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (7600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (7600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Sportswear photo", "fr": "Photo sport", "ar": "صورة رياضية"}'::jsonb, 800, 900);
    END LOOP;
  END IF;

  -- MEN: Shorts (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'shorts' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-shorts-' || i,
        jsonb_build_object('en', 'Casual Shorts ' || i, 'fr', 'Short Decontracte ' || i, 'ar', 'شورت كاجوال ' || i),
        jsonb_build_object('en', 'Comfortable casual shorts for everyday wear.', 'fr', 'Short decontracte pour tous les jours.', 'ar', 'شورت مريح للارتداء اليومي.'),
        difficulties[1 + ((i-1) % 4)], 'shorts',
        jsonb_build_object('en', 'Cotton Twill', 'fr', 'Twill Coton', 'ar', 'تويل قطن'),
        random_between(45, 120), '["S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['shorts', 'menswear', 'sewing', 'pattern', 'casual', 'men'],
        random_between(180, 18000), random_between(35, 5000), random_between(18, 1800), random_between(5, 500),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(3, 120), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (7700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (7700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Shorts photo", "fr": "Photo short", "ar": "صورة شورت"}'::jsonb, 800, 800);
    END LOOP;
  END IF;

  -- MEN: Coats (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'coats-men' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-coat-' || i,
        jsonb_build_object('en', 'Overcoat Pattern ' || i, 'fr', 'Manteau ' || i, 'ar', 'معطف ' || i),
        jsonb_build_object('en', 'Classic overcoat pattern with professional construction.', 'fr', ' Manteau classique avec construction pro.', 'ar', 'نمط معطف كلاسيكي ببناء احترافي.'),
        difficulties[1 + ((i-1) % 4)], 'coat',
        jsonb_build_object('en', 'Wool', 'fr', 'Laine', 'ar', 'صوف'),
        random_between(240, 480), '["S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['coat', 'outerwear', 'menswear', 'sewing', 'pattern', 'formal', 'men'],
        random_between(350, 35000), random_between(70, 9000), random_between(35, 3500), random_between(12, 1000),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(6, 250), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (7800000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (7800000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Coat photo", "fr": "Photo manteau", "ar": "صورة معطف"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;

  RAISE NOTICE 'Created mens new subcategory patterns';
END $$;
