import { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, Reorder } from 'framer-motion';
import {
  Upload,
  X,
  GripVertical,
  FileText,
  FileArchive,
  Package,
  Star,
  Loader2,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Switch } from '@/components/ui/switch';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Separator } from '@/components/ui/separator';
import { supabase, Category, Instructor, MultilingualText } from '@/lib/supabase';
import { storageService, FileType } from '@/lib/storageService';
import { useLocalText } from '@/hooks/useLocalText';

interface ImageUpload {
  id: string;
  file: File | null;
  preview: string;
  storagePath?: string;
  publicUrl?: string;
  imageType: 'photo' | 'blueprint' | 'schematic' | 'detail' | 'finished';
  altText: MultilingualText;
  isCover: boolean;
  uploaded: boolean;
}

interface FileUpload {
  id: string;
  file: File;
  fileType: FileType;
  displayName: MultilingualText;
  isPrimary: boolean;
  storagePath?: string;
  publicUrl?: string;
  uploaded: boolean;
  size: number;
}

export default function AddPatternPage() {
  const navigate = useNavigate();
  const { getText, language } = useLocalText();

  // Form state
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  // Categories and instructors
  const [mainCategories, setMainCategories] = useState<Category[]>([]);
  const [subcategories, setSubcategories] = useState<Category[]>([]);
  const [instructors, setInstructors] = useState<Instructor[]>([]);

  // Pattern fields
  const [title, setTitle] = useState<MultilingualText>({ en: '', fr: '', ar: '' });
  const [description, setDescription] = useState<MultilingualText>({ en: '', fr: '', ar: '' });
  const [selectedMainCategory, setSelectedMainCategory] = useState('');
  const [selectedSubcategory, setSelectedSubcategory] = useState('');
  const [difficulty, setDifficulty] = useState<'beginner' | 'intermediate' | 'advanced' | 'professional'>('beginner');
  const [fabricRecommendations, setFabricRecommendations] = useState<MultilingualText>({ en: '', fr: '', ar: '' });
  const [estimatedTime, setEstimatedTime] = useState<number>(60);
  const [sizes, setSizes] = useState<string[]>([]);
  const [tags, setTags] = useState<string[]>([]);
  const [newTag, setNewTag] = useState('');
  const [selectedInstructor, setSelectedInstructor] = useState('');
  const [isFeatured, setIsFeatured] = useState(false);
  const [isPublished, setIsPublished] = useState(true);
  const [slug, setSlug] = useState('');

  // Uploads state
  const [images, setImages] = useState<ImageUpload[]>([]);
  const [files, setFiles] = useState<FileUpload[]>([]);

  useEffect(() => {
    fetchData();
  }, []);

  useEffect(() => {
    if (selectedMainCategory) {
      fetchSubcategories(selectedMainCategory);
    } else {
      setSubcategories([]);
      setSelectedSubcategory('');
    }
  }, [selectedMainCategory]);

  useEffect(() => {
    const enTitle = title.en.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/-+/g, '-').replace(/^-|-$/g, '');
    setSlug(enTitle || '');
  }, [title.en]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [categoriesRes, instructorsRes] = await Promise.all([
        supabase.from('categories').select('*').is('parent_id', null).eq('is_active', true).order('display_order'),
        supabase.from('instructors').select('*'),
      ]);

      if (categoriesRes.data) setMainCategories(categoriesRes.data);
      if (instructorsRes.data) setInstructors(instructorsRes.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchSubcategories = async (parentId: string) => {
    const { data } = await supabase
      .from('categories')
      .select('*')
      .eq('parent_id', parentId)
      .eq('is_active', true)
      .order('display_order');

    if (data) setSubcategories(data);
  };

  const handleImageDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    const droppedFiles = Array.from(e.dataTransfer.files).filter(f => f.type.startsWith('image/'));
    addImages(droppedFiles);
  }, []);

  const handleImageSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      const selectedFiles = Array.from(e.target.files);
      addImages(selectedFiles);
    }
  };

  const addImages = (files: File[]) => {
    const newImages: ImageUpload[] = files.map((file, index) => ({
      id: `${Date.now()}-${index}`,
      file,
      preview: URL.createObjectURL(file),
      imageType: 'photo' as const,
      altText: { en: '', fr: '', ar: '' },
      isCover: images.length === 0 && index === 0,
      uploaded: false,
    }));

    setImages(prev => [...prev, ...newImages]);
  };

  const removeImage = (id: string) => {
    setImages(prev => {
      const img = prev.find(i => i.id === id);
      if (img?.preview) URL.revokeObjectURL(img.preview);
      const filtered = prev.filter(i => i.id !== id);
      if (img?.isCover && filtered.length > 0) {
        filtered[0].isCover = true;
      }
      return filtered;
    });
  };

  const setCoverImage = (id: string) => {
    setImages(prev => prev.map(img => ({ ...img, isCover: img.id === id })));
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      const selectedFiles = Array.from(e.target.files);
      addFiles(selectedFiles);
    }
  };

  const addFiles = (newFiles: File[]) => {
    const newFileUploads: FileUpload[] = newFiles.map((file, index) => ({
      id: `${Date.now()}-${index}`,
      file,
      fileType: storageService.getFileTypeFromMime(file.type),
      displayName: { en: file.name, fr: file.name, ar: file.name },
      isPrimary: files.length === 0 && index === 0,
      uploaded: false,
      size: file.size,
    }));

    setFiles(prev => [...prev, ...newFileUploads]);
  };

  const removeFile = (id: string) => {
    setFiles(prev => {
      const f = prev.find(file => file.id === id);
      const filtered = prev.filter(file => file.id !== id);
      if (f?.isPrimary && filtered.length > 0) {
        filtered[0].isPrimary = true;
      }
      return filtered;
    });
  };

  const setPrimaryFile = (id: string) => {
    setFiles(prev => prev.map(f => ({ ...f, isPrimary: f.id === id })));
  };

  const getFileIcon = (fileType: FileType) => {
    switch (fileType) {
      case 'pdf':
        return <FileText className="h-4 w-4" />;
      case 'zip':
        return <FileArchive className="h-4 w-4" />;
      case 'svg':
      case 'dxf':
      case 'ai':
        return <Package className="h-4 w-4" />;
      default:
        return <FileText className="h-4 w-4" />;
    }
  };

  const addSize = (size: string) => {
    if (size && !sizes.includes(size)) {
      setSizes(prev => [...prev, size]);
    }
  };

  const removeSize = (size: string) => {
    setSizes(prev => prev.filter(s => s !== size));
  };

  const addTag = () => {
    if (newTag && !tags.includes(newTag)) {
      setTags(prev => [...prev, newTag]);
      setNewTag('');
    }
  };

  const removeTag = (tag: string) => {
    setTags(prev => prev.filter(t => t !== tag));
  };

  const uploadAllFiles = async () => {
    const mainCat = mainCategories.find(c => c.id === selectedMainCategory);
    const subCat = subcategories.find(c => c.id === selectedSubcategory);

    if (!mainCat || !subCat) {
      throw new Error('Please select category and subcategory');
    }

    // Upload images
    for (let i = 0; i < images.length; i++) {
      const img = images[i];
      if (img.file && !img.uploaded) {
        const result = await storageService.uploadImage({
          categorySlug: mainCat.slug,
          subcategorySlug: subCat.slug,
          patternSlug: slug,
          file: img.file,
          isPrimary: img.isCover,
          imageType: img.imageType,
          displayOrder: i,
        });

        if (!result.success || !result.data) {
          throw new Error(`Failed to upload image: ${result.error}`);
        }

        img.storagePath = result.data.path;
        img.publicUrl = result.data.publicUrl;
        img.uploaded = true;
        setImages([...images]);
      }
    }

    // Upload files
    for (let i = 0; i < files.length; i++) {
      const f = files[i];
      if (!f.uploaded) {
        const result = await storageService.uploadFile({
          categorySlug: mainCat.slug,
          subcategorySlug: subCat.slug,
          patternSlug: slug,
          file: f.file,
          fileType: f.fileType,
          displayName: f.displayName,
          displayOrder: i,
          isPrimary: f.isPrimary,
        });

        if (!result.success || !result.data) {
          throw new Error(`Failed to upload file: ${result.error}`);
        }

        f.storagePath = result.data.path;
        f.publicUrl = result.data.publicUrl;
        f.uploaded = true;
        setFiles([...files]);
      }
    }
  };

  const handleSubmit = async () => {
    if (!slug) {
      alert('Please enter a title to generate a slug');
      return;
    }

    if (!selectedSubcategory) {
      alert('Please select a subcategory');
      return;
    }

    setSaving(true);
    try {
      // Upload all files to storage
      await uploadAllFiles();

      // Check for existing pattern slug
      const { data: existingPattern } = await supabase
        .from('patterns')
        .select('id')
        .eq('slug', slug)
        .maybeSingle();

      const finalSlug = existingPattern
        ? `${slug}-${Date.now()}`
        : slug;

      // Insert pattern record
      const { data: patternData, error: patternError } = await supabase
        .from('patterns')
        .insert({
          slug: finalSlug,
          title,
          description,
          category_id: selectedSubcategory,
          difficulty,
          fabric_recommendations: fabricRecommendations,
          estimated_time_minutes: estimatedTime,
          sizes,
          tags,
          instructor_id: selectedInstructor || null,
          is_featured: isFeatured,
          is_published: isPublished,
          published_at: isPublished ? new Date().toISOString() : null,
        })
        .select()
        .single();

      if (patternError || !patternData) {
        throw new Error(`Failed to create pattern: ${patternError?.message}`);
      }

      // Insert pattern_images records
      for (let i = 0; i < images.length; i++) {
        const img = images[i];
        if (img.storagePath && img.publicUrl) {
          await supabase.from('pattern_images').insert({
            pattern_id: patternData.id,
            image_url: img.publicUrl,
            storage_path: img.storagePath,
            image_type: img.imageType,
            is_primary: img.isCover,
            display_order: i,
            alt_text: img.altText,
          });
        }
      }

      // Insert pattern_files records
      for (let i = 0; i < files.length; i++) {
        const f = files[i];
        if (f.storagePath && f.publicUrl) {
          await supabase.from('pattern_files').insert({
            pattern_id: patternData.id,
            storage_path: f.storagePath,
            public_url: f.publicUrl,
            file_name: f.file.name,
            file_type: f.fileType,
            file_size: f.size,
            display_name: f.displayName,
            display_order: i,
            is_primary: f.isPrimary,
          });
        }
      }

      alert(`Pattern created successfully! Slug: ${finalSlug}`);
      navigate('/categories');
    } catch (error) {
      console.error('Error saving pattern:', error);
      alert(`Error: ${error instanceof Error ? error.message : 'Failed to save pattern'}`);
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <Loader2 className="h-8 w-8 animate-spin" />
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <h1 className="text-3xl font-bold mb-2">
          {language === 'ar' ? 'إضافة نمط جديد' : language === 'fr' ? 'Ajouter un patron' : 'Add New Pattern'}
        </h1>
        <p className="text-muted-foreground mb-8">
          {language === 'ar' ? 'أنشئ نمط خياطة جديد مع صور وملفات للتحميل' : language === 'fr' ? 'Créez un nouveau patron avec des images et fichiers' : 'Create a new sewing pattern with images and files'}
        </p>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Main Form */}
          <div className="lg:col-span-2 space-y-6">
            {/* Title */}
            <Card>
              <CardContent className="p-6">
                <Label className="text-base font-semibold">
                  {language === 'ar' ? 'العنوان' : language === 'fr' ? 'Titre' : 'Title'}
                </Label>
                <Tabs defaultValue="en" className="mt-3">
                  <TabsList className="w-full">
                    <TabsTrigger value="en" className="flex-1">English</TabsTrigger>
                    <TabsTrigger value="fr" className="flex-1">Français</TabsTrigger>
                    <TabsTrigger value="ar" className="flex-1">العربية</TabsTrigger>
                  </TabsList>
                  <TabsContent value="en">
                    <Input
                      value={title.en}
                      onChange={(e) => setTitle({ ...title, en: e.target.value })}
                      placeholder="Pattern title in English"
                      className="mt-2"
                    />
                  </TabsContent>
                  <TabsContent value="fr">
                    <Input
                      value={title.fr}
                      onChange={(e) => setTitle({ ...title, fr: e.target.value })}
                      placeholder="Titre du patron en français"
                      className="mt-2"
                    />
                  </TabsContent>
                  <TabsContent value="ar">
                    <Input
                      value={title.ar}
                      onChange={(e) => setTitle({ ...title, ar: e.target.value })}
                      placeholder="عنوان النمط بالعربية"
                      className="mt-2"
                      dir="rtl"
                    />
                  </TabsContent>
                </Tabs>

                <div className="mt-4">
                  <Label className="text-sm">Slug</Label>
                  <Input value={slug} onChange={(e) => setSlug(e.target.value)} className="mt-1" />
                </div>
              </CardContent>
            </Card>

            {/* Description */}
            <Card>
              <CardContent className="p-6">
                <Label className="text-base font-semibold">
                  {language === 'ar' ? 'الوصف' : language === 'fr' ? 'Description' : 'Description'}
                </Label>
                <Tabs defaultValue="en" className="mt-3">
                  <TabsList className="w-full">
                    <TabsTrigger value="en" className="flex-1">English</TabsTrigger>
                    <TabsTrigger value="fr" className="flex-1">Français</TabsTrigger>
                    <TabsTrigger value="ar" className="flex-1">العربية</TabsTrigger>
                  </TabsList>
                  <TabsContent value="en">
                    <Textarea
                      value={description.en}
                      onChange={(e) => setDescription({ ...description, en: e.target.value })}
                      placeholder="Describe the pattern in English"
                      className="mt-2 min-h-[120px]"
                    />
                  </TabsContent>
                  <TabsContent value="fr">
                    <Textarea
                      value={description.fr}
                      onChange={(e) => setDescription({ ...description, fr: e.target.value })}
                      placeholder="Décrivez le patron en français"
                      className="mt-2 min-h-[120px]"
                    />
                  </TabsContent>
                  <TabsContent value="ar">
                    <Textarea
                      value={description.ar}
                      onChange={(e) => setDescription({ ...description, ar: e.target.value })}
                      placeholder="وصف النمط بالعربية"
                      className="mt-2 min-h-[120px]"
                      dir="rtl"
                    />
                  </TabsContent>
                </Tabs>
              </CardContent>
            </Card>

            {/* Images */}
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between mb-4">
                  <Label className="text-base font-semibold">
                    {language === 'ar' ? 'الصور' : language === 'fr' ? 'Images' : 'Images'}
                  </Label>
                  <Label className="flex items-center gap-2">
                    <Star className="h-4 w-4 text-primary" />
                    <span className="text-sm text-muted-foreground">Drag to reorder</span>
                  </Label>
                </div>

                {/* Drop zone */}
                <div
                  onDragOver={(e) => e.preventDefault()}
                  onDrop={handleImageDrop}
                  className="border-2 border-dashed rounded-xl p-12 text-center hover:border-primary/50 transition-colors cursor-pointer"
                >
                  <Input
                    type="file"
                    accept="image/*"
                    multiple
                    onChange={handleImageSelect}
                    className="hidden"
                    id="image-upload"
                  />
                  <label htmlFor="image-upload" className="cursor-pointer">
                    <Upload className="h-10 w-10 mx-auto mb-3 text-muted-foreground" />
                    <p className="text-muted-foreground">
                      {language === 'ar' ? 'اسحب الصور هنا أو انقر للاختيار' : language === 'fr' ? 'Glissez les images ou cliquez pour sélectionner' : 'Drag images here or click to select'}
                    </p>
                  </label>
                </div>

                {/* Image list with reordering */}
                {images.length > 0 && (
                  <Reorder.Group
                    axis="y"
                    values={images}
                    onReorder={setImages}
                    className="mt-4 space-y-2"
                  >
                    {images.map((img) => (
                      <Reorder.Item
                        key={img.id}
                        value={img}
                        className="flex items-center gap-3 p-3 bg-muted/50 rounded-lg cursor-grab active:cursor-grabbing"
                      >
                        <GripVertical className="h-5 w-5 text-muted-foreground" />
                        <img
                          src={img.preview}
                          alt=""
                          className="h-16 w-16 object-cover rounded-md"
                        />
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2">
                            {img.isCover && (
                              <Badge className="bg-primary">
                                <Star className="h-3 w-3 mr-1 fill-current" />
                                Cover
                              </Badge>
                            )}
                            <Select
                              value={img.imageType}
                              onValueChange={(v) => setImages(images.map(i =>
                                i.id === img.id ? { ...i, imageType: v as ImageUpload['imageType'] } : i
                              ))}
                            >
                              <SelectTrigger className="w-[130px]">
                                <SelectValue />
                              </SelectTrigger>
                              <SelectContent>
                                <SelectItem value="photo">Photo</SelectItem>
                                <SelectItem value="blueprint">Blueprint</SelectItem>
                                <SelectItem value="schematic">Schematic</SelectItem>
                                <SelectItem value="detail">Detail</SelectItem>
                                <SelectItem value="finished">Finished</SelectItem>
                              </SelectContent>
                            </Select>
                          </div>
                        </div>
                        {!img.isCover && (
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => setCoverImage(img.id)}
                          >
                            <Star className="h-4 w-4" />
                          </Button>
                        )}
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => removeImage(img.id)}
                        >
                          <X className="h-4 w-4" />
                        </Button>
                      </Reorder.Item>
                    ))}
                  </Reorder.Group>
                )}
              </CardContent>
            </Card>

            {/* Files */}
            <Card>
              <CardContent className="p-6">
                <Label className="text-base font-semibold">
                  {language === 'ar' ? 'الملفات' : language === 'fr' ? 'Fichiers' : 'Downloadable Files'}
                </Label>

                <div className="mt-4">
                  <Input
                    type="file"
                    accept=".pdf,.zip,.svg,.dxf,.ai,.png,.jpg,.jpeg"
                    multiple
                    onChange={handleFileSelect}
                    className="hidden"
                    id="file-upload"
                  />
                  <Button variant="outline" asChild>
                    <label htmlFor="file-upload" className="cursor-pointer">
                      <Upload className="h-4 w-4 mr-2" />
                      {language === 'ar' ? 'إضافة ملفات' : language === 'fr' ? 'Ajouter des fichiers' : 'Add Files'}
                    </label>
                  </Button>
                </div>

                {files.length > 0 && (
                  <div className="mt-4 space-y-2">
                    {files.map((f) => (
                      <div
                        key={f.id}
                        className="flex items-center gap-3 p-3 bg-muted/50 rounded-lg"
                      >
                        <div className="flex items-center justify-center w-10 h-10 rounded-md bg-primary/10 text-primary">
                          {getFileIcon(f.fileType)}
                        </div>
                        <div className="flex-1 min-w-0">
                          <p className="font-medium truncate">{f.file.name}</p>
                          <p className="text-xs text-muted-foreground">
                            {(f.size / 1024 / 1024).toFixed(2)} MB
                          </p>
                        </div>
                        {f.isPrimary && (
                          <Badge className="bg-primary">Primary</Badge>
                        )}
                        {!f.isPrimary && (
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => setPrimaryFile(f.id)}
                          >
                            <Star className="h-4 w-4" />
                          </Button>
                        )}
                        <Badge variant="outline" className="uppercase">{f.fileType}</Badge>
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => removeFile(f.id)}
                        >
                          <X className="h-4 w-4" />
                        </Button>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Category & Settings */}
            <Card>
              <CardContent className="p-6 space-y-4">
                <h3 className="font-semibold">
                  {language === 'ar' ? 'الإعدادات' : language === 'fr' ? 'Paramètres' : 'Settings'}
                </h3>

                <div>
                  <Label>Main Category</Label>
                  <Select value={selectedMainCategory} onValueChange={setSelectedMainCategory}>
                    <SelectTrigger className="mt-1">
                      <SelectValue placeholder="Select category" />
                    </SelectTrigger>
                    <SelectContent>
                      {mainCategories.map((cat) => (
                        <SelectItem key={cat.id} value={cat.id}>
                          {getText(cat.name)}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div>
                  <Label>Subcategory</Label>
                  <Select
                    value={selectedSubcategory}
                    onValueChange={setSelectedSubcategory}
                    disabled={!selectedMainCategory}
                  >
                    <SelectTrigger className="mt-1">
                      <SelectValue placeholder="Select subcategory" />
                    </SelectTrigger>
                    <SelectContent>
                      {subcategories.map((cat) => (
                        <SelectItem key={cat.id} value={cat.id}>
                          {getText(cat.name)}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div>
                  <Label>Difficulty</Label>
                  <Select value={difficulty} onValueChange={(v) => setDifficulty(v as typeof difficulty)}>
                    <SelectTrigger className="mt-1">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="beginner">Beginner</SelectItem>
                      <SelectItem value="intermediate">Intermediate</SelectItem>
                      <SelectItem value="advanced">Advanced</SelectItem>
                      <SelectItem value="professional">Professional</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div>
                  <Label>Instructor (optional)</Label>
                  <Select value={selectedInstructor} onValueChange={setSelectedInstructor}>
                    <SelectTrigger className="mt-1">
                      <SelectValue placeholder="Select instructor" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="">None</SelectItem>
                      {instructors.map((inst) => (
                        <SelectItem key={inst.id} value={inst.id}>
                          {getText(inst.name)}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div>
                  <Label>Estimated Time (minutes)</Label>
                  <Input
                    type="number"
                    value={estimatedTime}
                    onChange={(e) => setEstimatedTime(parseInt(e.target.value) || 0)}
                    className="mt-1"
                  />
                </div>

                <div className="flex items-center justify-between">
                  <Label>Featured</Label>
                  <Switch checked={isFeatured} onCheckedChange={setIsFeatured} />
                </div>

                <div className="flex items-center justify-between">
                  <Label>Published</Label>
                  <Switch checked={isPublished} onCheckedChange={setIsPublished} />
                </div>
              </CardContent>
            </Card>

            {/* Sizes */}
            <Card>
              <CardContent className="p-6">
                <Label className="font-semibold">Sizes</Label>
                <div className="flex gap-2 mt-2">
                  <Input
                    placeholder="XS, S, M, L..."
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') {
                        addSize((e.target as HTMLInputElement).value);
                        (e.target as HTMLInputElement).value = '';
                      }
                    }}
                  />
                </div>
                <div className="flex flex-wrap gap-2 mt-3">
                  {sizes.map((size) => (
                    <Badge key={size} variant="secondary" className="cursor-pointer" onClick={() => removeSize(size)}>
                      {size} <X className="h-3 w-3 ml-1" />
                    </Badge>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Tags */}
            <Card>
              <CardContent className="p-6">
                <Label className="font-semibold">Tags</Label>
                <div className="flex gap-2 mt-2">
                  <Input
                    value={newTag}
                    onChange={(e) => setNewTag(e.target.value)}
                    placeholder="Add tag..."
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') {
                        e.preventDefault();
                        addTag();
                      }
                    }}
                  />
                  <Button onClick={addTag} size="icon">
                    <X className="h-4 w-4 rotate-45" />
                  </Button>
                </div>
                <div className="flex flex-wrap gap-2 mt-3">
                  {tags.map((tag) => (
                    <Badge key={tag} variant="secondary" className="cursor-pointer" onClick={() => removeTag(tag)}>
                      {tag} <X className="h-3 w-3 ml-1" />
                    </Badge>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Fabric Recommendations */}
            <Card>
              <CardContent className="p-6">
                <Label className="font-semibold">Fabric Recommendations</Label>
                <Tabs defaultValue="en" className="mt-3">
                  <TabsList className="w-full">
                    <TabsTrigger value="en" className="flex-1">EN</TabsTrigger>
                    <TabsTrigger value="fr" className="flex-1">FR</TabsTrigger>
                    <TabsTrigger value="ar" className="flex-1">AR</TabsTrigger>
                  </TabsList>
                  <TabsContent value="en">
                    <Textarea
                      value={fabricRecommendations.en}
                      onChange={(e) => setFabricRecommendations({ ...fabricRecommendations, en: e.target.value })}
                      className="mt-2"
                    />
                  </TabsContent>
                  <TabsContent value="fr">
                    <Textarea
                      value={fabricRecommendations.fr}
                      onChange={(e) => setFabricRecommendations({ ...fabricRecommendations, fr: e.target.value })}
                      className="mt-2"
                    />
                  </TabsContent>
                  <TabsContent value="ar">
                    <Textarea
                      value={fabricRecommendations.ar}
                      onChange={(e) => setFabricRecommendations({ ...fabricRecommendations, ar: e.target.value })}
                      className="mt-2"
                      dir="rtl"
                    />
                  </TabsContent>
                </Tabs>
              </CardContent>
            </Card>

            <Separator />

            {/* Submit Button */}
            <Button
              className="w-full"
              size="lg"
              onClick={handleSubmit}
              disabled={saving || !title.en || !selectedSubcategory}
            >
              {saving ? (
                <>
                  <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                  {language === 'ar' ? 'جاري الحفظ...' : language === 'fr' ? 'Enregistrement...' : 'Saving...'}
                </>
              ) : (
                <>
                  <Upload className="h-4 w-4 mr-2" />
                  {language === 'ar' ? 'إنشاء النمط' : language === 'fr' ? 'Créer le patron' : 'Create Pattern'}
                </>
              )}
            </Button>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
