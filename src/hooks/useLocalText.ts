import { useTranslation } from 'react-i18next';
import { MultilingualText } from '@/lib/supabase';

export function useLocalText() {
  const { i18n } = useTranslation();
  const language = i18n.language as 'en' | 'fr' | 'ar';

  const getText = (text: MultilingualText | string | undefined | null): string => {
    if (!text) return '';
    if (typeof text === 'string') return text;
    return text[language] || text.en || '';
  };

  return { getText, language };
}
