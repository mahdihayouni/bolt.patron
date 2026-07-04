import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Suspense, lazy } from 'react';
import { ThemeProvider } from '@/components/layout/ThemeProvider';
import { LanguageProvider } from '@/contexts/LanguageContext';
import { AuthProvider } from '@/contexts/AuthContext';
import { Header } from '@/components/layout/Header';
import { BottomNav } from '@/components/layout/BottomNav';
import { Toaster } from '@/components/ui/sonner';
import '@/i18n';

// Lazy load pages for better performance
const HomePage = lazy(() => import('@/pages/HomePage'));
const CategoriesPage = lazy(() => import('@/pages/CategoriesPage'));
const CategoryPage = lazy(() => import('@/pages/CategoryPage'));
const PatternPage = lazy(() => import('@/pages/PatternPage'));
const CoursesPage = lazy(() => import('@/pages/CoursesPage'));
const CoursePage = lazy(() => import('@/pages/CoursePage'));
const LessonPage = lazy(() => import('@/pages/LessonPage'));
const FavoritesPage = lazy(() => import('@/pages/FavoritesPage'));
const ProfilePage = lazy(() => import('@/pages/ProfilePage'));
const LoginPage = lazy(() => import('@/pages/auth/LoginPage'));
const RegisterPage = lazy(() => import('@/pages/auth/RegisterPage'));
const SearchPage = lazy(() => import('@/pages/SearchPage'));

function LoadingSpinner() {
  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
    </div>
  );
}

function App() {
  return (
    <ThemeProvider>
      <LanguageProvider>
        <BrowserRouter>
          <AuthProvider>
            <div className="min-h-screen bg-background text-foreground">
              <Header />
              <main className="pb-20 md:pb-0">
                <Suspense fallback={<LoadingSpinner />}>
                  <Routes>
                    <Route path="/" element={<HomePage />} />
                    <Route path="/categories" element={<CategoriesPage />} />
                    <Route path="/category/:slug" element={<CategoryPage />} />
                    <Route path="/pattern/:slug" element={<PatternPage />} />
                    <Route path="/courses" element={<CoursesPage />} />
                    <Route path="/course/:slug" element={<CoursePage />} />
                    <Route path="/lesson/:id" element={<LessonPage />} />
                    <Route path="/favorites" element={<FavoritesPage />} />
                    <Route path="/profile" element={<ProfilePage />} />
                    <Route path="/login" element={<LoginPage />} />
                    <Route path="/register" element={<RegisterPage />} />
                    <Route path="/search" element={<SearchPage />} />
                  </Routes>
                </Suspense>
              </main>
              <BottomNav />
              <Toaster />
            </div>
          </AuthProvider>
        </BrowserRouter>
      </LanguageProvider>
    </ThemeProvider>
  );
}

export default App;
