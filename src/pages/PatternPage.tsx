import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import {
  ChevronRight,
  Heart,
  Download,
  Share2,
  Printer,
  Clock,
  Eye,
  Star,
  MessageCircle,
  ChevronLeft,
  FileText,
  Package,
  FileArchive,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Separator } from '@/components/ui/separator';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { supabase, Pattern, PatternImage, PatternFile } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/lib/utils';

const difficultyLabels = {
  beginner: { en: 'Beginner', fr: 'Débutant', ar: 'مبتدئ' },
  intermediate: { en: 'Intermediate', fr: 'Intermédiaire', ar: 'متوسط' },
  advanced: { en: 'Advanced', fr: 'Avancé', ar: 'متقدم' },
  professional: { en: 'Professional', fr: 'Professionnel', ar: 'احترافي' },
};

const difficultyColors = {
  beginner: 'bg-green-500/10 text-green-600 dark:text-green-400',
  intermediate: 'bg-yellow-500/10 text-yellow-600 dark:text-yellow-400',
  advanced: 'bg-orange-500/10 text-orange-600 dark:text-orange-400',
  professional: 'bg-red-500/10 text-red-600 dark:text-red-400',
};

export default function PatternPage() {
  const { slug } = useParams<{ slug: string }>();
  const { t } = useTranslation();
  const { getText, language } = useLocalText();
  const [pattern, setPattern] = useState<Pattern | null>(null);
  const [images, setImages] = useState<PatternImage[]>([]);
  const [files, setFiles] = useState<PatternFile[]>([]);
  const [relatedPatterns, setRelatedPatterns] = useState<Pattern[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedImage, setSelectedImage] = useState(0);
  const [isZoomed, setIsZoomed] = useState(false);

  useEffect(() => {
    if (slug) {
      fetchPatternData();
    }
  }, [slug]);

  const fetchPatternData = async () => {
    setLoading(true);
    try {
      const { data: patternData } = await supabase
        .from('patterns')
        .select('*')
        .eq('slug', slug)
        .single();

      if (patternData) {
        setPattern(patternData);

        // Fetch pattern images from database
        const { data: imagesData } = await supabase
          .from('pattern_images')
          .select('*')
          .eq('pattern_id', patternData.id)
          .order('display_order', { ascending: true });

        if (imagesData && imagesData.length > 0) {
          setImages(imagesData);
          // Set selected image to the primary one
          const primaryIndex = imagesData.findIndex(img => img.is_primary);
          if (primaryIndex >= 0) setSelectedImage(primaryIndex);
        } else {
          // Fallback placeholder images
          const placeholderImages: PatternImage[] = [
            { id: '1', pattern_id: patternData.id, image_url: `https://images.pexels.com/photos/4429476/pexels-photo-4429476.jpeg?auto=compress&cs=tinysrgb&w=800`, image_type: 'photo', display_order: 0, is_primary: true, created_at: new Date().toISOString(), alt_text: { en: '', fr: '', ar: '' }, thumbnail_url: '', width: 800, height: 1200, file_size: null, storage_path: null },
          ];
          setImages(placeholderImages);
        }

        // Fetch pattern files from database
        const { data: filesData } = await supabase
          .from('pattern_files')
          .select('*')
          .eq('pattern_id', patternData.id)
          .order('display_order', { ascending: true });

        setFiles(filesData || []);

        // Fetch related patterns
        const { data: related } = await supabase
          .from('patterns')
          .select('*')
          .eq('category_id', patternData.category_id)
          .neq('id', patternData.id)
          .limit(6);

        setRelatedPatterns(related || []);

        // Increment views
        await supabase.rpc('increment_pattern_views', { pattern_id: patternData.id });
      }
    } catch (error) {
      console.error('Error fetching pattern:', error);
    } finally {
      setLoading(false);
    }
  };

  const getFileIcon = (fileType: string) => {
    switch (fileType) {
      case 'pdf':
        return <FileText className="h-4 w-4" />;
      case 'zip':
        return <FileArchive className="h-4 w-4" />;
      case 'svg':
      case 'dxf':
      case 'ai':
        return <Package className="h-4 w-4" />;
      default:
        return <Download className="h-4 w-4" />;
    }
  };

  const handleDownload = (file: PatternFile) => {
    window.open(file.public_url, '_blank');
  };

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Skeleton className="h-96 w-full mb-8 rounded-xl" />
        <div className="grid md:grid-cols-3 gap-8">
          <div className="col-span-2">
            <Skeleton className="h-12 w-3/4 mb-4" />
            <Skeleton className="h-6 w-1/2 mb-6" />
            <Skeleton className="h-32 w-full" />
          </div>
          <Skeleton className="h-64" />
        </div>
      </div>
    );
  }

  if (!pattern) {
    return (
      <div className="container mx-auto px-4 py-8 text-center">
        <h1 className="text-2xl font-bold mb-4">
          {language === 'ar' ? 'النمط غير موجود' : language === 'fr' ? 'Patron non trouvé' : 'Pattern not found'}
        </h1>
        <Button asChild>
          <Link to="/categories">{t('categories.title')}</Link>
        </Button>
      </div>
    );
  }

  const sizes = Array.isArray(pattern.sizes) ? pattern.sizes : (typeof pattern.sizes === 'string' ? JSON.parse(pattern.sizes) : []);

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Breadcrumb */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        className="flex items-center gap-2 text-sm text-muted-foreground mb-6"
      >
        <Link to="/" className="hover:text-foreground transition-colors">{t('nav.home')}</Link>
        <ChevronRight className="h-4 w-4" />
        <Link to="/categories" className="hover:text-foreground transition-colors">{t('categories.title')}</Link>
        <ChevronRight className="h-4 w-4" />
        <span className="text-foreground">{getText(pattern.title)}</span>
      </motion.div>

      <div className="grid lg:grid-cols-3 gap-8">
        {/* Images Section */}
        <div className="lg:col-span-2">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="space-y-4"
          >
            {/* Main Image */}
            <div
              className={cn(
                "relative aspect-[4/3] rounded-xl overflow-hidden bg-muted",
                isZoomed && "cursor-zoom-out"
              )}
              onClick={() => setIsZoomed(!isZoomed)}
            >
              <img
                src={images[selectedImage]?.image_url || `https://images.pexels.com/photos/4429476/pexels-photo-4429476.jpeg?auto=compress&cs=tinysrgb&w=800`}
                alt={getText(pattern.title)}
                className={cn(
                  "w-full h-full object-cover transition-transform duration-300",
                  isZoomed && "scale-150"
                )}
              />

              {/* Navigation arrows */}
              {images.length > 1 && (
                <>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 dark:bg-black/50"
                    onClick={(e) => {
                      e.stopPropagation();
                      setSelectedImage(prev => prev > 0 ? prev - 1 : images.length - 1);
                    }}
                  >
                    <ChevronLeft className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 dark:bg-black/50"
                    onClick={(e) => {
                      e.stopPropagation();
                      setSelectedImage(prev => prev < images.length - 1 ? prev + 1 : 0);
                    }}
                  >
                    <ChevronRight className="h-4 w-4" />
                  </Button>
                </>
              )}

              {/* Image type badge */}
              <Badge className="absolute top-4 left-4 rtl:left-auto rtl:right-4">
                {images[selectedImage]?.image_type || 'photo'}
              </Badge>
            </div>

            {/* Thumbnail Strip */}
            {images.length > 1 && (
              <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
                {images.map((img, index) => (
                  <button
                    key={img.id}
                    onClick={() => setSelectedImage(index)}
                    className={cn(
                      "flex-shrink-0 w-20 h-20 rounded-lg overflow-hidden border-2 transition-all",
                      selectedImage === index ? "border-primary" : "border-transparent"
                    )}
                  >
                    <img
                      src={img.image_url}
                      alt=""
                      className="w-full h-full object-cover"
                    />
                  </button>
                ))}
              </div>
            )}
          </motion.div>
        </div>

        {/* Info Section */}
        <div className="space-y-6">
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2 }}
          >
            {/* Title & Stats */}
            <Badge className={cn('mb-3', difficultyColors[pattern.difficulty])}>
              {difficultyLabels[pattern.difficulty][language]}
            </Badge>

            <h1 className="text-2xl md:text-3xl font-bold mb-3">{getText(pattern.title)}</h1>

            {/* Rating */}
            {pattern.rating_average > 0 && (
              <div className="flex items-center gap-2 mb-4">
                <div className="flex items-center gap-1">
                  {[1, 2, 3, 4, 5].map((star) => (
                    <Star
                      key={star}
                      className={cn(
                        "h-5 w-5",
                        star <= Math.round(pattern.rating_average)
                          ? "fill-yellow-400 text-yellow-400"
                          : "text-muted"
                      )}
                    />
                  ))}
                </div>
                <span className="text-sm text-muted-foreground">
                  {pattern.rating_average.toFixed(1)} ({pattern.rating_count} {language === 'ar' ? 'تقييم' : language === 'fr' ? 'avis' : 'reviews'})
                </span>
              </div>
            )}

            {/* Stats */}
            <div className="flex items-center gap-6 text-sm text-muted-foreground mb-6">
              <div className="flex items-center gap-1">
                <Eye className="h-4 w-4" />
                <span>{pattern.views_count.toLocaleString()}</span>
              </div>
              <div className="flex items-center gap-1">
                <Download className="h-4 w-4" />
                <span>{pattern.downloads_count.toLocaleString()}</span>
              </div>
              <div className="flex items-center gap-1">
                <Heart className="h-4 w-4" />
                <span>{pattern.likes_count.toLocaleString()}</span>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex flex-wrap gap-2">
              {files.length > 0 ? (
                <Button size="lg" className="flex-1" onClick={() => handleDownload(files.find(f => f.is_primary) || files[0])}>
                  <Download className="h-4 w-4 mr-2" />
                  {t('patterns.download')}
                </Button>
              ) : (
                <Button size="lg" className="flex-1" disabled>
                  <Download className="h-4 w-4 mr-2" />
                  {t('patterns.download')}
                </Button>
              )}
              <Button size="lg" variant="outline">
                <Heart className="h-4 w-4" />
              </Button>
              <Button size="lg" variant="outline">
                <Share2 className="h-4 w-4" />
              </Button>
              <Button size="lg" variant="outline">
                <Printer className="h-4 w-4" />
              </Button>
            </div>

            {/* Download Files List */}
            {files.length > 1 && (
              <div className="mt-4">
                <h3 className="font-medium mb-3">
                  {language === 'ar' ? 'الملفات المتاحة' : language === 'fr' ? 'Fichiers disponibles' : 'Available Files'}
                </h3>
                <div className="space-y-2">
                  {files.map((file) => (
                    <button
                      key={file.id}
                      onClick={() => handleDownload(file)}
                      className="w-full flex items-center justify-between p-3 rounded-lg border hover:bg-muted/50 transition-colors"
                    >
                      <div className="flex items-center gap-3">
                        <div className="flex items-center justify-center w-10 h-10 rounded-md bg-primary/10 text-primary">
                          {getFileIcon(file.file_type)}
                        </div>
                        <div className="text-left rtl:text-right">
                          <p className="font-medium">{getText(file.display_name) || file.file_name}</p>
                          {file.file_size && (
                            <p className="text-xs text-muted-foreground">
                              {(file.file_size / 1024 / 1024).toFixed(2)} MB
                            </p>
                          )}
                        </div>
                      </div>
                      <Badge variant="outline" className="uppercase">{file.file_type}</Badge>
                    </button>
                  ))}
                </div>
              </div>
            )}
          </motion.div>

          <Separator />

          {/* Details */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.3 }}
            className="space-y-4"
          >
            {pattern.estimated_time_minutes && (
              <div className="flex items-center gap-2">
                <Clock className="h-5 w-5 text-muted-foreground" />
                <span className="text-sm">
                  {t('patterns.estimatedTime')}: {Math.floor(pattern.estimated_time_minutes / 60)}h {pattern.estimated_time_minutes % 60}m
                </span>
              </div>
            )}

            {sizes.length > 0 && (
              <div>
                <h3 className="font-medium mb-2">{t('patterns.sizes')}</h3>
                <div className="flex flex-wrap gap-2">
                  {sizes.map((size: string) => (
                    <Badge key={size} variant="outline">{size}</Badge>
                  ))}
                </div>
              </div>
            )}

            {pattern.fabric_recommendations && (
              <div>
                <h3 className="font-medium mb-2">{t('patterns.fabric')}</h3>
                <p className="text-sm text-muted-foreground">{getText(pattern.fabric_recommendations)}</p>
              </div>
            )}
          </motion.div>
        </div>
      </div>

      {/* Description & Details Tabs */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
        className="mt-12"
      >
        <Tabs defaultValue="description">
          <TabsList className="w-full justify-start">
            <TabsTrigger value="description">
              {language === 'ar' ? 'الوصف' : language === 'fr' ? 'Description' : 'Description'}
            </TabsTrigger>
            <TabsTrigger value="instructions">
              {language === 'ar' ? 'التعليمات' : language === 'fr' ? 'Instructions' : 'Instructions'}
            </TabsTrigger>
            <TabsTrigger value="reviews">
              {language === 'ar' ? 'التقييمات' : language === 'fr' ? 'Avis' : 'Reviews'}
            </TabsTrigger>
            <TabsTrigger value="comments">
              {language === 'ar' ? 'التعليقات' : language === 'fr' ? 'Commentaires' : 'Comments'}
            </TabsTrigger>
          </TabsList>
          <TabsContent value="description" className="pt-6">
            {pattern.description ? (
              <div className="prose dark:prose-invert max-w-none">
                <p>{getText(pattern.description)}</p>
              </div>
            ) : (
              <p className="text-muted-foreground">
                {language === 'ar' ? 'لا يوجد وصف متاح' : language === 'fr' ? 'Pas de description disponible' : 'No description available'}
              </p>
            )}
            {pattern.tags && pattern.tags.length > 0 && (
              <div className="mt-6">
                <h3 className="font-medium mb-3">
                  {language === 'ar' ? 'العلامات' : language === 'fr' ? 'Tags' : 'Tags'}
                </h3>
                <div className="flex flex-wrap gap-2">
                  {pattern.tags.map((tag) => (
                    <Badge key={tag} variant="secondary">{tag}</Badge>
                  ))}
                </div>
              </div>
            )}
          </TabsContent>
          <TabsContent value="instructions" className="pt-6">
            <p className="text-muted-foreground">
              {language === 'ar' ? 'التعليمات متاحة بعد التحميل' : language === 'fr' ? 'Instructions disponibles après téléchargement' : 'Instructions available after download'}
            </p>
          </TabsContent>
          <TabsContent value="reviews" className="pt-6">
            <div className="text-center py-8">
              <Star className="h-12 w-12 mx-auto mb-4 text-muted" />
              <p className="text-muted-foreground">
                {language === 'ar' ? 'كن أول من يقيّم هذا النمط' : language === 'fr' ? 'Soyez le premier à évaluer ce patron' : 'Be the first to review this pattern'}
              </p>
              <Button className="mt-4">
                {language === 'ar' ? 'أضف تقييم' : language === 'fr' ? 'Ajouter un avis' : 'Add Review'}
              </Button>
            </div>
          </TabsContent>
          <TabsContent value="comments" className="pt-6">
            <div className="text-center py-8">
              <MessageCircle className="h-12 w-12 mx-auto mb-4 text-muted" />
              <p className="text-muted-foreground">
                {language === 'ar' ? 'لا توجد تعليقات' : language === 'fr' ? 'Aucun commentaire' : 'No comments yet'}
              </p>
            </div>
          </TabsContent>
        </Tabs>
      </motion.div>

      {/* Related Patterns */}
      {relatedPatterns.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="mt-16"
        >
          <h2 className="text-2xl font-bold mb-6">{t('patterns.relatedPatterns')}</h2>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
            {relatedPatterns.map((p, index) => {
              const relatedImageId = 6000000 + parseInt(p.id.slice(-4), 16) % 1000000;
              const relatedImageUrl = `https://images.pexels.com/photos/${relatedImageId}/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=400`;
              return (
                <motion.div
                  key={p.id}
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: index * 0.05 }}
                >
                  <Link to={`/pattern/${p.slug}`}>
                    <div className="aspect-[3/4] rounded-lg overflow-hidden bg-muted relative group">
                      <img
                        src={relatedImageUrl}
                        alt={getText(p.title)}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                      <div className="absolute bottom-0 left-0 right-0 p-3 text-white">
                        <p className="text-sm font-medium line-clamp-2">{getText(p.title)}</p>
                      </div>
                    </div>
                  </Link>
                </motion.div>
              );
            })}
          </div>
        </motion.div>
      )}
    </div>
  );
}
