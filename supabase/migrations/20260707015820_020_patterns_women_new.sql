/*
# Add patterns for new subcategories - WOMEN
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
  
  -- WOMEN: Hoodies (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'hoodies' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'womens-hoodie-' || i,
        jsonb_build_object('en', 'Cozy Hoodie Pattern ' || i, 'fr', 'Hoodie Confortable ' || i, 'ar', 'هودي مريح ' || i),
        jsonb_build_object('en', 'Comfortable hoodie pattern with kangaroo pocket.', 'fr', 'Patron de hoodie confortable avec poche kangourou.', 'ar', 'نمط هودي مريح مع جيب كنغر.'),
        difficulties[1 + ((i-1) % 4)], 'hoodie',
        jsonb_build_object('en', 'French Terry', 'fr', 'Coton Éponge', 'ar', 'قطن إسفنجي'),
        random_between(90, 240), '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['hoodie', 'sewing', 'pattern', 'fashion', 'casual', 'women'],
        random_between(300, 30000), random_between(60, 8000), random_between(30, 3000), random_between(10, 1000),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(5, 200), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (6500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (6500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Hoodie photo", "fr": "Photo hoodie", "ar": "صورة هودي"}'::jsonb, 800, 900);
    END LOOP;
  END IF;

  -- WOMEN: Sportswear (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'sportswear-women' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'womens-sportswear-' || i,
        jsonb_build_object('en', 'Athletic Leggings Pattern ' || i, 'fr', 'Legging Sportif ' || i, 'ar', 'ليقينز رياضي ' || i),
        jsonb_build_object('en', 'Performance activewear pattern with stretch fabric.', 'fr', 'Patron de vetements de sport extensibles.', 'ar', 'نمط ملابس رياضية مطاطية عالية الأداء.'),
        difficulties[1 + ((i-1) % 4)], 'activewear',
        jsonb_build_object('en', 'Performance Knit', 'fr', 'Maille Technique', 'ar', 'تريكو تقني'),
        random_between(60, 180), '["XS", "S", "M", "L", "XL"]'::jsonb,
        ARRAY['sportswear', 'activewear', 'sewing', 'pattern', 'fitness', 'women'],
        random_between(250, 25000), random_between(50, 7000), random_between(25, 2500), random_between(8, 800),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(4, 180), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (6600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (6600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Sportswear photo", "fr": "Photo sportif", "ar": "صورة رياضية"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;

  -- WOMEN: Lingerie (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'lingerie' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'womens-lingerie-' || i,
        jsonb_build_object('en', 'Bralette Pattern ' || i, 'fr', 'Brassiere ' || i, 'ar', 'حمالة صدر ' || i),
        jsonb_build_object('en', 'Delicate lingerie pattern with lace details.', 'fr', 'Patron de lingerie delicate avec dentelle.', 'ar', 'نمط ملابس داخلية رقيقة مع دانتيل.'),
        difficulties[1 + ((i-1) % 4)], 'lingerie',
        jsonb_build_object('en', 'Lace', 'fr', 'Dentelle', 'ar', 'دانتيل'),
        random_between(45, 120), '["XS", "S", "M", "L", "XL"]'::jsonb,
        ARRAY['lingerie', 'sewing', 'pattern', 'intimate', 'women'],
        random_between(200, 20000), random_between(40, 6000), random_between(20, 2000), random_between(5, 600),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(3, 150), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (6700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (6700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Lingerie photo", "fr": "Photo lingerie", "ar": "صورة ملابس داخلية"}'::jsonb, 800, 800);
    END LOOP;
  END IF;

  RAISE NOTICE 'Created women hoodies, sportswear, and lingerie patterns';
END $$;
