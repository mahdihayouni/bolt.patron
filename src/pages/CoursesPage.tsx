import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { supabase, Course } from '@/lib/supabase';
import { CourseCard } from '@/components/courses/CourseCard';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useAuth } from '@/contexts/AuthContext';
import { useLocalText } from '@/hooks/useLocalText';

export default function CoursesPage() {
  const { t } = useTranslation();
  const { language } = useLocalText();
  const { user } = useAuth();
  const [courses, setCourses] = useState<Course[]>([]);
  const [enrolledCourses, setEnrolledCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('all');

  useEffect(() => {
    fetchCourses();
  }, [user]);

  const fetchCourses = async () => {
    setLoading(true);
    try {
      const { data: allCourses } = await supabase
        .from('courses')
        .select('*')
        .eq('is_published', true)
        .order('is_featured', { ascending: false })
        .order('enrolled_count', { ascending: false });

      if (allCourses) {
        setCourses(allCourses);
      }

      if (user) {
        const { data: enrollments } = await supabase
          .from('course_enrollments')
          .select('course_id');

        if (enrollments && allCourses) {
          const enrolledIds = enrollments.map(e => e.course_id);
          setEnrolledCourses(allCourses.filter(c => enrolledIds.includes(c.id)));
        }
      }
    } catch (error) {
      console.error('Error fetching courses:', error);
    } finally {
      setLoading(false);
    }
  };

  const beginnerCourses = courses.filter(c => c.level === 'beginner');
  const advancedCourses = courses.filter(c => c.level === 'advanced' || c.level === 'professional');

  return (
    <div className="container mx-auto px-4 py-8">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8"
      >
        <h1 className="text-3xl md:text-4xl font-bold mb-2">{t('courses.title')}</h1>
        <p className="text-muted-foreground">
          {language === 'ar' ? 'تعلم من أفضل المدربين في مجال صناعة الأنماط' : language === 'fr' ? 'Apprenez des meilleurs instructeurs' : 'Learn from the best instructors'}
        </p>
      </motion.div>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList className="w-full justify-start overflow-x-auto scrollbar-hide">
          <TabsTrigger value="all">
            {language === 'ar' ? 'الكل' : language === 'fr' ? 'Tous' : 'All'}
          </TabsTrigger>
          <TabsTrigger value="beginner">
            {language === 'ar' ? 'مبتدئ' : language === 'fr' ? 'Débutant' : 'Beginner'}
          </TabsTrigger>
          <TabsTrigger value="advanced">
            {language === 'ar' ? 'متقدم' : language === 'fr' ? 'Avancé' : 'Advanced'}
          </TabsTrigger>
          {user && (
            <TabsTrigger value="enrolled">
              {language === 'ar' ? 'مسجل' : language === 'fr' ? 'Inscrit' : 'Enrolled'}
            </TabsTrigger>
          )}
        </TabsList>

        {loading ? (
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[...Array(8)].map((_, i) => (
              <Skeleton key={i} className="h-72 rounded-xl" />
            ))}
          </div>
        ) : (
          <>
            <TabsContent value="all">
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                {courses.map((course, index) => (
                  <motion.div
                    key={course.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                  >
                    <CourseCard course={course} />
                  </motion.div>
                ))}
              </div>
            </TabsContent>

            <TabsContent value="beginner">
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                {beginnerCourses.map((course, index) => (
                  <motion.div
                    key={course.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                  >
                    <CourseCard course={course} />
                  </motion.div>
                ))}
              </div>
            </TabsContent>

            <TabsContent value="advanced">
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                {advancedCourses.map((course, index) => (
                  <motion.div
                    key={course.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                  >
                    <CourseCard course={course} />
                  </motion.div>
                ))}
              </div>
            </TabsContent>

            {user && (
              <TabsContent value="enrolled">
                {enrolledCourses.length > 0 ? (
                  <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                    {enrolledCourses.map((course, index) => (
                      <motion.div
                        key={course.id}
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: index * 0.05 }}
                      >
                        <CourseCard course={course} />
                      </motion.div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12">
                    <p className="text-muted-foreground">
                      {language === 'ar' ? 'لم تسجل في أي دورة بعد' : language === 'fr' ? "Vous n'êtes inscrit à aucun cours" : "You haven't enrolled in any courses yet"}
                    </p>
                  </div>
                )}
              </TabsContent>
            )}
          </>
        )}
      </Tabs>
    </div>
  );
}
