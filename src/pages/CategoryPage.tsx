import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { ChevronRight, Grid3X3, ArrowDownUp, X } from 'lucide-react';
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
import { cn } from '@/lib/utils';

export default function CategoryPage() {
  const { slug } = useParams<{ slug: string }>();
  const { t } = useTranslation();
  const { getText, language } = useLocalText();
  const [category, setCategory] = useState<Category | null>(null);
  const [subcategories, setSubcategories] = useState<Category[]>([]);
  const [patterns, setPatterns] = useState<Pattern[]>([]);
  const [loading, setLoading] = useState(true);
  const [sortBy, setSortBy] = useState('newest');
  const [selectedSubcategory, setSelectedSubcategory] = useState<string | null>(null);
  const [isMainCategory, setIsMainCategory] = useState(false);

  useEffect(() => {
    if (slug) {
      fetchCategoryData();
    }
  }, [slug, sortBy, selectedSubcategory]);

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

        // Check if this is a main category (no parent)
        const isMain = !categoryData.parent_id;
        setIsMainCategory(isMain);

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
          .eq('is_published', true);

        if (isMain && subcats && subcats.length > 0) {
          // Main category: fetch patterns from all subcategories
          const subcategoryIds = subcats.map(s => s.id);

          if (selectedSubcategory) {
            // Filter by specific subcategory
            query = query.eq('category_id', selectedSubcategory);
          } else {
            // Show patterns from all subcategories
            query = query.in('category_id', subcategoryIds);
          }
        } else {
          // Subcategory: fetch patterns from this category only
          query = query.eq('category_id', categoryData.id);
        }

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

        const { data: patternsData } = await query.limit(100);
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
        <div className="flex gap-2 mb-6">
          {[...Array(5)].map((_, i) => (
            <Skeleton key={i} className="h-10 w-24 rounded-full" />
          ))}
        </div>
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
        <ChevronRight className="h-4 w-4" />
        <span className="text-foreground">{getText(category.name)}</span>
      </motion.div>

      {/* Category Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8"
      >
        <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-primary/10 via-primary/5 to-transparent p-8 md:p-12">
          <div className="relative z-10">
            <div className="flex items-center gap-3 mb-3">
              <Grid3X3 className="h-8 w-8 text-primary" />
              <h1 className="text-3xl md:text-4xl font-bold">{getText(category.name)}</h1>
            </div>
            {category.description && (
              <p className="text-muted-foreground max-w-2xl text-lg">{getText(category.description)}</p>
            )}
            <p className="text-muted-foreground mt-4">
              {patterns.length} {language === 'ar' ? 'نمط متاح' : language === 'fr' ? 'patrons disponibles' : 'patterns available'}
            </p>
          </div>
          <div className="absolute -right-10 -bottom-10 w-64 h-64 bg-primary/5 rounded-full blur-3xl" />
        </div>
      </motion.div>

      {/* Subcategory Filter Chips (for main categories) */}
      {isMainCategory && subcategories.length > 0 && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.1 }}
          className="mb-8"
        >
          <div className="flex flex-wrap gap-3">
            {/* All filter */}
            <button
              onClick={() => setSelectedSubcategory(null)}
              className={cn(
                'px-5 py-2.5 rounded-full text-sm font-medium transition-all',
                !selectedSubcategory
                  ? 'bg-primary text-primary-foreground shadow-md'
                  : 'bg-muted hover:bg-muted/80'
              )}
            >
              {language === 'ar' ? 'الكل' : language === 'fr' ? 'Tout' : 'All'}
            </button>

            {/* Subcategory filters */}
            {subcategories.map((subcat) => (
              <button
                key={subcat.id}
                onClick={() => setSelectedSubcategory(selectedSubcategory === subcat.id ? null : subcat.id)}
                className={cn(
                  'px-5 py-2.5 rounded-full text-sm font-medium transition-all flex items-center gap-2',
                  selectedSubcategory === subcat.id
                    ? 'bg-primary text-primary-foreground shadow-md'
                    : 'bg-muted hover:bg-muted/80'
                )}
              >
                {getText(subcat.name)}
                {selectedSubcategory === subcat.id && (
                  <X className="h-4 w-4" />
                )}
              </button>
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
          {language === 'ar' ? `${patterns.length} نمط` : language === 'fr' ? `${patterns.length} patrons` : `${patterns.length} patterns`}
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
              transition={{ delay: index * 0.02 }}
              className="masonry-item"
            >
              <PatternCard pattern={pattern} />
            </motion.div>
          ))}
        </div>
      ) : (
        <div className="text-center py-16">
          <Grid3X3 className="h-16 w-16 mx-auto mb-4 text-muted" />
          <h3 className="text-xl font-semibold mb-2">
            {language === 'ar' ? 'لا توجد أنماط' : language === 'fr' ? 'Aucun patron' : 'No patterns found'}
          </h3>
          <p className="text-muted-foreground mb-6">
            {language === 'ar' ? 'جرب تغيير الفلاتر' : language === 'fr' ? 'Essayez de modifier les filtres' : 'Try adjusting your filters'}
          </p>
          {selectedSubcategory && (
            <Button variant="outline" onClick={() => setSelectedSubcategory(null)}>
              {language === 'ar' ? 'عرض الكل' : language === 'fr' ? 'Voir tout' : 'View All'}
            </Button>
          )}
        </div>
      )}
    </div>
  );
}
