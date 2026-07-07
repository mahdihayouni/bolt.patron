/*
# Part 3a: Women's Patterns - Dresses (200 patterns)
*/

DO $$
DECLARE
  cat_id UUID;
  inst_ids UUID[];
  pattern_slug TEXT;
  pattern_id UUID;
  i INT;
  difficulties TEXT[] := ARRAY['beginner', 'intermediate', 'advanced', 'professional'];
  titles_en TEXT[] := ARRAY['Floral Summer Dress', 'Elegant Evening Dress', 'Casual Midi Dress', 'A-Line Party Dress', 'Maxi Beach Dress', 'Cocktail Dress', 'Wrap Dress', 'Shirt Dress', 'Fit and Flare Dress', 'Peplum Dress', 'Sheath Dress', 'Empire Waist Dress', 'Boho Dress', 'Vintage Tea Dress', 'Little Black Dress', 'Off-Shoulder Dress', 'Sundress', 'Chiffon Dress', 'Lace Dress', 'Shift Dress', 'Princess Dress', 'Ball Gown', 'Trumpet Dress', 'Mermaid Dress', 'Tea Length Dress'];
  titles_fr TEXT[] := ARRAY['Robe d''été fleurie', 'Robe de soirée élégante', 'Robe midi décontractée', 'Robe de fête trapèze', 'Robe maxi plage', 'Robe cocktail', 'Robe portefeuille', 'Robe chemisier', 'Robe cintrée', 'Robe peplum', 'Robe fourreau', 'Robe empire', 'Robe bohème', 'Robe vintage', 'Petite robe noire', 'Robe dos nu', 'Robe d''été', 'Robe en chiffon', 'Robe en dentelle', 'Robe droite', 'Robe princesse', 'Robe de bal', 'Robe trompette', 'Robe sirène', 'Robe thé'];
  titles_ar TEXT[] := ARRAY['فستان صيفي زهري', 'فستان سهرة أنيق', 'فستان ميدي كاجوال', 'فستان حفلة خط A', 'فستان ماكسي شاطئ', 'فستان كوكتيل', 'فستان لف', 'فستان قميص', 'فستان ضيق ومتسع', 'فستان بيبلوم', 'فستان غمد', 'فستان خصر مرتفع', 'فستان بوهو', 'فستان فينتج', 'فستان أسود صغير', 'فستان مكشوف الكتف', 'فستان صيف', 'فستان شيفون', 'فستان دانتيل', 'فستان تحول', 'فستان أميرة', 'فستان حفلة راقية', 'فستان بوق', 'فستان حورية البحر', 'فستان طول الشاي'];
  fabrics_en TEXT[] := ARRAY['Cotton', 'Linen', 'Silk', 'Denim', 'Chiffon', 'Velvet', 'Wool', 'Jersey', 'Satin', 'Chambray', 'Poplin', 'Twill', 'Crepe', 'Tencel', 'Bamboo', 'Organza', 'Taffeta', 'Brocade', 'Lace', 'Muslin'];
BEGIN
  -- Get dresses category ID
  SELECT id INTO cat_id FROM categories WHERE slug = 'dresses' LIMIT 1;
  SELECT array_agg(id) INTO inst_ids FROM instructors;
  
  IF cat_id IS NULL THEN RAISE EXCEPTION 'Dresses category not found'; END IF;
  
  FOR i IN 1..200 LOOP
    pattern_slug := 'dress-pattern-' || i;
    
    INSERT INTO patterns (
      category_id, instructor_id, slug, title, description, difficulty,
      garment_type, fabric_recommendations, estimated_time_minutes, sizes, tags,
      views_count, downloads_count, likes_count, saves_count,
      rating_average, rating_count, is_featured, is_published, published_at, created_at
    ) VALUES (
      cat_id,
      inst_ids[1 + (i % array_length(inst_ids, 1))],
      pattern_slug,
      jsonb_build_object(
        'en', titles_en[1 + ((i-1) % array_length(titles_en, 1))],
        'fr', titles_fr[1 + ((i-1) % array_length(titles_fr, 1))],
        'ar', titles_ar[1 + ((i-1) % array_length(titles_ar, 1))]
      ),
      jsonb_build_object(
        'en', 'Beautiful dress pattern perfect for special occasions. Features clear instructions, multiple sizes, and professional finishing techniques.',
        'fr', 'Magnifique patron de robe parfait pour les occasions spéciales. Instructions claires, plusieurs tailles et finitions professionnelles.',
        'ar', 'نمط فستان جميل مثالي للمناسبات الخاصة. تعليمات واضحة وأحجام متعددة وتقنيات تشطيب احترافية.'
      ),
      difficulties[1 + ((i-1) % 4)],
      'dress',
      jsonb_build_object(
        'en', fabrics_en[1 + ((i-1) % array_length(fabrics_en, 1))],
        'fr', fabrics_en[1 + ((i-1) % array_length(fabrics_en, 1))],
        'ar', fabrics_en[1 + ((i-1) % array_length(fabrics_en, 1))]
      ),
      random_between(120, 480),
      '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb,
      ARRAY['dress', 'sewing', 'pattern', 'fashion', 'elegant', 'women'],
      random_between(500, 50000),
      random_between(100, 15000),
      random_between(50, 5000),
      random_between(20, 2000),
      ROUND((3.5 + random() * 1.5)::numeric, 1),
      random_between(10, 500),
      (i % 25 = 0),
      true,
      random_past_date(),
      random_past_date()
    ) RETURNING id INTO pattern_id;
    
    -- Add images
    INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
    VALUES
      (pattern_id,
       'https://images.pexels.com/photos/' || (6000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
       'https://images.pexels.com/photos/' || (6000000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
       'photo', 0, true,
       '{"en": "Finished dress photo", "fr": "Photo de la robe finie", "ar": "صورة الفستان النهائي"}'::jsonb,
       800, 1200);
  END LOOP;
  
  RAISE NOTICE 'Created 200 dress patterns';
END $$;
