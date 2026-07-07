/*
# Add missing subcategories to match specification
*/

DO $$
DECLARE
  women_id UUID;
  men_id UUID;
  children_id UUID;
  accessories_id UUID;
  traditional_id UUID;
BEGIN
  SELECT id INTO women_id FROM categories WHERE slug = 'women' LIMIT 1;
  SELECT id INTO men_id FROM categories WHERE slug = 'men' LIMIT 1;
  SELECT id INTO children_id FROM categories WHERE slug = 'children' LIMIT 1;
  SELECT id INTO accessories_id FROM categories WHERE slug = 'accessories' LIMIT 1;
  SELECT id INTO traditional_id FROM categories WHERE slug = 'traditional' LIMIT 1;

  -- WOMEN subcategories
  INSERT INTO categories (slug, name, description, parent_id, display_order, is_active) VALUES
  ('hoodies', '{"en": "Hoodies", "fr": "Hoodies", "ar": "هوديز"}', '{"en": "Women hoodies and sweatshirts", "fr": "Hoodies et sweat-shirts femme", "ar": "هوديز وبلوزات نسائية"}', women_id, 60, true),
  ('sportswear-women', '{"en": "Sportswear", "fr": "Sportswear", "ar": "ملابس رياضية"}', '{"en": "Women sports and activewear patterns", "fr": "Patrons sportswear femme", "ar": "أنماط ملابس رياضية نسائية"}', women_id, 70, true),
  ('lingerie', '{"en": "Lingerie", "fr": "Lingerie", "ar": "ملابس داخلية"}', '{"en": "Women lingerie and intimate apparel patterns", "fr": "Patrons lingerie femme", "ar": "أنماط ملابس داخلية نسائية"}', women_id, 80, true);

  -- MEN subcategories
  INSERT INTO categories (slug, name, description, parent_id, display_order, is_active) VALUES
  ('pants-men', '{"en": "Pants", "fr": "Pantalons", "ar": "بنطلونات"}', '{"en": "Men pants and trousers patterns", "fr": "Patrons pantalons homme", "ar": "أنماط بنطلونات رجالية"}', men_id, 20, true),
  ('jackets-men', '{"en": "Jackets", "fr": "Vestes", "ar": "جاكيتات"}', '{"en": "Men jackets and blazers patterns", "fr": "Patrons vestes homme", "ar": "أنماط جاكيتات رجالية"}', men_id, 30, true),
  ('hoodies-men', '{"en": "Hoodies", "fr": "Hoodies", "ar": "هوديز"}', '{"en": "Men hoodies and sweatshirts patterns", "fr": "Patrons hoodies homme", "ar": "أنماط هوديز رجالية"}', men_id, 40, true),
  ('sportswear-men', '{"en": "Sportswear", "fr": "Sportswear", "ar": "ملابس رياضية"}', '{"en": "Men sports and activewear patterns", "fr": "Patrons sportswear homme", "ar": "أنماط ملابس رياضية رجالية"}', men_id, 50, true),
  ('shorts', '{"en": "Shorts", "fr": "Shorts", "ar": "شورتات"}', '{"en": "Men shorts patterns", "fr": "Patrons shorts homme", "ar": "أنماط شورتات رجالية"}', men_id, 60, true),
  ('coats-men', '{"en": "Coats", "fr": "Manteaux", "ar": "معاطف"}', '{"en": "Men coats and outerwear patterns", "fr": "Patrons manteaux homme", "ar": "أنماط معاطف رجالية"}', men_id, 70, true);

  -- CHILDREN subcategories
  INSERT INTO categories (slug, name, description, parent_id, display_order, is_active) VALUES
  ('pajamas', '{"en": "Pajamas", "fr": "Pyjamas", "ar": "بيجامات"}', '{"en": "Children pajamas and sleepwear patterns", "fr": "Patrons pyjamas enfant", "ar": "أنماط بيجامات أطفال"}', children_id, 40, true),
  ('school-uniforms', '{"en": "School Uniforms", "fr": "Uniformes Scolaires", "ar": "زي مدرسي"}', '{"en": "Children school uniform patterns", "fr": "Patrons uniformes enfant", "ar": "أنماط زي مدرسي للأطفال"}', children_id, 50, true),
  ('jackets-children', '{"en": "Jackets", "fr": "Vestes", "ar": "جاكيتات"}', '{"en": "Children jackets and outerwear patterns", "fr": "Patrons vestes enfant", "ar": "أنماط جاكيتات أطفال"}', children_id, 60, true);

  -- ACCESSORIES subcategories
  INSERT INTO categories (slug, name, description, parent_id, display_order, is_active) VALUES
  ('belts', '{"en": "Belts", "fr": "Ceintures", "ar": "أحزمة"}', '{"en": "Belt patterns and tutorials", "fr": "Patrons ceintures", "ar": "أنماط أحزمة"}', accessories_id, 20, true),
  ('scarves', '{"en": "Scarves", "fr": "Foulards", "ar": "أوشحة"}', '{"en": "Scarf and shawl patterns", "fr": "Patrons foulards", "ar": "أنماط أوشحة وشمليات"}', accessories_id, 30, true),
  ('gloves', '{"en": "Gloves", "fr": "Gants", "ar": "قفازات"}', '{"en": "Glove and mitten patterns", "fr": "Patrons gants", "ar": "أنماط قفازات"}', accessories_id, 40, true),
  ('aprons', '{"en": "Aprons", "fr": "Tabliers", "ar": "مآزر"}', '{"en": "Apron patterns for kitchen and work", "fr": "Patrons tabliers", "ar": "أنماط مآزر"}', accessories_id, 50, true),
  ('wallets', '{"en": "Wallets", "fr": "Portefeuilles", "ar": "محافظ"}', '{"en": "Wallet and card holder patterns", "fr": "Patrons portefeuilles", "ar": "أنماط محافظ"}', accessories_id, 60, true),
  ('hair-accessories', '{"en": "Hair Accessories", "fr": "Accessoires Cheveux", "ar": "إكسسوارات شعر"}', '{"en": "Hair accessories, headbands and scrunchies", "fr": "Patrons accessoires cheveux", "ar": "أنماط إكسسوارات الشعر"}', accessories_id, 70, true);

  -- TRADITIONAL subcategories
  INSERT INTO categories (slug, name, description, parent_id, display_order, is_active) VALUES
  ('djellabas', '{"en": "Djellabas", "fr": "Djellabas", "ar": "جلاليب"}', '{"en": "Djellaba traditional Moroccan garment patterns", "fr": "Patrons djellabas marocaines", "ar": "أنماط جلاليب تقليدية مغربية"}', traditional_id, 20, true),
  ('takchita', '{"en": "Takchita", "fr": "Takchita", "ar": "تقشيتة"}', '{"en": "Takchita elaborate Moroccan dress patterns", "fr": "Patrons takchita marocaines", "ar": "أنماط تقشيتة مغربية"}', traditional_id, 30, true),
  ('jebba', '{"en": "Jebba", "fr": "Jebba", "ar": "جبة"}', '{"en": "Jebba traditional Tunisian garment patterns", "fr": "Patrons jebba tunisiennes", "ar": "أنماط جبة تقليدية تونسية"}', traditional_id, 40, true),
  ('gandoura', '{"en": "Gandoura", "fr": "Gandoura", "ar": "قندورة"}', '{"en": "Gandoura traditional tunic patterns", "fr": "Patrons gandoura", "ar": "أنماط قندورة تقليدية"}', traditional_id, 50, true),
  ('traditional-dresses', '{"en": "Traditional Dresses", "fr": "Robes Traditionnelles", "ar": "فساتين تقليدية"}', '{"en": "Traditional dresses from around the world", "fr": "Patrons robes traditionnelles", "ar": "أنماط فساتين تقليدية"}', traditional_id, 60, true),
  ('traditional-mens-wear', '{"en": "Traditional Mens Wear", "fr": "Vetements Traditionnels Homme", "ar": "ملابس تقليدية رجالية"}', '{"en": "Traditional mens wear and thobes", "fr": "Patrons vetements traditionnels homme", "ar": "أنماط ملابس تقليدية رجالية"}', traditional_id, 70, true);
END $$;
