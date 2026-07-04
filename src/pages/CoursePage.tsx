import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { ChevronRight, Clock, BookOpen, Users, Star, Play, Award } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { supabase, Course, Lesson } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { useAuth } from '@/contexts/AuthContext';
import { Skeleton } from '@/components/ui/skeleton';

export default function CoursePage() {
  const { slug } = useParams<{ slug: string }>();
  const { t } = useTranslation();
  const { getText, language } = useLocalText();
  const { user } = useAuth();
  const [course, setCourse] = useState<Course | null>(null);
  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [loading, setLoading] = useState(true);
  const [isEnrolled, setIsEnrolled] = useState(false);

  useEffect(() => {
    if (slug) {
      fetchCourseData();
    }
  }, [slug, user]);

  const fetchCourseData = async () => {
    setLoading(true);
    try {
      const { data: courseData } = await supabase
        .from('courses')
        .select('*')
        .eq('slug', slug)
        .single();

      if (courseData) {
        setCourse(courseData);

        const { data: lessonsData } = await supabase
          .from('lessons')
          .select('*')
          .eq('course_id', courseData.id)
          .eq('is_published', true)
          .order('display_order');

        setLessons(lessonsData || []);

        if (user) {
          const { data: enrollment } = await supabase
            .from('course_enrollments')
            .select('*')
            .eq('user_id', user.id)
            .eq('course_id', courseData.id)
            .single();

          setIsEnrolled(!!enrollment);
        }
      }
    } catch (error) {
      console.error('Error fetching course:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleEnroll = async () => {
    if (!user || !course) return;
    try {
      await supabase.from('course_enrollments').insert({
        user_id: user.id,
        course_id: course.id,
      });
      setIsEnrolled(true);
    } catch (error) {
      console.error('Error enrolling:', error);
    }
  };

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Skeleton className="h-64 w-full mb-8 rounded-xl" />
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

  if (!course) {
    return (
      <div className="container mx-auto px-4 py-8 text-center">
        <h1 className="text-2xl font-bold mb-4">
          {language === 'ar' ? 'الدورة غير موجودة' : language === 'fr' ? 'Cours non trouvé' : 'Course not found'}
        </h1>
        <Button asChild>
          <Link to="/courses">{t('courses.title')}</Link>
        </Button>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <div className="bg-gradient-to-br from-violet-600 to-pink-600 text-white py-16">
        <div className="container mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="max-w-4xl"
          >
            <div className="flex items-center gap-2 text-sm mb-4 opacity-80">
              <Link to="/" className="hover:underline">{t('nav.home')}</Link>
              <ChevronRight className="h-4 w-4" />
              <Link to="/courses" className="hover:underline">{t('courses.title')}</Link>
              <ChevronRight className="h-4 w-4" />
              <span>{getText(course.title)}</span>
            </div>

            <Badge className="mb-4 bg-white/20">
              {course.level.charAt(0).toUpperCase() + course.level.slice(1)}
            </Badge>

            <h1 className="text-3xl md:text-4xl font-bold mb-4">{getText(course.title)}</h1>
            {course.subtitle && (
              <p className="text-lg opacity-90 mb-6">{getText(course.subtitle)}</p>
            )}

            <div className="flex flex-wrap items-center gap-4 text-sm">
              <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" />
                <span>{course.duration_hours}h</span>
              </div>
              <div className="flex items-center gap-1">
                <BookOpen className="h-4 w-4" />
                <span>{lessons.length} {t('courses.lessons')}</span>
              </div>
              <div className="flex items-center gap-1">
                <Users className="h-4 w-4" />
                <span>{course.enrolled_count.toLocaleString()}</span>
              </div>
              {course.rating_average > 0 && (
                <div className="flex items-center gap-1">
                  <Star className="h-4 w-4 fill-current" />
                  <span>{course.rating_average.toFixed(1)}</span>
                </div>
              )}
              {course.is_free && <Badge variant="secondary">Free</Badge>}
            </div>
          </motion.div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-8">
            {/* Description */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
            >
              <h2 className="text-xl font-semibold mb-4">
                {language === 'ar' ? 'وصف الدورة' : language === 'fr' ? 'Description du cours' : 'Course Description'}
              </h2>
              <div className="prose dark:prose-invert max-w-none">
                <p>{getText(course.description)}</p>
              </div>
            </motion.div>

            {/* Lessons */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
            >
              <h2 className="text-xl font-semibold mb-4">
                {language === 'ar' ? 'محتويات الدورة' : language === 'fr' ? 'Contenu du cours' : 'Course Content'}
              </h2>
              <div className="space-y-2">
                {lessons.map((lesson, index) => (
                  <Link
                    key={lesson.id}
                    to={`/lesson/${lesson.id}`}
                    className={`flex items-center gap-4 p-4 rounded-lg border transition-colors ${
                      lesson.is_preview || isEnrolled
                        ? 'hover:bg-muted'
                        : 'opacity-50 cursor-not-allowed'
                    }`}
                  >
                    <div className="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center text-sm font-medium">
                      {index + 1}
                    </div>
                    <div className="flex-1">
                      <p className="font-medium">{getText(lesson.title)}</p>
                      {lesson.video_duration_seconds && (
                        <p className="text-sm text-muted-foreground">
                          {Math.floor(lesson.video_duration_seconds / 60)} min
                        </p>
                      )}
                    </div>
                    {lesson.is_preview && (
                      <Badge variant="outline">Preview</Badge>
                    )}
                    <Play className="h-4 w-4 text-muted-foreground" />
                  </Link>
                ))}
              </div>
            </motion.div>
          </div>

          {/* Sidebar */}
          <div>
            <motion.div
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.3 }}
              className="sticky top-24 space-y-4"
            >
              <div className="rounded-xl border p-6 space-y-4">
                {isEnrolled ? (
                  <>
                    <div className="space-y-2">
                      <div className="flex justify-between text-sm">
                        <span>{t('courses.progress')}</span>
                        <span>0%</span>
                      </div>
                      <Progress value={0} />
                    </div>
                    <Button className="w-full" asChild>
                      <Link to={`/lesson/${lessons[0]?.id}`}>
                        {t('courses.continueLearning')}
                      </Link>
                    </Button>
                  </>
                ) : (
                  <>
                    <div className="text-center py-4">
                      {course.is_free ? (
                        <Badge className="bg-green-500 text-white mb-4">Free Course</Badge>
                      ) : (
                        <div className="text-3xl font-bold mb-2">${course.price}</div>
                      )}
                    </div>
                    <Button className="w-full" onClick={handleEnroll}>
                      {t('courses.enrollNow')}
                    </Button>
                  </>
                )}
              </div>

              {course.certificate_template && (
                <div className="flex items-center gap-3 p-4 rounded-lg bg-muted">
                  <Award className="h-8 w-8 text-primary" />
                  <div>
                    <p className="font-medium">{t('courses.certificate')}</p>
                    <p className="text-xs text-muted-foreground">
                      {language === 'ar' ? 'متاح عند الإكمال' : language === 'fr' ? 'Disponible à la fin' : 'Available upon completion'}
                    </p>
                  </div>
                </div>
              )}
            </motion.div>
          </div>
        </div>
      </div>
    </div>
  );
}
