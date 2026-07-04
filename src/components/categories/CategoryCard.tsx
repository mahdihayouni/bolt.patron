import { Link } from 'react-router-dom';
import { ArrowRight } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { Category } from '@/lib/supabase';
import { useLocalText } from '@/hooks/useLocalText';

interface CategoryCardProps {
  category: Category;
  variant?: 'default' | 'large';
}

const categoryImages: Record<string, string[]> = {
  women: [
    'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg',
    'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg',
  ],
  men: [
    'https://images.pexels.com/photos/428340/pexels-photo-428340.jpeg',
    'https://images.pexels.com/photos/3081834/pexels-photo-3081834.jpeg',
  ],
  children: [
    'https://images.pexels.com/photos/1620760/pexels-photo-1620760.jpeg',
    'https://images.pexels.com/photos/1450071/pexels-photo-1450071.jpeg',
  ],
  accessories: [
    'https://images.pexels.com/photos/1152077/pexels-photo-1152077.jpeg',
    'https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg',
  ],
  traditional: [
    'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg',
    'https://images.pexels.com/photos/2867674/pexels-photo-2867674.jpeg',
  ],
};

export function CategoryCard({ category, variant = 'default' }: CategoryCardProps) {
  const { getText } = useLocalText();

  // Get image based on category slug or default
  const images = categoryImages[category.slug] || categoryImages.women;
  const imageUrl = category.image_url || images[0];

  if (variant === 'large') {
    return (
      <Link to={`/category/${category.slug}`}>
        <Card className="relative overflow-hidden group aspect-[4/3] card-hover border-0">
          <img
            src={imageUrl}
            alt={getText(category.name)}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            loading="lazy"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent" />
          <div className="absolute bottom-0 left-0 right-0 p-6 text-white">
            <h3 className="text-2xl font-bold mb-2">{getText(category.name)}</h3>
            {category.description && (
              <p className="text-white/80 line-clamp-2">{getText(category.description)}</p>
            )}
            <div className="flex items-center mt-4 text-primary-foreground/80 group-hover:text-primary-foreground">
              <span>{getText({ en: 'Explore', fr: 'Explorer', ar: 'استكشف' })}</span>
              <ArrowRight className="ml-2 rtl:ml-0 rtl:mr-2 h-4 w-4 group-hover:translate-x-1 rtl:group-hover:-translate-x-1 transition-transform" />
            </div>
          </div>
        </Card>
      </Link>
    );
  }

  return (
    <Link to={`/category/${category.slug}`}>
      <Card className="relative overflow-hidden group aspect-square card-hover border-0 shadow-md">
        <img
          src={imageUrl}
          alt={getText(category.name)}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
          loading="lazy"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent" />
        <div className="absolute bottom-0 left-0 right-0 p-4 text-white">
          <h3 className="font-semibold text-lg">{getText(category.name)}</h3>
        </div>
      </Card>
    </Link>
  );
}
