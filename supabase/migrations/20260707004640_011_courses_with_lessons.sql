/*
# Part 4: Courses with Lessons (25 courses, 10-20 lessons each)
*/

DO $$
DECLARE
  course_id UUID;
  lesson_id UUID;
  inst_ids UUID[];
  cat_ids UUID[];
  i INT;
  j INT;
  lessons_count INT;
  titles_en TEXT[] := ARRAY['Sewing Fundamentals', 'Advanced Techniques', 'Pattern Drafting', 'Couture Finishes', 'Professional Tailoring', 'Fashion Draping', 'Fabric Selection', 'Design Principles', 'Professional Skills', 'Special Occasions', 'Childrenswear Design', 'Menswear Tailoring', 'Accessories Design', 'Traditional Garments', 'Sustainable Fashion', 'Fashion Business', 'Perfect Fit', 'Machine Mastery', 'Hand Stitching', 'Upcycling Fashion', 'Quilting Basics', 'Fashion Embroidery', 'Knit Fabrics', 'Lingerie Design', 'Outerwear Construction'];
  titles_fr TEXT[] := ARRAY['Fondamentaux Couture', 'Techniques Avancées', 'Création Patrons', 'Finitions Couture', 'Tailoring Pro', 'Drapage Mode', 'Sélection Tissus', 'Principes Design', 'Compétences Pro', 'Occasions Spéciales', 'Vêtements Enfants', 'Tailoring Homme', 'Accessoires Mode', 'Vêtements Trad.', 'Mode Durable', 'Business Mode', 'Ajustement Parfait', 'Maîtrise Machine', 'Couture Main', 'Upcycling Mode', 'Patchwork', 'Broderie Mode', 'Tissus Extensibles', 'Lingerie Fine', 'Extérieur'];
  titles_ar TEXT[] := ARRAY['أساسيات الخياطة', 'تقنيات متقدمة', 'تصميم الأنماط', 'تشطيبات راقية', 'التفصيل الاحترافي', 'درابا الأزياء', 'اختيار الأقمشة', 'مبادئ التصميم', 'مهارات احترافية', 'مناسبات خاصة', 'ملابس الأطفال', 'تفصيل رجالي', 'تصميم إكسسوارات', 'ملابس تقليدية', 'أزياء مستدامة', 'أعمال الأزياء', 'قصة مثالية', 'إتقان الماكينة', 'خياطة يدوية', 'تحويل الملابس', 'أساسيات التحفيد', 'تطريز الأزياء', 'أقمشة مرنة', 'تصميم لانجري', 'ملابس خارجية'];
BEGIN
  SELECT array_agg(id) INTO inst_ids FROM instructors;
  SELECT array_agg(id) INTO cat_ids FROM categories WHERE parent_id IS NULL;
  
  FOR i IN 1..25 LOOP
    -- Create course
    INSERT INTO courses (
      instructor_id, category_id, slug, title, subtitle, description,
      cover_image_url, level, duration_hours, lessons_count,
      is_free, is_featured, is_published, enrolled_count,
      rating_average, rating_count, published_at, created_at
    ) VALUES (
      inst_ids[1 + (i % array_length(inst_ids, 1))],
      cat_ids[1 + (i % array_length(cat_ids, 1))],
      'course-' || i,
      jsonb_build_object(
        'en', titles_en[i] || ' Masterclass',
        'fr', 'Masterclass ' || titles_fr[i],
        'ar', 'دورة ' || titles_ar[i]
      ),
      jsonb_build_object(
        'en', 'Complete professional course for all skill levels',
        'fr', 'Cours professionnel complet pour tous niveaux',
        'ar', 'دورة احترافية شاملة لجميع المستويات'
      ),
      jsonb_build_object(
        'en', 'This comprehensive course covers everything you need to master ' || titles_en[i] || '. Learn from industry professionals with decades of experience. Includes downloadable resources, practice exercises, and lifetime access.',
        'fr', 'Ce cours complet couvre tout ce que vous devez maîtriser en ' || titles_fr[i] || '. Apprenez des professionnels avec des décennies d''expérience.',
        'ar', 'هذه الدورة الشاملة تغطي كل ما تحتاج لإتقان ' || titles_ar[i] || '. تعلم من محترفين بعقود من الخبرة.'
      ),
      'https://images.pexels.com/photos/' || (4500000 + i * 100) || '/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=800',
      (ARRAY['beginner', 'intermediate', 'advanced', 'professional'])[1 + (i % 4)],
      random_between(5, 40),
      random_between(10, 20),
      (i % 3 = 0),
      (i % 5 = 0),
      true,
      random_between(200, 15000),
      ROUND((3.8 + random() * 1.2)::numeric, 1),
      random_between(20, 800),
      random_past_date(),
      random_past_date()
    ) RETURNING id INTO course_id;
    
    -- Create lessons for this course
    lessons_count := random_between(12, 20);
    FOR j IN 1..lessons_count LOOP
      INSERT INTO lessons (
        course_id, title, description, video_url, video_duration_seconds,
        display_order, is_preview, is_published, created_at
      ) VALUES (
        course_id,
        jsonb_build_object(
          'en', 'Lesson ' || j || ': ' || (ARRAY['Introduction', 'Materials', 'Measurements', 'Fabric Prep', 'Reading Patterns', 'Cutting', 'Basic Seams', 'Pressing', 'Darts', 'Zippers', 'Buttons', 'Sleeves', 'Collars', 'Pockets', 'Lining', 'Hems', 'Waistbands', 'Necklines', 'Construction', 'Finishing', 'Fitting', 'Troubleshooting', 'Variations', 'Care', 'Completion'])[j],
          'fr', 'Leçon ' || j || ': ' || (ARRAY['Introduction', 'Matériaux', 'Mesures', 'Préparation Tissu', 'Lire Patrons', 'Coupe', 'Coutures Base', 'Pressage', 'Pinces', 'Fermetures', 'Boutons', 'Manches', 'Cols', 'Poches', 'Doublure', 'Ourlets', 'Ceintures', 'Encolures', 'Construction', 'Finition', 'Essayage', 'Dépannage', 'Variations', 'Entretien', 'Achèvement'])[j],
          'ar', 'الدرس ' || j || ': ' || (ARRAY['مقدمة', 'المواد', 'المقاسات', 'تحضير القماش', 'قراءة الأنماط', 'القص', 'الدرزات الأساسية', 'الكي', 'الشدات', 'السحابات', 'الأزرار', 'الأكمام', 'الياقات', 'الجيوب', 'البطانة', 'الحواف', 'أحزمة الخصر', 'الرقبة', 'البناء', 'التشطيب', 'التجربة', 'حل المشاكل', 'اختلافات', 'العناية', 'الإكمال'])[j]
        ),
        jsonb_build_object(
          'en', 'Essential techniques for successful garment construction.',
          'fr', 'Techniques essentielles pour la construction de vêtements.',
          'ar', 'تقنيات أساسية لنجاح بناء الملابس.'
        ),
        'https://example.com/videos/course-' || i || '-lesson-' || j || '.mp4',
        random_between(300, 1800),
        j,
        (j <= 2),
        true,
        random_past_date()
      );
    END LOOP;
  END LOOP;
  
  RAISE NOTICE 'Created 25 courses with lessons';
END $$;
