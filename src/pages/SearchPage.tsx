import { useEffect, useState } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { Search, Filter, ArrowDownUp, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from '@/components/ui/sheet';
import { Label } from '@/components/ui/label';
import { Checkbox } from '@/components/ui/checkbox';
import { supabase, Pattern } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { PatternCard } from '@/components/patterns/PatternCard';
import { Skeleton } from '@/components/ui/skeleton';

export default function SearchPage() {
  const { t } = useTranslation();
  const { language } = useLocalText();
  const [searchParams, setSearchParams] = useSearchParams();
  const [patterns, setPatterns] = useState<Pattern[]>([]);
  const [loading, setLoading] = useState(true);
  const [query, setQuery] = useState(searchParams.get('q') || '');
  const [sortBy, setSortBy] = useState(searchParams.get('sort') || 'newest');
  const [difficulty, setDifficulty] = useState<string[]>([]);
  const [filtersOpen, setFiltersOpen] = useState(false);

  useEffect(() => {
    search();
  }, [searchParams]);

  const search = async () => {
    setLoading(true);
    try {
      let queryBuilder = supabase
        .from('patterns')
        .select('*')
        .eq('is_published', true);

      // Text search
      const searchTerm = searchParams.get('q');
      if (searchTerm) {
        queryBuilder = queryBuilder.textSearch('title', searchTerm);
      }

      // Category filter
      const category = searchParams.get('category');
      if (category) {
        const { data: catData } = await supabase
          .from('categories')
          .select('id')
          .eq('slug', category)
          .single();
        if (catData) {
          queryBuilder = queryBuilder.eq('category_id', catData.id);
        }
      }

      // Difficulty filter
      const difficultyParam = searchParams.get('difficulty');
      if (difficultyParam) {
        queryBuilder = queryBuilder.eq('difficulty', difficultyParam);
      }

      // Sort
      const sort = searchParams.get('sort') || 'newest';
      switch (sort) {
        case 'newest':
          queryBuilder = queryBuilder.order('created_at', { ascending: false });
          break;
        case 'popular':
          queryBuilder = queryBuilder.order('views_count', { ascending: false });
          break;
        case 'downloads':
          queryBuilder = queryBuilder.order('downloads_count', { ascending: false });
          break;
        case 'rating':
          queryBuilder = queryBuilder.order('rating_average', { ascending: false });
          break;
        default:
          queryBuilder = queryBuilder.order('created_at', { ascending: false });
      }

      const { data } = await queryBuilder.limit(100);
      setPatterns(data || []);
    } catch (error) {
      console.error('Error searching:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    const params = new URLSearchParams(searchParams);
    if (query) {
      params.set('q', query);
    } else {
      params.delete('q');
    }
    setSearchParams(params);
  };

  const updateSort = (value: string) => {
    setSortBy(value);
    const params = new URLSearchParams(searchParams);
    params.set('sort', value);
    setSearchParams(params);
  };

  const sortOptions = [
    { value: 'newest', label: language === 'ar' ? 'الأحدث' : language === 'fr' ? 'Nouveautés' : 'Newest' },
    { value: 'popular', label: language === 'ar' ? 'الأكثر شعبية' : language === 'fr' ? 'Plus populaires' : 'Most Popular' },
    { value: 'downloads', label: language === 'ar' ? 'الأكثر تحميلاً' : language === 'fr' ? 'Plus téléchargés' : 'Most Downloaded' },
    { value: 'rating', label: language === 'ar' ? 'الأعلى تقييماً' : language === 'fr' ? 'Mieux notés' : 'Highest Rated' },
  ];

  const difficulties = [
    { value: 'beginner', label: language === 'ar' ? 'مبتدئ' : language === 'fr' ? 'Débutant' : 'Beginner' },
    { value: 'intermediate', label: language === 'ar' ? 'متوسط' : language === 'fr' ? 'Intermédiaire' : 'Intermediate' },
    { value: 'advanced', label: language === 'ar' ? 'متقدم' : language === 'fr' ? 'Avancé' : 'Advanced' },
    { value: 'professional', label: language === 'ar' ? 'احترافي' : language === 'fr' ? 'Professionnel' : 'Professional' },
  ];

  const clearFilters = () => {
    setSearchParams(new URLSearchParams());
    setQuery('');
    setDifficulty([]);
  };

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Search Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8"
      >
        <h1 className="text-3xl font-bold mb-4">
          {language === 'ar' ? 'البحث' : language === 'fr' ? 'Recherche' : 'Search Patterns'}
        </h1>

        <form onSubmit={handleSearch} className="flex gap-2">
          <div className="relative flex-1">
            <Search className="absolute left-3 rtl:left-auto rtl:right-3 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
            <Input
              type="search"
              placeholder={t('nav.search')}
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              className="h-12 pl-10 rtl:pl-3 rtl:pr-10 text-lg"
            />
          </div>
          <Button type="submit" size="lg" className="h-12 px-6">
            {language === 'ar' ? 'بحث' : language === 'fr' ? 'Rechercher' : 'Search'}
          </Button>
        </form>
      </motion.div>

      {/* Filters & Sort */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.1 }}
        className="flex items-center justify-between gap-4 mb-6 overflow-x-auto pb-2"
      >
        <div className="flex items-center gap-2">
          <Sheet open={filtersOpen} onOpenChange={setFiltersOpen}>
            <SheetTrigger asChild>
              <Button variant="outline" className="shrink-0">
                <Filter className="h-4 w-4 mr-2 rtl:ml-2 rtl:mr-0" />
                {language === 'ar' ? 'تصفية' : language === 'fr' ? 'Filtrer' : 'Filters'}
              </Button>
            </SheetTrigger>
            <SheetContent side={language === 'ar' ? 'left' : 'right'}>
              <SheetHeader>
                <SheetTitle>
                  {language === 'ar' ? 'تصفية النتائج' : language === 'fr' ? 'Filtrer les résultats' : 'Filter Results'}
                </SheetTitle>
              </SheetHeader>
              <div className="py-6 space-y-6">
                <div>
                  <Label className="text-base font-medium mb-3 block">
                    {language === 'ar' ? 'مستوى الصعوبة' : language === 'fr' ? 'Niveau de difficulté' : 'Difficulty Level'}
                  </Label>
                  <div className="space-y-3">
                    {difficulties.map((diff) => (
                      <div key={diff.value} className="flex items-center space-x-2 rtl:space-x-reverse">
                        <Checkbox
                          id={diff.value}
                          checked={difficulty.includes(diff.value)}
                          onCheckedChange={(checked) => {
                            if (checked) {
                              setDifficulty([...difficulty, diff.value]);
                            } else {
                              setDifficulty(difficulty.filter(d => d !== diff.value));
                            }
                          }}
                        />
                        <Label htmlFor={diff.value} className="cursor-pointer">{diff.label}</Label>
                      </div>
                    ))}
                  </div>
                </div>

                <Button variant="outline" className="w-full" onClick={clearFilters}>
                  <X className="h-4 w-4 mr-2" />
                  {language === 'ar' ? 'مسح الفلاتر' : language === 'fr' ? 'Effacer les filtres' : 'Clear Filters'}
                </Button>
              </div>
            </SheetContent>
          </Sheet>

          {/* Applied Filters */}
          {searchParams.get('difficulty') && (
            <Badge variant="secondary" className="shrink-0">
              {searchParams.get('difficulty')}
              <Link to="#" onClick={clearFilters} className="ml-1 hover:opacity-70">
                <X className="h-3 w-3" />
              </Link>
            </Badge>
          )}
        </div>

        <div className="flex items-center gap-2 shrink-0">
          <ArrowDownUp className="h-4 w-4 text-muted-foreground shrink-0" />
          <Select value={sortBy} onValueChange={updateSort}>
            <SelectTrigger className="w-[160px]">
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

      {/* Results */}
      <div className="mb-4">
        {!loading && (
          <p className="text-muted-foreground">
            {patterns.length} {language === 'ar' ? 'نتيجة' : language === 'fr' ? 'résultats' : 'results'}
            {searchParams.get('q') && ` ${language === 'ar' ? 'لـ' : language === 'fr' ? 'pour' : 'for'} "${searchParams.get('q')}"`}
          </p>
        )}
      </div>

      {loading ? (
        <div className="masonry-grid">
          {[...Array(12)].map((_, i) => (
            <Skeleton key={i} className="h-64 rounded-xl" />
          ))}
        </div>
      ) : patterns.length > 0 ? (
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
          <Search className="h-16 w-16 mx-auto mb-4 text-muted" />
          <h2 className="text-xl font-semibold mb-2">
            {language === 'ar' ? 'لم يتم العثور على نتائج' : language === 'fr' ? 'Aucun résultat trouvé' : 'No results found'}
          </h2>
          <p className="text-muted-foreground mb-6">
            {language === 'ar' ? 'جرب تغيير مصطلحات البحث أو الفلاتر' : language === 'fr' ? 'Essayez de modifier vos termes de recherche' : 'Try adjusting your search terms or filters'}
          </p>
          <Button variant="outline" onClick={clearFilters}>
            {language === 'ar' ? 'مسح البحث' : language === 'fr' ? 'Effacer la recherche' : 'Clear Search'}
          </Button>
        </div>
      )}
    </div>
  );
}
