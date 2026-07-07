import { Link } from 'react-router-dom';
import { Heart, Download, Eye, Star } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Pattern } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';
import { cn } from '@/lib/utils';

interface PatternCardProps {
  pattern: Pattern;
  coverImageUrl?: string | null;
}

const difficultyColors = {
  beginner: 'bg-green-500/10 text-green-600 dark:text-green-400',
  intermediate: 'bg-yellow-500/10 text-yellow-600 dark:text-yellow-400',
  advanced: 'bg-orange-500/10 text-orange-600 dark:text-orange-400',
  professional: 'bg-red-500/10 text-red-600 dark:text-red-400',
};

export function PatternCard({ pattern, coverImageUrl }: PatternCardProps) {
  const { getText } = useLocalText();

  // Generate dynamic aspect ratio for Pinterest-style layout
  const aspectRatios = ['aspect-[3/4]', 'aspect-[4/5]', 'aspect-[2/3]', 'aspect-[3/5]'];
  const randomAspect = aspectRatios[pattern.id.charCodeAt(0) % aspectRatios.length];

  // Use provided cover image URL or generate a placeholder
  const imageId = 6000000 + parseInt(pattern.id.slice(-4), 16) % 1000000;
  const imageUrl = coverImageUrl || `https://images.pexels.com/photos/${imageId}/pexels-photo.jpeg?auto=compress&cs=tinysrgb&w=600`;

  return (
    <Link to={`/pattern/${pattern.slug}`}>
      <Card className="overflow-hidden group card-hover border-0 shadow-md">
        <div className={cn(randomAspect, 'relative overflow-hidden bg-muted')}>
          <img
            src={imageUrl}
            alt={getText(pattern.title)}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            loading="lazy"
          />

          {/* Gradient overlay */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />

          {/* Top badges */}
          <div className="absolute top-3 left-3 rtl:left-auto rtl:right-3 flex gap-2">
            {pattern.is_featured && (
              <Badge className="bg-primary text-primary-foreground">
                <Star className="h-3 w-3 mr-1 fill-current" />
                Featured
              </Badge>
            )}
          </div>

          {/* Save button */}
          <Button
            variant="ghost"
            size="icon"
            className="absolute top-3 right-3 rtl:right-auto rtl:left-3 bg-white/80 dark:bg-black/50 hover:bg-white dark:hover:bg-black/70 backdrop-blur-sm"
            onClick={(e) => {
              e.preventDefault();
              e.stopPropagation();
            }}
          >
            <Heart className="h-4 w-4" />
          </Button>

          {/* Bottom content */}
          <div className="absolute bottom-0 left-0 right-0 p-4 text-white">
            <Badge className={cn('mb-2', difficultyColors[pattern.difficulty])}>
              {pattern.difficulty.charAt(0).toUpperCase() + pattern.difficulty.slice(1)}
            </Badge>
            <h3 className="font-semibold text-lg line-clamp-2 mb-2">{getText(pattern.title)}</h3>

            {/* Stats */}
            <div className="flex items-center gap-4 text-sm text-white/80">
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

            {/* Rating */}
            {pattern.rating_average > 0 && (
              <div className="flex items-center gap-1 mt-2">
                <Star className="h-4 w-4 fill-yellow-400 text-yellow-400" />
                <span className="text-sm">{pattern.rating_average.toFixed(1)}</span>
                <span className="text-xs text-white/60">({pattern.rating_count})</span>
              </div>
            )}
          </div>
        </div>
      </Card>
    </Link>
  );
}
