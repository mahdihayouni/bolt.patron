import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import {
  Search,
  ArrowRight,
  TrendingUp,
  Eye,
  Users,
  BookOpen,
  Scissors,
  Award,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { supabase, Pattern, Category, Course } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { PatternCard } from '@/components/patterns/PatternCard';
import { CategoryCard } from '@/components/categories/CategoryCard';
import { CourseCard } from '@/components/courses/CourseCard';

export default function HomePage() {
  const { t } = useTranslation();
  const { getText, language } = useLocalText();
  const [featuredPatterns, setFeaturedPatterns] = useState<Pattern[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [featuredCourses, setFeaturedCourses] = useState<Course[]>([]);
  const [trendingPatterns, setTrendingPatterns] = useState<Pattern[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchHomeData();
  }, []);

  const fetchHomeData = async () => {
    try {
      const [
        patternsResult,
        categoriesResult,
        coursesResult,
        trendingResult,
      ] = await Promise.all([
        supabase
          .from('patterns')
          .select('*')
          .eq('is_featured', true)
          .eq('is_published', true)
          .order('views_count', { ascending: false })
          .limit(8),
        supabase
          .from('categories')
          .select('*')
          .is('parent_id', null)
          .eq('is_active', true)
          .order('display_order')
          .limit(8),
        supabase
          .from('courses')
          .select('*')
          .eq('is_featured', true)
          .eq('is_published', true)
          .order('enrolled_count', { ascending: false })
          .limit(4),
        supabase
          .from('patterns')
          .select('*')
          .eq('is_published', true)
          .order('views_count', { ascending: false })
          .limit(12),
      ]);

      if (patternsResult.data) setFeaturedPatterns(patternsResult.data);
      if (categoriesResult.data) setCategories(categoriesResult.data);
      if (coursesResult.data) setFeaturedCourses(coursesResult.data);
      if (trendingResult.data) setTrendingPatterns(trendingResult.data);
    } catch (error) {
      console.error('Error fetching home data:', error);
    } finally {
      setLoading(false);
    }
  };

  const stats = [
    { icon: Scissors, value: '1,000+', label: language === 'ar' ? 'نمط' : language === 'fr' ? 'Patrons' : 'Patterns' },
    { icon: Users, value: '50K+', label: language === 'ar' ? 'مستخدم' : language === 'fr' ? 'Utilisateurs' : 'Users' },
    { icon: BookOpen, value: '100+', label: language === 'ar' ? 'دورة' : language === 'fr' ? 'Cours' : 'Courses' },
    { icon: Award, value: '95%', label: language === 'ar' ? 'رضا' : language === 'fr' ? 'Satisfaction' : 'Satisfaction' },
  ];

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-br from-violet-50 via-white to-pink-50 dark:from-slate-900 dark:via-slate-900 dark:to-slate-800">
        <div className="absolute inset-0 bg-[url('https://images.pexels.com/photos/52592/sewing-machine-needles-workshop-handicraft-52592.jpeg')] opacity-5 bg-cover bg-center" />
        <div className="container mx-auto px-4 py-20 lg:py-32 relative">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="max-w-4xl mx-auto text-center"
          >
            <Badge className="mb-4 px-4 py-2 text-sm" variant="secondary">
              {language === 'ar' ? 'منصة تعليمية متكاملة' : language === 'fr' ? 'Plateforme Éducative Complète' : 'Complete Learning Platform'}
            </Badge>
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6 leading-tight">
              {t('home.heroTitle')}
            </h1>
            <p className="text-lg md:text-xl text-muted-foreground mb-8 max-w-2xl mx-auto">
              {t('home.heroSubtitle')}
            </p>

            {/* Search Bar */}
            <div className="flex flex-col sm:flex-row gap-4 max-w-2xl mx-auto mb-12">
              <div className="relative flex-1">
                <Search className="absolute left-4 rtl:left-auto rtl:right-4 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
                <Input
                  type="search"
                  placeholder={t('nav.search')}
                  className="h-14 pl-12 rtl:pl-4 rtl:pr-12 text-lg rounded-xl shadow-lg"
                />
              </div>
              <Button size="lg" className="h-14 px-8 rounded-xl text-lg" asChild>
                <Link to="/search">
                  {t('home.browsePatterns')}
                  <ArrowRight className="ml-2 rtl:ml-0 rtl:mr-2 h-5 w-5" />
                </Link>
              </Button>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-8 max-w-3xl mx-auto">
              {stats.map((stat, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 + 0.3 }}
                  className="text-center"
                >
                  <stat.icon className="h-6 w-6 mx-auto mb-2 text-primary" />
                  <div className="text-2xl md:text-3xl font-bold">{stat.value}</div>
                  <div className="text-sm text-muted-foreground">{stat.label}</div>
                </motion.div>
              ))}
            </div>
          </motion.div>
        </div>
      </section>

      {/* Featured Categories */}
      <section className="py-16 md:py-24 bg-muted/30">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between mb-8">
            <h2 className="text-2xl md:text-3xl font-bold">{t('home.featuredCategories')}</h2>
            <Button variant="ghost" asChild>
              <Link to="/categories">
                {t('home.viewAll')}
                <ArrowRight className="ml-2 rtl:ml-0 rtl:mr-2 h-4 w-4" />
              </Link>
            </Button>
          </div>

          {loading ? (
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {[...Array(8)].map((_, i) => (
                <div key={i} className="skeleton h-48 rounded-xl" />
              ))}
            </div>
          ) : (
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {categories.map((category, index) => (
                <motion.div
                  key={category.id}
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: index * 0.05 }}
                >
                  <CategoryCard category={category} />
                </motion.div>
              ))}
            </div>
          )}
        </div>
      </section>

      {/* Featured Patterns */}
      <section className="py-16 md:py-24">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-2xl md:text-3xl font-bold">{t('patterns.featured')}</h2>
              <p className="text-muted-foreground mt-1">
                {language === 'ar' ? 'أنماط مختارة بعناية من خبرائنا' : language === 'fr' ? 'Patrons sélectionnés par nos experts' : 'Handpicked patterns by our experts'}
              </p>
            </div>
            <Button variant="ghost" asChild>
              <Link to="/categories">
                {t('home.viewAll')}
                <ArrowRight className="ml-2 rtl:ml-0 rtl:mr-2 h-4 w-4" />
              </Link>
            </Button>
          </div>

          {loading ? (
            <div className="masonry-grid">
              {[...Array(8)].map((_, i) => (
                <div key={i} className="masonry-item">
                  <div className="skeleton h-64 rounded-xl" />
                </div>
              ))}
            </div>
          ) : (
            <div className="masonry-grid">
              {featuredPatterns.map((pattern, index) => (
                <motion.div
                  key={pattern.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.05 }}
                  className="masonry-item"
                >
                  <PatternCard pattern={pattern} />
                </motion.div>
              ))}
            </div>
          )}
        </div>
      </section>

      {/* Trending Patterns */}
      <section className="py-16 md:py-24 bg-muted/30">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between mb-8">
            <div className="flex items-center gap-3">
              <TrendingUp className="h-6 w-6 text-primary" />
              <h2 className="text-2xl md:text-3xl font-bold">{t('home.trendingPatterns')}</h2>
            </div>
            <Button variant="ghost" asChild>
              <Link to="/search?sort=trending">
                {t('home.viewAll')}
                <ArrowRight className="ml-2 rtl:ml-0 rtl:mr-2 h-4 w-4" />
              </Link>
            </Button>
          </div>

          {loading ? (
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
              {[...Array(6)].map((_, i) => (
                <div key={i} className="skeleton h-48 rounded-xl" />
              ))}
            </div>
          ) : (
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
              {trendingPatterns.slice(0, 6).map((pattern, index) => (
                <motion.div
                  key={pattern.id}
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: index * 0.05 }}
                >
                  <Link to={`/pattern/${pattern.slug}`}>
                    <Card className=" overflow-hidden group card-hover">
                      <div className="aspect-[3/4] bg-muted relative overflow-hidden">
                        <img
                          src={`https://images.pexels.com/photos/${6000000 + index}-pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=400`}
                          alt={getText(pattern.title)}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                        />
                        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                        <div className="absolute bottom-0 left-0 right-0 p-3 text-white">
                          <p className="text-sm font-medium line-clamp-2">{getText(pattern.title)}</p>
                          <div className="flex items-center gap-2 mt-1 text-xs opacity-80">
                            <Eye className="h-3 w-3" />
                            <span>{pattern.views_count}</span>
                          </div>
                        </div>
                      </div>
                    </Card>
                  </Link>
                </motion.div>
              ))}
            </div>
          )}
        </div>
      </section>

      {/* Featured Courses */}
      <section className="py-16 md:py-24">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-2xl md:text-3xl font-bold">{t('home.popularCourses')}</h2>
              <p className="text-muted-foreground mt-1">
                {language === 'ar' ? 'تعلم من أفضل المدربين' : language === 'fr' ? 'Apprenez des meilleurs instructeurs' : 'Learn from top instructors'}
              </p>
            </div>
            <Button variant="ghost" asChild>
              <Link to="/courses">
                {t('home.viewAll')}
                <ArrowRight className="ml-2 rtl:ml-0 rtl:mr-2 h-4 w-4" />
              </Link>
            </Button>
          </div>

          {loading ? (
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {[...Array(4)].map((_, i) => (
                <div key={i} className="skeleton h-72 rounded-xl" />
              ))}
            </div>
          ) : (
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {featuredCourses.map((course, index) => (
                <motion.div
                  key={course.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 }}
                >
                  <CourseCard course={course} />
                </motion.div>
              ))}
            </div>
          )}

          {/* CTA */}
          <div className="text-center mt-12">
            <Button size="lg" asChild className="px-8">
              <Link to="/courses">
                {t('home.startLearning')}
              </Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Newsletter / CTA Section */}
      <section className="py-16 md:py-24 bg-gradient-to-br from-violet-600 to-pink-600 text-white">
        <div className="container mx-auto px-4 text-center">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5 }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              {language === 'ar' ? 'انضم إلى مجتمعنا' : language === 'fr' ? 'Rejoignez notre communauté' : 'Join Our Community'}
            </h2>
            <p className="text-white/80 max-w-2xl mx-auto mb-8">
              {language === 'ar'
                ? 'احصل على أحدث الأنماط والدورات مباشرة في بريدك الإلكتروني'
                : language === 'fr'
                ? 'Recevez les derniers patrons et cours directement dans votre boîte mail'
                : 'Get the latest patterns and courses delivered to your inbox'}
            </p>
            <div className="flex flex-col sm:flex-row gap-4 max-w-md mx-auto">
              <Input
                type="email"
                placeholder={t('auth.email')}
                className="h-12 text-foreground"
              />
              <Button size="lg" variant="secondary" className="h-12 px-8">
                {language === 'ar' ? 'اشترك' : language === 'fr' ? 'S\'abonner' : 'Subscribe'}
              </Button>
            </div>
          </motion.div>
        </div>
      </section>
    </div>
  );
}
