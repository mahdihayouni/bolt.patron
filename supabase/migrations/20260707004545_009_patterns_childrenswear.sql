/*
# Part 3e: Children's Patterns - Baby (80), Girls (80), Boys (80)
*/

DO $$
DECLARE
  parent_cat_id UUID;
  cat_id UUID;
  inst_ids UUID[];
  pattern_id UUID;
  i INT;
  difficulties TEXT[] := ARRAY['beginner', 'intermediate', 'advanced', 'professional'];
BEGIN
  SELECT array_agg(id) INTO inst_ids FROM instructors;
  SELECT id INTO parent_cat_id FROM categories WHERE slug = 'children' LIMIT 1;
  
  -- BABY CLOTHES (80)
  SELECT id INTO cat_id FROM categories WHERE slug = 'baby-clothes' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..80 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'baby-pattern-' || i,
        jsonb_build_object('en', 'Baby Romper Pattern ' || i, 'fr', 'Combinaison Bébé ' || i, 'ar', 'رومper طفل ' || i),
        jsonb_build_object('en', 'Adorable baby pattern with soft finishes.', 'fr', 'Adorable patron pour bébé avec finitions douces.', 'ar', 'نمط طفل لطيف مع تشطيبات ناعمة.'),
        difficulties[1 + ((i-1) % 4)], 'baby',
        jsonb_build_object('en', 'Soft Cotton', 'fr', 'Coton Doux', 'ar', 'قطن ناعم'),
        random_between(45, 120), '["Newborn", "0-3M", "3-6M", "6-12M", "12-18M", "18-24M"]'::jsonb,
        ARRAY['baby', 'childrenswear', 'sewing', 'pattern', 'fashion', 'infant'],
        random_between(200, 20000), random_between(50, 8000), random_between(25, 2500), random_between(8, 800),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(5, 250), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (8000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (8000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Baby clothes photo", "fr": "Photo vêtements bébé", "ar": "صورة ملابس طفل"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;
  
  -- GIRLS (80)
  SELECT id INTO cat_id FROM categories WHERE slug = 'girls' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..80 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'girls-pattern-' || i,
        jsonb_build_object('en', 'Girls Dress Pattern ' || i, 'fr', 'Robe Fille ' || i, 'ar', 'فستان بنت ' || i),
        jsonb_build_object('en', 'Pretty dress pattern for girls with fun details.', 'fr', 'Jolie robe pour filles avec détails amusants.', 'ar', 'نمط فستان جميل للبنات مع تفاصيل ممتعة.'),
        difficulties[1 + ((i-1) % 4)], 'dress',
        jsonb_build_object('en', 'Cotton Print', 'fr', 'Coton Imprimé', 'ar', 'قطن مطبوع'),
        random_between(60, 180), '["2T", "3T", "4T", "5", "6", "7", "8"]'::jsonb,
        ARRAY['girls', 'childrenswear', 'sewing', 'pattern', 'fashion', 'dress'],
        random_between(250, 25000), random_between(55, 9000), random_between(28, 2800), random_between(10, 900),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(6, 280), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (8100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (8100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Girls dress photo", "fr": "Photo robe fille", "ar": "صورة فستان بنت"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;
  
  -- BOYS (80)
  SELECT id INTO cat_id FROM categories WHERE slug = 'boys' LIMIT 1;
  IF cat_id IS NOT NULL THEN
    FOR i IN 1..80 LOOP
      INSERT INTO patterns (
        category_id, instructor_id, slug, title, description, difficulty, garment_type,
        fabric_recommendations, estimated_time_minutes, sizes, tags,
        views_count, downloads_count, likes_count, saves_count,
        rating_average, rating_count, is_featured, is_published, published_at, created_at
      ) VALUES (
        cat_id, inst_ids[1 + (i % array_length(inst_ids, 1))], 'boys-pattern-' || i,
        jsonb_build_object('en', 'Boys Shirt Pattern ' || i, 'fr', 'Chemise Garçon ' || i, 'ar', 'قميص ولد ' || i),
        jsonb_build_object('en', 'Cool and comfortable boys shirt pattern.', 'fr', 'Patron de chemise garçon cool et confortable.', 'ar', 'نمط قميص ولد أنيق ومريح.'),
        difficulties[1 + ((i-1) % 4)], 'shirt',
        jsonb_build_object('en', 'Cotton Denim', 'fr', 'Denim Coton', 'ar', 'دينيم قطن'),
        random_between(60, 150), '["2T", "3T", "4T", "5", "6", "7", "8"]'::jsonb,
        ARRAY['boys', 'childrenswear', 'sewing', 'pattern', 'fashion', 'shirt'],
        random_between(230, 23000), random_between(50, 8500), random_between(25, 2500), random_between(8, 850),
        ROUND((3.5 + random() * 1.5)::numeric, 1), random_between(5, 250), (i % 20 = 0), true, random_past_date(), random_past_date()
      ) RETURNING id INTO pattern_id;
      
      INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
      VALUES (pattern_id,
        'https://images.pexels.com/photos/' || (8200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/' || (8200000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
        'photo', 0, true, '{"en": "Boys shirt photo", "fr": "Photo chemise garçon", "ar": "صورة قميص ولد"}'::jsonb, 800, 1000);
    END LOOP;
  END IF;
  
  RAISE NOTICE 'Created childrens patterns';
END $$;
