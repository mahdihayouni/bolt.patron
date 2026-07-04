import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { Heart, FolderHeart, Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { supabase, Pattern, Collection } from '@/lib/supabase';
import { useAuth } from '@/contexts/AuthContext';
import { useLocalText } from '@/hooks/useLocalText';
import { PatternCard } from '@/components/patterns/PatternCard';

export default function FavoritesPage() {
  const { t } = useTranslation();
  const { user } = useAuth();
  const { language } = useLocalText();
  const [collections, setCollections] = useState<Collection[]>([]);
  const [likedPatterns, setLikedPatterns] = useState<Pattern[]>([]);

  useEffect(() => {
    if (user) {
      fetchFavoriteData();
    }
  }, [user]);

  const fetchFavoriteData = async () => {
    try {
      // Fetch collections
      const { data: collectionsData } = await supabase
        .from('collections')
        .select('*')
        .eq('user_id', user!.id);

      setCollections(collectionsData || []);

      // Fetch liked patterns
      const { data: likes } = await supabase
        .from('pattern_likes')
        .select('pattern_id')
        .eq('user_id', user!.id);

      if (likes && likes.length > 0) {
        const patternIds = likes.map(l => l.pattern_id);
        const { data: patterns } = await supabase
          .from('patterns')
          .select('*')
          .in('id', patternIds);

        setLikedPatterns(patterns || []);
      }
    } catch (error) {
      console.error('Error fetching favorites:', error);
    }
  };

  if (!user) {
    return (
      <div className="container mx-auto px-4 py-8 text-center">
        <Heart className="h-16 w-16 mx-auto mb-4 text-muted" />
        <h1 className="text-2xl font-bold mb-4">
          {language === 'ar' ? 'سجل الدخول للاطلاع على المفضلة' : language === 'fr' ? 'Connectez-vous pour voir vos favoris' : 'Sign in to view your favorites'}
        </h1>
        <Button asChild>
          <Link to="/login">{t('nav.signIn')}</Link>
        </Button>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8"
      >
        <h1 className="text-3xl font-bold mb-2">{t('nav.favorites')}</h1>
        <p className="text-muted-foreground">
          {language === 'ar' ? 'أنماطك المحفوظة والمجموعات' : language === 'fr' ? 'Vos patrons et collections sauvegardés' : 'Your saved patterns and collections'}
        </p>
      </motion.div>

      {/* Collections */}
      <section className="mb-12">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-semibold">
            {language === 'ar' ? 'المجموعات' : language === 'fr' ? 'Collections' : 'Collections'}
          </h2>
          <Button size="sm">
            <Plus className="h-4 w-4 mr-2" />
            {language === 'ar' ? 'جديد' : language === 'fr' ? 'Nouveau' : 'New'}
          </Button>
        </div>

        {collections.length > 0 ? (
          <div className="grid sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {collections.map((collection, index) => (
              <motion.div
                key={collection.id}
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: index * 0.05 }}
              >
                <Card className="overflow-hidden card-hover">
                  <div className="aspect-square bg-muted flex items-center justify-center">
                    <FolderHeart className="h-16 w-16 text-muted-foreground" />
                  </div>
                  <CardContent className="p-4">
                    <h3 className="font-medium">{collection.name}</h3>
                    <p className="text-sm text-muted-foreground">
                      {collection.patterns_count} {language === 'ar' ? 'نمط' : language === 'fr' ? 'patrons' : 'patterns'}
                    </p>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </div>
        ) : (
          <Card className="p-8 text-center">
            <FolderHeart className="h-12 w-12 mx-auto mb-4 text-muted" />
            <p className="text-muted-foreground">
              {language === 'ar' ? 'لا توجد مجموعات بعد' : language === 'fr' ? 'Pas encore de collections' : 'No collections yet'}
            </p>
          </Card>
        )}
      </section>

      {/* Liked Patterns */}
      <section>
        <h2 className="text-xl font-semibold mb-4">
          {language === 'ar' ? 'الأنماط المفضلة' : language === 'fr' ? 'Patrons aimés' : 'Liked Patterns'}
        </h2>

        {likedPatterns.length > 0 ? (
          <div className="masonry-grid">
            {likedPatterns.map((pattern, index) => (
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
          <Card className="p-8 text-center">
            <Heart className="h-12 w-12 mx-auto mb-4 text-muted" />
            <p className="text-muted-foreground">
              {language === 'ar' ? 'لم تعجب بأي نمط بعد' : language === 'fr' ? 'Vous n\'avez pas encore aimé de patrons' : 'No liked patterns yet'}
            </p>
          </Card>
        )}
      </section>
    </div>
  );
}
