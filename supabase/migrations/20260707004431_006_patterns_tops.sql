/*
# Part 3b: Women's Patterns - Tops and Blouses (120 patterns)
*/

DO $$
DECLARE
  cat_id UUID;
  inst_ids UUID[];
  pattern_slug TEXT;
  pattern_id UUID;
  i INT;
  difficulties TEXT[] := ARRAY['beginner', 'intermediate', 'advanced', 'professional'];
  titles_en TEXT[] := ARRAY['Silk Blouse', 'Cotton T-Shirt', 'Peasant Blouse', 'Button-Up Shirt', 'Crop Top', 'Tank Top', 'Tunic Top', 'Peplum Blouse', 'Ruffled Blouse', 'Wrap Top', 'Off-Shoulder Top', 'Bell Sleeve Blouse', 'Satin Cami', 'Knit Sweater', 'Cardigan Top', 'Boat Neck Top', 'V-Neck Blouse', 'Tie-Front Top', 'Keyhole Blouse', 'Pleated Blouse', 'Smocked Top', 'Puff Sleeve Blouse', 'Dolman Top', 'Raglan Tee', 'Henley Top'];
  titles_fr TEXT[] := ARRAY['Blouse en soie', 'T-shirt en coton', 'Blouse paysanne', 'Chemise boutonnée', 'Top court', 'Débardeur', 'Tunique', 'Blouse peplum', 'Blouse à volants', 'Top portefeuille', 'Top dos nu', 'Blouse manches cloche', 'Caraco satin', 'Pull tricoté', 'Cardigan', 'Top bateau', 'Blouse col V', 'Top à nouer', 'Blouse clé de porte', 'Blouse plissée', 'Top smocké', 'Blouse manches bouffantes', 'Top dolman', 'T-shirt raglan', 'Henley'];
  titles_ar TEXT[] := ARRAY['بلوزة حرير', 'تيشيرت قطن', 'بلوزة فلاحية', 'قميص أزرار', 'توب قصير', 'توب حمالة', 'تونيك', 'بلوزة بيبلوم', 'بلوزة كشكشة', 'توب لف', 'توب مكشوف الكتف', 'بلوزة أكمام جرس', 'كامي ساتان', 'سويتر مRIX', 'كارديجان', 'توب قارب', 'بلوزة V', 'توب ربط', 'بلوزة ثقب مفتاح', 'بلوزة مطوية', 'توب مشدود', 'بلوزة أكمام منفوخة', 'توب دولمان', 'تيشيرت راغلان', 'هنلي'];
BEGIN
  SELECT id INTO cat_id FROM categories WHERE slug = 'tops-blouses' LIMIT 1;
  SELECT array_agg(id) INTO inst_ids FROM instructors;
  
  IF cat_id IS NULL THEN RAISE EXCEPTION 'Tops category not found'; END IF;
  
  FOR i IN 1..120 LOOP
    pattern_slug := 'tops-pattern-' || i;
    
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
        'en', 'Stylish top pattern with clear instructions. Perfect for everyday wear or special occasions.',
        'fr', 'Patron de haut élégant avec instructions claires. Parfait pour tous les jours ou occasions spéciales.',
        'ar', 'نمط توب أنيق مع تعليمات واضحة. مثالي للارتداء اليومي أو المناسبات الخاصة.'
      ),
      difficulties[1 + ((i-1) % 4)],
      'top',
      jsonb_build_object('en', 'Cotton', 'fr', 'Coton', 'ar', 'قطن'),
      random_between(60, 240),
      '["XS", "S", "M", "L", "XL", "XXL"]'::jsonb,
      ARRAY['top', 'blouse', 'sewing', 'pattern', 'fashion', 'women'],
      random_between(400, 40000),
      random_between(80, 12000),
      random_between(40, 4000),
      random_between(15, 1500),
      ROUND((3.5 + random() * 1.5)::numeric, 1),
      random_between(8, 400),
      (i % 20 = 0),
      true,
      random_past_date(),
      random_past_date()
    ) RETURNING id INTO pattern_id;
    
    INSERT INTO pattern_images (pattern_id, image_url, thumbnail_url, image_type, display_order, is_primary, alt_text, width, height)
    VALUES
      (pattern_id,
       'https://images.pexels.com/photos/' || (6100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
       'https://images.pexels.com/photos/' || (6100000 + i) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=300',
       'photo', 0, true,
       '{"en": "Finished top photo", "fr": "Photo du haut fini", "ar": "صورة التوب النهائي"}'::jsonb,
       800, 1000);
  END LOOP;
  
  RAISE NOTICE 'Created 120 tops patterns';
END $$;
