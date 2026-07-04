import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { User, Settings, Award, BookOpen, Heart, Download } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Card, CardContent } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { useAuth } from '@/contexts/AuthContext';
import { useLocalText } from '@/hooks/useLocalText';

export default function ProfilePage() {
  const { t } = useTranslation();
  const { user, profile, signOut } = useAuth();
  const { language } = useLocalText();

  if (!user) {
    return (
      <div className="container mx-auto px-4 py-8 text-center">
        <User className="h-16 w-16 mx-auto mb-4 text-muted" />
        <h1 className="text-2xl font-bold mb-4">
          {language === 'ar' ? 'سجل الدخول للاطلاع على ملفك الشخصي' : language === 'fr' ? 'Connectez-vous pour voir votre profil' : 'Sign in to view your profile'}
        </h1>
        <Button asChild>
          <Link to="/login">{t('nav.signIn')}</Link>
        </Button>
      </div>
    );
  }

  const stats = [
    { icon: Heart, value: 12, label: language === 'ar' ? 'مفضلة' : language === 'fr' ? 'Favoris' : 'Favorites' },
    { icon: Download, value: 34, label: language === 'ar' ? 'تحميل' : language === 'fr' ? 'Téléchargements' : 'Downloads' },
    { icon: BookOpen, value: 3, label: language === 'ar' ? 'دورة' : language === 'fr' ? 'Cours' : 'Courses' },
    { icon: Award, value: 2, label: language === 'ar' ? 'شهادة' : language === 'fr' ? 'Certificats' : 'Certificates' },
  ];

  return (
    <div className="container mx-auto px-4 py-8">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
      >
        {/* Profile Header */}
        <Card className="mb-8">
          <CardContent className="p-6">
            <div className="flex flex-col md:flex-row items-center gap-6">
              <Avatar className="h-24 w-24">
                <AvatarImage src={profile?.avatar_url || ''} />
                <AvatarFallback className="text-2xl">
                  {profile?.name?.charAt(0) || user.email?.charAt(0).toUpperCase()}
                </AvatarFallback>
              </Avatar>

              <div className="flex-1 text-center md:text-left">
                <h1 className="text-2xl font-bold">{profile?.name || 'User'}</h1>
                <p className="text-muted-foreground">{user.email}</p>
                <div className="flex flex-wrap gap-2 mt-2 justify-center md:justify-start">
                  {profile?.role === 'admin' && <Badge variant="secondary">Admin</Badge>}
                  {profile?.role === 'instructor' && <Badge variant="secondary">Instructor</Badge>}
                </div>
              </div>

              <div className="flex gap-2">
                <Button variant="outline" asChild>
                  <Link to="/settings">
                    <Settings className="h-4 w-4 mr-2" />
                    {t('nav.settings')}
                  </Link>
                </Button>
                <Button variant="destructive" onClick={signOut}>
                  {t('nav.signOut')}
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          {stats.map((stat, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: index * 0.05 }}
            >
              <Card>
                <CardContent className="p-4 text-center">
                  <stat.icon className="h-6 w-6 mx-auto mb-2 text-primary" />
                  <div className="text-2xl font-bold">{stat.value}</div>
                  <div className="text-sm text-muted-foreground">{stat.label}</div>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>

        {/* Tabs */}
        <Tabs defaultValue="courses">
          <TabsList className="w-full justify-start overflow-x-auto scrollbar-hide">
            <TabsTrigger value="courses">
              {language === 'ar' ? 'دوراتي' : language === 'fr' ? 'Mes cours' : 'My Courses'}
            </TabsTrigger>
            <TabsTrigger value="favorites">
              {language === 'ar' ? 'المفضلة' : language === 'fr' ? 'Favoris' : 'Favorites'}
            </TabsTrigger>
            <TabsTrigger value="downloads">
              {language === 'ar' ? 'التحميلات' : language === 'fr' ? 'Téléchargements' : 'Downloads'}
            </TabsTrigger>
            <TabsTrigger value="certificates">
              {language === 'ar' ? 'الشهادات' : language === 'fr' ? 'Certificats' : 'Certificates'}
            </TabsTrigger>
          </TabsList>

          <TabsContent value="courses" className="pt-6">
            <div className="text-center py-12">
              <BookOpen className="h-12 w-12 mx-auto mb-4 text-muted" />
              <p className="text-muted-foreground">
                {language === 'ar' ? 'لم تسجل في أي دورة بعد' : language === 'fr' ? 'Aucun cours en cours' : 'No courses enrolled yet'}
              </p>
              <Button className="mt-4" asChild>
                <Link to="/courses">{language === 'ar' ? 'تصفح الدورات' : language === 'fr' ? 'Parcourir les cours' : 'Browse Courses'}</Link>
              </Button>
            </div>
          </TabsContent>

          <TabsContent value="favorites" className="pt-6">
            <div className="text-center py-12">
              <Heart className="h-12 w-12 mx-auto mb-4 text-muted" />
              <p className="text-muted-foreground">
                {language === 'ar' ? 'لا توجد مفضلات' : language === 'fr' ? 'Pas de favoris' : 'No favorites yet'}
              </p>
              <Button className="mt-4" asChild>
                <Link to="/categories">{language === 'ar' ? 'تصفح الأنماط' : language === 'fr' ? 'Parcourir les patrons' : 'Browse Patterns'}</Link>
              </Button>
            </div>
          </TabsContent>

          <TabsContent value="downloads" className="pt-6">
            <div className="text-center py-12">
              <Download className="h-12 w-12 mx-auto mb-4 text-muted" />
              <p className="text-muted-foreground">
                {language === 'ar' ? 'لا توجد تحميلات' : language === 'fr' ? 'Aucun téléchargement' : 'No downloads yet'}
              </p>
            </div>
          </TabsContent>

          <TabsContent value="certificates" className="pt-6">
            <div className="text-center py-12">
              <Award className="h-12 w-12 mx-auto mb-4 text-muted" />
              <p className="text-muted-foreground">
                {language === 'ar' ? 'لا توجد شهادات' : language === 'fr' ? 'Aucun certificat' : 'No certificates yet'}
              </p>
            </div>
          </TabsContent>
        </Tabs>
      </motion.div>
    </div>
  );
}
