import { Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Home, Grid3X3, BookOpen, Heart, User } from 'lucide-react';
import { cn } from '@/lib/utils';
import { useAuth } from '@/contexts/AuthContext';

const navItems = [
  { href: '/', icon: Home, labelKey: 'nav.home' },
  { href: '/categories', icon: Grid3X3, labelKey: 'nav.categories' },
  { href: '/courses', icon: BookOpen, labelKey: 'nav.courses' },
  { href: '/favorites', icon: Heart, labelKey: 'nav.favorites' },
  { href: '/profile', icon: User, labelKey: 'nav.profile' },
];

export function BottomNav() {
  const { t } = useTranslation();
  const location = useLocation();
  const { user } = useAuth();

  return (
    <nav className="bottom-nav md:hidden">
      <div className="flex items-center justify-around py-2 home-indicator-safe">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = location.pathname === item.href;
          const requiresAuth = item.href === '/favorites' || item.href === '/profile';
          const showItem = !requiresAuth || user;

          if (!showItem) {
            return (
              <Link
                key={item.href}
                to="/login"
                className={cn(
                  'flex flex-col items-center justify-center py-2 px-4 text-muted-foreground transition-colors',
                  'hover:text-foreground'
                )}
              >
                <Icon className="h-5 w-5" />
                <span className="text-xs mt-1">{t(item.labelKey)}</span>
              </Link>
            );
          }

          return (
            <Link
              key={item.href}
              to={item.href}
              className={cn(
                'flex flex-col items-center justify-center py-2 px-4 transition-colors',
                isActive
                  ? 'text-primary'
                  : 'text-muted-foreground hover:text-foreground'
              )}
            >
              <Icon className={cn('h-5 w-5', isActive && 'fill-primary')} />
              <span className="text-xs mt-1">{t(item.labelKey)}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
