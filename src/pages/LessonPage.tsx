import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { ChevronLeft, ChevronRight, Play, Clock, CheckCircle, Bookmark } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { supabase, Lesson, Course } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { Skeleton } from '@/components/ui/skeleton';

export default function LessonPage() {
  const { id } = useParams<{ id: string }>();
  const { getText, language } = useLocalText();
  const [lesson, setLesson] = useState<Lesson | null>(null);
  const [course, setCourse] = useState<Course | null>(null);
  const [allLessons, setAllLessons] = useState<Lesson[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentLessonIndex, setCurrentLessonIndex] = useState(0);

  useEffect(() => {
    if (id) {
      fetchLessonData();
    }
  }, [id]);

  const fetchLessonData = async () => {
    setLoading(true);
    try {
      const { data: lessonData } = await supabase
        .from('lessons')
        .select('*')
        .eq('id', id)
        .single();

      if (lessonData) {
        setLesson(lessonData);

        const { data: courseData } = await supabase
          .from('courses')
          .select('*')
          .eq('id', lessonData.course_id)
          .single();

        setCourse(courseData);

        const { data: lessonsData } = await supabase
          .from('lessons')
          .select('*')
          .eq('course_id', lessonData.course_id)
          .eq('is_published', true)
          .order('display_order');

        if (lessonsData) {
          setAllLessons(lessonsData);
          setCurrentLessonIndex(lessonsData.findIndex(l => l.id === id));
        }
      }
    } catch (error) {
      console.error('Error fetching lesson:', error);
    } finally {
      setLoading(false);
    }
  };

  const prevLesson = currentLessonIndex > 0 ? allLessons[currentLessonIndex - 1] : null;
  const nextLesson = currentLessonIndex < allLessons.length - 1 ? allLessons[currentLessonIndex + 1] : null;

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Skeleton className="h-12 w-3/4 mb-4" />
        <Skeleton className="aspect-video w-full mb-8" />
      </div>
    );
  }

  if (!lesson || !course) {
    return (
      <div className="container mx-auto px-4 py-8 text-center">
        <h1 className="text-2xl font-bold mb-4">Lesson not found</h1>
        <Button asChild>
          <Link to="/courses">Browse Courses</Link>
        </Button>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-black">
      {/* Video Player */}
      <div className="aspect-video max-h-[70vh] bg-slate-900 relative">
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="text-center text-white">
            <div className="w-20 h-20 rounded-full bg-white/20 flex items-center justify-center mx-auto mb-4">
              <Play className="h-8 w-8 ml-1" fill="white" />
            </div>
            <p className="text-lg">
              {lesson.video_duration_seconds && `${Math.floor(lesson.video_duration_seconds / 60)} min`}
            </p>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        <div className="flex items-center gap-2 text-sm text-muted-foreground mb-4">
          <Link to={`/course/${course.slug}`} className="hover:text-foreground">
            {getText(course.title)}
          </Link>
          <ChevronRight className="h-4 w-4" />
          <span>{getText(lesson.title)}</span>
        </div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
        >
          <div className="flex items-start justify-between gap-4 mb-6">
            <div>
              <h1 className="text-2xl md:text-3xl font-bold mb-2">{getText(lesson.title)}</h1>
              {lesson.video_duration_seconds && (
                <div className="flex items-center gap-2 text-muted-foreground">
                  <Clock className="h-4 w-4" />
                  <span>{Math.floor(lesson.video_duration_seconds / 60)} min</span>
                </div>
              )}
            </div>
            <div className="flex items-center gap-2">
              {lesson.is_preview && <Badge variant="outline">Preview</Badge>}
              <Button variant="outline" size="icon">
                <Bookmark className="h-4 w-4" />
              </Button>
              <Button variant="outline" size="icon">
                <CheckCircle className="h-4 w-4" />
              </Button>
            </div>
          </div>

          {lesson.description && (
            <p className="text-muted-foreground mb-8">{getText(lesson.description)}</p>
          )}

          {/* Navigation */}
          <div className="flex items-center justify-between pt-8 border-t">
            {prevLesson ? (
              <Button variant="outline" asChild>
                <Link to={`/lesson/${prevLesson.id}`}>
                  <ChevronLeft className="h-4 w-4 mr-2" />
                  {getText(prevLesson.title)}
                </Link>
              </Button>
            ) : (
              <div />
            )}
            {nextLesson ? (
              <Button asChild>
                <Link to={`/lesson/${nextLesson.id}`}>
                  {getText(nextLesson.title)}
                  <ChevronRight className="h-4 w-4 ml-2" />
                </Link>
              </Button>
            ) : (
              <Button asChild>
                <Link to={`/course/${course.slug}`}>
                  {language === 'ar' ? 'العودة للدورة' : language === 'fr' ? 'Retour au cours' : 'Back to Course'}
                </Link>
              </Button>
            )}
          </div>
        </motion.div>
      </div>
    </div>
  );
}
