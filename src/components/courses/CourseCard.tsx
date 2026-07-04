import { Link } from 'react-router-dom';
import { Clock, BookOpen, Users, Star } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Course } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { cn } from '@/lib/utils';

interface CourseCardProps {
  course: Course;
}

const levelColors = {
  beginner: 'bg-green-500/10 text-green-600 dark:text-green-400',
  intermediate: 'bg-yellow-500/10 text-yellow-600 dark:text-yellow-400',
  advanced: 'bg-orange-500/10 text-orange-600 dark:text-orange-400',
  professional: 'bg-red-500/10 text-red-600 dark:text-red-400',
};

export function CourseCard({ course }: CourseCardProps) {
  const { getText, language } = useLocalText();

  const imageId = 5000000 + parseInt(course.id.slice(-4), 16) % 1000000;
  const imageUrl = course.cover_image_url || `https://images.pexels.com/photos/${imageId}/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=600`;

  const levelLabels = {
    beginner: language === 'ar' ? 'مبتدئ' : language === 'fr' ? 'Débutant' : 'Beginner',
    intermediate: language === 'ar' ? 'متوسط' : language === 'fr' ? 'Intermédiaire' : 'Intermediate',
    advanced: language === 'ar' ? 'متقدم' : language === 'fr' ? 'Avancé' : 'Advanced',
    professional: language === 'ar' ? 'احترافي' : language === 'fr' ? 'Professionnel' : 'Professional',
  };

  return (
    <Link to={`/course/${course.slug}`}>
      <Card className="overflow-hidden group card-hover border-0 shadow-md h-full">
        <div className="aspect-video relative overflow-hidden bg-muted">
          <img
            src={imageUrl}
            alt={getText(course.title)}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            loading="lazy"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />

          {/* Free/Paid Badge */}
          {course.is_free && (
            <Badge className="absolute top-3 left-3 rtl:left-auto rtl:right-3 bg-green-500 text-white">
              Free
            </Badge>
          )}

          {/* Level Badge */}
          <Badge className={cn('absolute top-3 right-3 rtl:right-auto rtl:left-3', levelColors[course.level])}>
            {levelLabels[course.level]}
          </Badge>
        </div>

        <CardContent className="p-4">
          <h3 className="font-semibold text-lg line-clamp-2 mb-2">{getText(course.title)}</h3>
          {course.subtitle && (
            <p className="text-sm text-muted-foreground line-clamp-2 mb-3">{getText(course.subtitle)}</p>
          )}

          {/* Meta info */}
          <div className="flex items-center gap-4 text-sm text-muted-foreground mb-4">
            {course.duration_hours && (
              <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" />
                <span>{course.duration_hours}h</span>
              </div>
            )}
            <div className="flex items-center gap-1">
              <BookOpen className="h-4 w-4" />
              <span>{course.lessons_count} {language === 'ar' ? 'دروس' : language === 'fr' ? 'leçons' : 'lessons'}</span>
            </div>
          </div>

          {/* Students & Rating */}
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-1 text-sm text-muted-foreground">
              <Users className="h-4 w-4" />
              <span>{course.enrolled_count.toLocaleString()}</span>
            </div>
            {course.rating_average > 0 && (
              <div className="flex items-center gap-1">
                <Star className="h-4 w-4 fill-yellow-400 text-yellow-400" />
                <span className="text-sm font-medium">{course.rating_average.toFixed(1)}</span>
                <span className="text-xs text-muted-foreground">({course.rating_count})</span>
              </div>
            )}
          </div>
        </CardContent>
      </Card>
    </Link>
  );
}
