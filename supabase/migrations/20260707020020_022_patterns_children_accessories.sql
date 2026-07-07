/*
# Add patterns for CHILDREN, ACCESSORIES new subcategories
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

  -- CHILDREN: Pajamas (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'pajamas' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'kids-pajamas-' || i,
        jsonb_build_object('en', 'Kids Pajamas ' || i, 'fr', 'Pyjama Enfant ' || i, 'ar', 'بيجاما أطفال ' || i),
        jsonb_build_object('en', 'Cozy pajama set for children.', 'fr', 'Ensemble pyjama confortable pour enfant.', 'ar', 'طقم بيجاما دافئ للأطفال.'),
        difficulties[1 + ((i-1) % 4)], 'pajamas',
        jsonb_build_object('en', 'Cotton Jersey', 'fr', 'Jersey Coton', 'ar', 'جيرسي قطن'),
        random_between(60, 150), '["2T", "3T", "4T", "5", "6", "7", "8"]'::jsonb,
        ARRAY['pajamas', 'sleepwear', 'children', 'sewing', 'pattern', 'kids'],
        random_between(150, 15000), random_between(30, 5000), random_between(15, 1500), random_between(5, 400),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(3, 120), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (8500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (8500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Pajamas photo", "fr": "Photo pyjama", "ar": "صورة بيجاما"}'::jsonb, 800, 900);
    END LOOP;
  END IF;

  -- CHILDREN: School Uniforms (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'school-uniforms' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'school-uniform-' || i,
        jsonb_build_object('en', 'School Uniform Pattern ' || i, 'fr', 'Uniforme Scolaire ' || i, 'ar', 'زي مدرسي ' || i),
        jsonb_build_object('en', 'Classic school uniform pattern for children.', 'fr', 'Patron uniforme scolaire classique.', 'ar', 'نمط زي مدرسي كلاسيكي للأطفال.'),
        difficulties[1 + ((i-1) % 4)], 'uniform',
        jsonb_build_object('en', 'Cotton Blend', 'fr', 'Coton Mele', 'ar', 'مخلوط قطن'),
        random_between(90, 200), '["4", "5", "6", "7", "8", "10", "12"]'::jsonb,
        ARRAY['school', 'uniform', 'children', 'sewing', 'pattern', 'kids'],
        random_between(180, 18000), random_between(40, 6000), random_between(20, 2000), random_between(6, 600),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(4, 150), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (8600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (8600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Uniform photo", "fr": "Photo uniforme", "ar": "صورة زي"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;

  -- CHILDREN: Jackets (40)
  SELECT id INTO cat_id FROM categories WHERE slug = 'jackets-children' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..40 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'kids-jacket-' || i,
        jsonb_build_object('en', 'Kids Jacket ' || i, 'fr', 'Veste Enfant ' || i, 'ar', 'جاكيت أطفال ' || i),
        jsonb_build_object('en', 'Warm jacket pattern for children.', 'fr', 'Patron de veste chaude pour enfant.', 'ar', 'نمط جاكيت دافئ للأطفال.'),
        difficulties[1 + ((i-1) % 4)], 'jacket',
        jsonb_build_object('en', 'Fleece', 'fr', 'Polaire', 'ar', 'فليس'),
        random_between(90, 200), '["2T", "3T", "4T", "5", "6", "7", "8"]'::jsonb,
        ARRAY['jacket', 'outerwear', 'children', 'sewing', 'pattern', 'kids'],
        random_between(200, 20000), random_between(45, 6500), random_between(22, 2200), random_between(7, 650),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(4, 160), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (8700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (8700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Jacket photo", "fr": "Photo veste", "ar": "صورة جاكيت"}'::jsonb, 800, 900);
    END LOOP;
  END IF;

  -- ACCESSORIES: Belts (30)
  SELECT id INTO cat_id FROM categories WHERE slug = 'belts' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'belt-' || i,
        jsonb_build_object('en', 'Leather Belt Pattern ' || i, 'fr', 'Ceinture Cuir ' || i, 'ar', 'حزام جلدي ' || i),
        jsonb_build_object('en', 'Classic belt pattern with buckle.', 'fr', 'Patron de ceinture classique avec boucle.', 'ar', 'نمط حزام كلاسيكي مع إبزيم.'),
        difficulties[1 + ((i-1) % 4)], 'belt',
        jsonb_build_object('en', 'Leather', 'fr', 'Cuir', 'ar', 'جلد'),
        random_between(30, 90), '["S", "M", "L", "XL"]'::jsonb,
        ARRAY['belt', 'accessory', 'sewing', 'pattern', 'leather'],
        random_between(100, 10000), random_between(25, 4000), random_between(12, 1200), random_between(4, 350),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(2, 100), (i % 15 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (9400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (9400000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Belt photo", "fr": "Photo ceinture", "ar": "صورة حزام"}'::jsonb, 800, 600);
    END LOOP;
  END IF;

  -- ACCESSORIES: Scarves (30)
  SELECT id INTO cat_id FROM categories WHERE slug = 'scarves' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'scarf-' || i,
        jsonb_build_object('en', 'Infinity Scarf ' || i, 'fr', 'Foulard Infini ' || i, 'ar', 'وشاح دائري ' || i),
        jsonb_build_object('en', 'Cozy infinity scarf pattern.', 'fr', 'Patron de foulard infini confortable.', 'ar', 'نمط وشاح دائري دافئ.'),
        difficulties[1 + ((i-1) % 4)], 'scarf',
        jsonb_build_object('en', 'Soft Knit', 'fr', 'Maille Douce', 'ar', 'تريكو ناعم'),
        random_between(30, 60), '["One Size"]'::jsonb,
        ARRAY['scarf', 'accessory', 'sewing', 'pattern', 'winter'],
        random_between(100, 10000), random_between(30, 5000), random_between(15, 1500), random_between(5, 450),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(3, 120), (i % 15 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id, 'https://images.pexels.com/photos/' || (9500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (9500000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Scarf photo", "fr": "Photo foulard", "ar": "صورة وشاح"}'::jsonb, 800, 600);
    END LOOP;
  END IF;

  -- ACCESSORIES: Gloves + Aprons + Wallets + Hair Accessories (condensed)
  SELECT id INTO cat_id FROM categories WHERE slug = 'gloves' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'gloves-' || i, jsonb_build_object('en', 'Winter Gloves ' || i, 'fr', 'Gants Hiver ' || i, 'ar', 'قفازات شتوية ' || i), jsonb_build_object('en', 'Warm winter gloves pattern.', 'fr', 'Patron de gants dhiver chauds.', 'ar', 'نمط قفازات شتوية دافئة.'), difficulties[1 + ((i-1) % 4)], 'gloves', jsonb_build_object('en', 'Wool Blend', 'fr', 'Melange Laine', 'ar', 'مخلوط صوف'), random_between(45, 90), '["S", "M", "L"]'::jsonb, ARRAY['gloves', 'accessory', 'sewing', 'pattern'], random_between(80, 8000), random_between(20, 3000), random_between(10, 1000), random_between(3, 300), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(2, 80), (i % 15 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (9600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (9600000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Gloves photo", "fr": "Photo gants", "ar": "صورة قفازات"}'::jsonb, 800, 600);
    END LOOP;
  END IF;

  SELECT id INTO cat_id FROM categories WHERE slug = 'aprons' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'apron-' || i, jsonb_build_object('en', 'Kitchen Apron ' || i, 'fr', 'Tablier Cuisine ' || i, 'ar', 'مئزر مطبخ ' || i), jsonb_build_object('en', 'Practical kitchen apron pattern.', 'fr', 'Patron de tablier de cuisine pratique.', 'ar', 'نمط مئزر مطبخ عملي.'), difficulties[1 + ((i-1) % 4)], 'apron', jsonb_build_object('en', 'Heavy Cotton', 'fr', 'Coton Epais', 'ar', 'قطن سميك'), random_between(45, 90), '["One Size"]'::jsonb, ARRAY['apron', 'accessory', 'sewing', 'pattern', 'kitchen'], random_between(100, 10000), random_between(35, 5500), random_between(18, 1800), random_between(6, 500), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(3, 130), (i % 15 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (9700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (9700000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Apron photo", "fr": "Photo tablier", "ar": "صورة مئزر"}'::jsonb, 800, 900);
    END LOOP;
  END IF;

  SELECT id INTO cat_id FROM categories WHERE slug = 'wallets' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'wallet-' || i, jsonb_build_object('en', 'Bifold Wallet ' || i, 'fr', 'Portefeuille ' || i, 'ar', 'محفظة ' || i), jsonb_build_object('en', 'Classic bifold wallet pattern.', 'fr', 'Patron de portefeuille classique.', 'ar', 'نمط محفظة كلاسيكية.'), difficulties[1 + ((i-1) % 4)], 'wallet', jsonb_build_object('en', 'Leather', 'fr', 'Cuir', 'ar', 'جلد'), random_between(60, 120), '["One Size"]'::jsonb, ARRAY['wallet', 'accessory', 'sewing', 'pattern', 'leather'], random_between(100, 10000), random_between(25, 4000), random_between(12, 1200), random_between(4, 350), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(2, 100), (i % 15 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (9800000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (9800000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Wallet photo", "fr": "Photo portefeuille", "ar": "صورة محفظة"}'::jsonb, 800, 600);
    END LOOP;
  END IF;

  SELECT id INTO cat_id FROM categories WHERE slug = 'hair-accessories' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..30 LOOP
      INSERT INTO patterns (category_id, instructor_id, slug, title, description, difficulty, garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags, views_count, downloads_count, likes_count, saves_count, rating_average, rating_count, is_featured, is_published, published_at, created_at)
      VALUES (cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'hair-accessory-' || i, jsonb_build_object('en', 'Headband Pattern ' || i, 'fr', 'Bandeau ' || i, 'ar', 'طوق شعر ' || i), jsonb_build_object('en', 'Stylish headband pattern with bow detail.', 'fr', 'Patron de bandeau avec noeud.', 'ar', 'نمط طوق شعر أنيق مع قوس.'), difficulties[1 + ((i-1) % 4)], 'hair accessory', jsonb_build_object('en', 'Cotton', 'fr', 'Coton', 'ar', 'قطن'), random_between(20, 45), '["One Size"]'::jsonb, ARRAY['hair', 'accessory', 'headband', 'sewing', 'pattern'], random_between(80, 8000), random_between(25, 4000), random_between(15, 1500), random_between(5, 400), ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(2, 100), (i % 15 = 0), true, random_past_date(), random_past_date()) RETURNING id INTO pattern_id;
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height) VALUES (pattern_id, 'https://images.pexels.com/photos/' || (9900000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800', 'https://images.pexels.com/photos/' || (9900000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300', 'photo', 0, true, '{"en": "Hair accessory photo", "fr": "Photo accessoire", "ar": "صورة اكسسوار"}'::jsonb, 800, 600);
    END LOOP;
  END IF;

  RAISE NOTICE 'Created children and accessories patterns';
END $$;
