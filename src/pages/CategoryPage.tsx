import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { ChevronRight, Grid3X3, ArrowDownUp } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { supabase, Category, Pattern } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { PatternCard } from '@/components/patterns/PatternCard';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';

export default function CategoryPage() {
  const { slug } = useParams<{ slug: string }>();
  const { t } = useTranslation();
  const { getText, language } = useLocalText();
  const [category, setCategory] = useState<Category | null>(null);
  const [subcategories, setSubcategories] = useState<Category[]>([]);
  const [patterns, setPatterns] = useState<Pattern[]>([]);
  const [loading, setLoading] = useState(true);
  const [sortBy, setSortBy] = useState('newest');

  useEffect(() => {
    if (slug) {
      fetchCategoryData();
    }
  }, [slug, sortBy]);

  const fetchCategoryData = async () => {
    setLoading(true);
    try {
      // Fetch category
      const { data: categoryData } = await supabase
        .from('categories')
        .select('*')
        .eq('slug', slug)
        .single();

      if (categoryData) {
        setCategory(categoryData);

        // Fetch subcategories
        const { data: subcats } = await supabase
          .from('categories')
          .select('*')
          .eq('parent_id', categoryData.id)
          .eq('is_active', true)
          .order('display_order');

        setSubcategories(subcats || []);

        // Fetch patterns
        let query = supabase
          .from('patterns')
          .select('*')
          .eq('category_id', categoryData.id)
          .eq('is_published', true);

        // Apply sorting
        switch (sortBy) {
          case 'newest':
            query = query.order('created_at', { ascending: false });
            break;
          case 'popular':
            query = query.order('views_count', { ascending: false });
            break;
          case 'downloads':
            query = query.order('downloads_count', { ascending: false });
            break;
          case 'rating':
            query = query.order('rating_average', { ascending: false });
            break;
        }

        const { data: patternsData } = await query.limit(50);
        setPatterns(patternsData || []);
      }
    } catch (error) {
      console.error('Error fetching category:', error);
    } finally {
      setLoading(false);
    }
  };

  const sortOptions = [
    { value: 'newest', label: language === 'ar' ? 'الأحدث' : language === 'fr' ? 'Nouveautés' : 'Newest' },
    { value: 'popular', label: language === 'ar' ? 'الأكثر شعبية' : language === 'fr' ? 'Plus populaires' : 'Most Popular' },
    { value: 'downloads', label: language === 'ar' ? 'الأكثر تحميلاً' : language === 'fr' ? 'Plus téléchargés' : 'Most Downloaded' },
    { value: 'rating', label: language === 'ar' ? 'الأعلى تقييماً' : language === 'fr' ? 'Mieux notés' : 'Highest Rated' },
  ];

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Skeleton className="h-48 w-full mb-8 rounded-xl" />
        <div className="masonry-grid">
          {[...Array(12)].map((_, i) => (
            <Skeleton key={i} className="h-64 rounded-xl" />
          ))}
        </div>
      </div>
    );
  }

  if (!category) {
    return (
      <div className="container mx-auto px-4 py-8 text-center">
        <h1 className="text-2xl font-bold mb-4">
          {language === 'ar' ? 'الفئة غير موجودة' : language === 'fr' ? 'Catégorie non trouvée' : 'Category not found'}
        </h1>
        <Button asChild>
          <Link to="/categories">{t('categories.title')}</Link>
        </Button>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Breadcrumb */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        className="flex items-center gap-2 text-sm text-muted-foreground mb-6"
      >
        <Link to="/" className="hover:text-foreground transition-colors">
          {t('nav.home')}
        </Link>
        <ChevronRight className="h-4 w-4" />
        <Link to="/categories" className="hover:text-foreground transition-colors">
          {t('categories.title')}
        </Link>
        {category.parent_id && <ChevronRight className="h-4 w-4" />}
        <span className="text-foreground">{getText(category.name)}</span>
      </motion.div>

      {/* Category Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8"
      >
        <div className="flex items-center gap-3 mb-2">
          <Grid3X3 className="h-8 w-8 text-primary" />
          <h1 className="text-3xl md:text-4xl font-bold">{getText(category.name)}</h1>
        </div>
        {category.description && (
          <p className="text-muted-foreground max-w-2xl">{getText(category.description)}</p>
        )}
      </motion.div>

      {/* Subcategories */}
      {subcategories.length > 0 && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.1 }}
          className="mb-8"
        >
          <div className="flex flex-wrap gap-2">
            {subcategories.map((subcat) => (
              <Link
                key={subcat.id}
                to={`/category/${subcat.slug}`}
                className="px-4 py-2 rounded-full bg-muted hover:bg-muted/80 transition-colors text-sm font-medium"
              >
                {getText(subcat.name)}
              </Link>
            ))}
          </div>
        </motion.div>
      )}

      {/* Filters */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.2 }}
        className="flex items-center justify-between mb-6"
      >
        <p className="text-muted-foreground">
          {patterns.length} {language === 'ar' ? 'نمط' : language === 'fr' ? 'patrons' : 'patterns'}
        </p>
        <div className="flex items-center gap-2">
          <Select value={sortBy} onValueChange={setSortBy}>
            <SelectTrigger className="w-[180px]">
              <ArrowDownUp className="h-4 w-4 mr-2" />
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {sortOptions.map((option) => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </motion.div>

      {/* Patterns Grid */}
      {patterns.length > 0 ? (
        <div className="masonry-grid">
          {patterns.map((pattern, index) => (
            <motion.div
              key={pattern.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.03 }}
              className="masonry-item"
            >
              <PatternCard pattern={pattern} />
            </motion.div>
          ))}
        </div>
      ) : (
        <div className="text-center py-12">
          <p className="text-muted-foreground">
            {language === 'ar' ? 'لا توجد أنماط في هذه الفئة' : language === 'fr' ? 'Aucun patron dans cette catégorie' : 'No patterns in this category'}
          </p>
        </div>
      )}
    </div>
  );
}
