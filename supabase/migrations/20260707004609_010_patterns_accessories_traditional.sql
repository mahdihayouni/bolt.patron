/*
# Part 3f: Accessories - Bags (60), Hats (50)
# Part 3g: Traditional - Abayas (60), Kaftans (50)
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
  
  -- BAGS (60)
  SELECT id INTO cat_id FROM categories WHERE slug = 'bags' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..60 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'bag-pattern-' || i,
        jsonb_build_object('en', 'Tote Bag Pattern ' || i, 'fr', 'Sac Cabas ' || i, 'ar', 'حقيبة ' || i),
        jsonb_build_object('en', 'Beautiful bag pattern with professional finishing.', 'fr', 'Magnifique patron de sac avec finitions professionnelles.', 'ar', 'نمط حقيبة جميلة مع تشطيبات احترافية.'),
        difficulties[1 + ((i-1) % 4)], 'bag',
        jsonb_build_object('en', 'Canvas', 'fr', 'Toile', 'ar', 'كانفاس'),
        random_between(60, 180), '["One Size"]'::jsonb,
        ARRAY['bag', 'accessory', 'sewing', 'pattern', 'fashion'],
        random_between(200, 20000), random_between(60, 8000), random_between(30, 3000), random_between(10, 1000),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(5, 300), (i % 15 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (9000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (9000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Bag photo", "fr": "Photo sac", "ar": "صورة حقيبة"}'::jsonb, 800, 800);
    END LOOP;
  END IF;
  
  -- HATS (50)
  SELECT id INTO cat_id FROM categories WHERE slug = 'hats' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..50 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'hat-pattern-' || i,
        jsonb_build_object('en', 'Sun Hat Pattern ' || i, 'fr', 'Chapeau de Soleil ' || i, 'ar', 'قبعة شمس ' || i),
        jsonb_build_object('en', 'Stylish hat pattern for sunny days.', 'fr', 'Patron de chapeau élégant pour les jours ensoleillés.', 'ar', 'نمط قبعة أنيق للأيام المشمسة.'),
        difficulties[1 + ((i-1) % 4)], 'hat',
        jsonb_build_object('en', 'Straw Fabric', 'fr', 'Paille Tissée', 'ar', 'قش'),
        random_between(30, 90), '["S", "M", "L"]'::jsonb,
        ARRAY['hat', 'accessory', 'sewing', 'pattern', 'fashion', 'summer'],
        random_between(150, 15000), random_between(40, 6000), random_between(20, 2000), random_between(5, 600),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(4, 200), (i % 12 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (9100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (9100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Hat photo", "fr": "Photo chapeau", "ar": "صورة قبعة"}'::jsonb, 800, 800);
    END LOOP;
  END IF;
  
  -- ABAYAS (60)
  SELECT id INTO cat_id FROM categories WHERE slug = 'abayas' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..60 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'abaya-pattern-' || i,
        jsonb_build_object('en', 'Classic Abaya Pattern ' || i, 'fr', 'Abaya Classique ' || i, 'ar', 'عباية كلاسيكية ' || i),
        jsonb_build_object('en', 'Elegant traditional abaya pattern with modern touches.', 'fr', 'Patron d''abaya traditionnelle élégante avec touches modernes.', 'ar', 'نمط عباية تقليدية أنيقة مع لمسات عصرية.'),
        difficulties[1 + ((i-1) % 4)], 'abaya',
        jsonb_build_object('en', 'Crepe', 'fr', 'Crêpe', 'ar', 'كريب'),
        random_between(120, 300), '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['abaya', 'traditional', 'sewing', 'pattern', 'fashion', 'modest'],
        random_between(400, 40000), random_between(100, 12000), random_between(50, 5000), random_between(20, 2000),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(10, 400), (i % 15 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (9200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (9200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Abaya photo", "fr": "Photo abaya", "ar": "صورة عباية"}'::jsonb, 800, 1200);
    END LOOP;
  END IF;
  
  -- KAFTANS (50)
  SELECT id INTO cat_id FROM categories WHERE slug = 'kaftans' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..50 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'kaftan-pattern-' || i,
        jsonb_build_object('en', 'Moroccan Kaftan Pattern ' || i, 'fr', 'Caftan Marocain ' || i, 'ar', 'قفطان مغربي ' || i),
        jsonb_build_object('en', 'Beautiful kaftan pattern with traditional embroidery details.', 'fr', 'Magnifique patron de caftan avec détails de broderie traditionnelle.', 'ar', 'نمط قفطان جميل مع تفاصيل تطريز تقليدية.'),
        difficulties[1 + ((i-1) % 4)], 'kaftan',
        jsonb_build_object('en', 'Silk Blend', 'fr', 'Soie Mélangée', 'ar', 'مخلوط حرير'),
        random_between(100, 280), '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb,
        ARRAY['kaftan', 'traditional', 'sewing', 'pattern', 'fashion', 'moroccan'],
        random_between(350, 35000), random_between(90, 10000), random_between(45, 4500), random_between(15, 1500),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(8, 350), (i % 12 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (9300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (9300000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Kaftan photo", "fr": "Photo caftan", "ar": "صورة قفطان"}'::jsonb, 800, 1200);
    END LOOP;
  END IF;
  
  RAISE NOTICE 'Created accessories and traditional patterns';
END $$;
