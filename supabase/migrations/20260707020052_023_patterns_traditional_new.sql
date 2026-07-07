/*
# Add patterns for TRADITIONAL new subcategories
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

  -- TRADITIONAL: Djellabas (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'djellabas' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'djellaba-' || i, jsonb_build_object('en', 'Moroccan Djellaba ' || i, 'fr', 'Djellaba Marocaine ' || i, 'ar', 'جلاليب مغربية ' || i), jsonb_build_object('en', 'Traditional Moroccan djellaba pattern.', 'fr', 'Patron de djellaba marocaine traditionnelle.', 'ar', 'نمط جلابة مغربية تقليدية.'), difficulties[1 + ((i-1) % 4)], 'djellaba', jsonb_build_object('en', 'Cotton', 'fr', 'Coton', 'ar', 'قطن'), random_between(120, 300), '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb, ARRAY['djellaba', 'traditional', 'moroccan', 'sewing', 'pattern'], random_between(350, 35000), random_between(80, 10000), random_between(40, 4000), random_between(15, 1200), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(8, 300), (i % 20 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (10000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (10000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Djellaba photo", "fr": "Photo djellaba", "ar": "صورة جلابة"}'::jsonb, 800, 1200);
    END LOOP;
  END IF;

  -- TRADITIONAL: Takchita (35)
  SELECT id INTO cat_id FROM categories WHERE slug = 'takchita' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..35 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'takchita-' || i, jsonb_build_object('en', 'Takchita Pattern ' || i, 'fr', 'Takchita ' || i, 'ar', 'تقشيتة ' || i), jsonb_build_object('en', 'Elaborate Moroccan takchita dress pattern.', 'fr', 'Patron de takchita marocaine elaboree.', 'ar', 'نمط تقشيتة مغربية مفصلة.'), difficulties[1 + ((i-1) % 4)], 'takchita', jsonb_build_object('en', 'Brocade', 'fr', 'Brocart', 'ar', 'بروكار'), random_between(200, 480), '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb, ARRAY['takchita', 'traditional', 'moroccan', 'bridal', 'sewing', 'pattern'], random_between(450, 45000), random_between(100, 12000), random_between(50, 5000), random_between(20, 1500), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(10, 350), (i % 17 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (10100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (10100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Takchita photo", "fr": "Photo takchita", "ar": "صورة تقشيتة"}'::jsonb, 800, 1200);
    END LOOP;
  END IF;

  -- TRADITIONAL: Jebba (30)
  SELECT id INTO cat_id FROM categories WHERE slug = 'jebba' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'jebba-' || i, jsonb_build_object('en', 'Tunisian Jebba ' || i, 'fr', 'Jebba Tunisienne ' || i, 'ar', 'جبة تونسية ' || i), jsonb_build_object('en', 'Traditional Tunisian jebba pattern.', 'fr', 'Patron de jebba tunisienne traditionnelle.', 'ar', 'نمط جبة تونسية تقليدية.'), difficulties[1 + ((i-1) % 4)], 'jebba', jsonb_build_object('en', 'Silk', 'fr', 'Soie', 'ar', 'حرير'), random_between(150, 320), '["S", "M", "L", "XL", "XXL"]'::jsonb, ARRAY['jebba', 'traditional', 'tunisian', 'sewing', 'pattern'], random_between(300, 30000), random_between(70, 8000), random_between(35, 3500), random_between(12, 1000), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(6, 250), (i % 15 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (10200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (10200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Jebba photo", "fr": "Photo jebba", "ar": "صورة جبة"}'::jsonb, 800, 1100);
    END LOOP;
  END IF;

  -- TRADITIONAL: Gandoura (30)
  SELECT id INTO cat_id FROM categories WHERE slug = 'gandoura' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'gandoura-' || i, jsonb_build_object('en', 'Gandoura Pattern ' || i, 'fr', 'Gandoura ' || i, 'ar', 'قندورة ' || i), jsonb_build_object('en', 'Traditional gandoura tunic pattern.', 'fr', 'Patron de gandoura traditionnelle.', 'ar', 'نمط قندورة تقليدية.'), difficulties[1 + ((i-1) % 4)], 'gandoura', jsonb_build_object('en', 'Cotton', 'fr', 'Coton', 'ar', 'قطن'), random_between(100, 240), '["S", "M", "L", "XL", "XXL"]'::jsonb, ARRAY['gandoura', 'traditional', 'sewing', 'pattern'], random_between(280, 28000), random_between(60, 7000), random_between(30, 3000), random_between(10, 800), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(5, 200), (i % 15 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (10300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (10300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Gandoura photo", "fr": "Photo gandoura", "ar": "صورة قندورة"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;

  -- TRADITIONAL: Traditional Dresses (35)
  SELECT id INTO cat_id FROM categories WHERE slug = 'traditional-dresses' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..35 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'traditional-dress-' || i, jsonb_build_object('en', 'Traditional Dress ' || i, 'fr', 'Robe Traditionnelle ' || i, 'ar', 'فستان تقليدي ' || i), jsonb_build_object('en', 'Beautiful traditional dress pattern from around the world.', 'fr', 'Magnifique patron de robe traditionnelle.', 'ar', 'نمط فستان تقليدي جميل من مختلف انحاء العالم.'), difficulties[1 + ((i-1) % 4)], 'dress', jsonb_build_object('en', 'Cotton Silk', 'fr', 'Coton Soie', 'ar', 'قطن حرير'), random_between(120, 300), '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb, ARRAY['traditional', 'dress', 'cultural', 'sewing', 'pattern'], random_between(320, 32000), random_between(70, 8000), random_between(35, 3500), random_between(12, 1000), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(6, 250), (i % 17 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (10400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (10400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Traditional dress photo", "fr": "Photo robe traditionnelle", "ar": "صورة فستان تقليدي"}'::jsonb, 800, 1200);
    END LOOP;
  END IF;

  -- TRADITIONAL: Traditional Mens Wear (30)
  SELECT id INTO cat_id FROM categories WHERE slug = 'traditional-mens-wear' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'mens-traditional-' || i, jsonb_build_object('en', 'Thobe Pattern ' || i, 'fr', 'Thobe ' || i, 'ar', 'ثوب ' || i), jsonb_build_object('en', 'Traditional mens thobe pattern.', 'fr', 'Patron de thobe traditionnel homme.', 'ar', 'نمط ثوب رجالي تقليدي.'), difficulties[1 + ((i-1) % 4)], 'thobe', jsonb_build_object('en', 'Cotton', 'fr', 'Coton', 'ar', 'قطن'), random_between(120, 280), '["S", "M", "L", "XL", "XXL"]'::jsonb, ARRAY['thobe', 'traditional', 'menswear', 'sewing', 'pattern'], random_between(350, 35000), random_between(80, 9000), random_between(40, 4000), random_between(15, 1100), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(8, 300), (i % 15 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (10500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (10500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Thobe photo", "fr": "Photo thobe", "ar": "صورة ثوب"}'::jsonb, 800, 1100);
    END LOOP;
  END IF;

  RAISE NOTICE 'Created traditional patterns';
END $$;
