import { supabase, PatternImage, PatternFile, MultilingualText } from './supabase';

const BUCKET_NAME = 'pattern-assets';

export type FileType = 'pdf' | 'zip' | 'svg' | 'dxf' | 'ai' | 'video' | 'image' | 'other';

export interface UploadResult {
  success: boolean;
  data?: {
    path: string;
    publicUrl: string;
  };
  error?: string;
}

export interface ImageUploadOptions {
  categorySlug: string;
  subcategorySlug: string;
  patternSlug: string;
  file: File;
  displayOrder?: number;
  isPrimary?: boolean;
  imageType?: 'photo' | 'blueprint' | 'schematic' | 'detail' | 'finished';
  altText?: MultilingualText;
}

export interface FileUploadOptions {
  categorySlug: string;
  subcategorySlug: string;
  patternSlug: string;
  file: File;
  fileType: FileType;
  displayName?: MultilingualText;
  description?: MultilingualText;
  displayOrder?: number;
  isPrimary?: boolean;
}

class StorageService {
  private getPublicUrl(path: string): string {
    const { data } = supabase.storage.from(BUCKET_NAME).getPublicUrl(path);
    return data.publicUrl;
  }

  private generateImagePath(
    categorySlug: string,
    subcategorySlug: string,
    patternSlug: string,
    fileName: string
  ): string {
    const timestamp = Date.now();
    const sanitizedFileName = this.sanitizeFileName(fileName);
    return `${categorySlug}/${subcategorySlug}/${patternSlug}/images/${timestamp}-${sanitizedFileName}`;
  }

  private generateFilePath(
    categorySlug: string,
    subcategorySlug: string,
    patternSlug: string,
    fileName: string
  ): string {
    const timestamp = Date.now();
    const sanitizedFileName = this.sanitizeFileName(fileName);
    return `${categorySlug}/${subcategorySlug}/${patternSlug}/files/${timestamp}-${sanitizedFileName}`;
  }

  private sanitizeFileName(fileName: string): string {
    return fileName
      .toLowerCase()
      .replace(/[^a-z0-9._-]/g, '-')
      .replace(/--+/g, '-');
  }

  async uploadImage(options: ImageUploadOptions): Promise<UploadResult> {
    const {
      categorySlug,
      subcategorySlug,
      patternSlug,
      file,
    } = options;

    const path = this.generateImagePath(categorySlug, subcategorySlug, patternSlug, file.name);

    try {
      const { error: uploadError } = await supabase.storage
        .from(BUCKET_NAME)
        .upload(path, file, {
          cacheControl: '3600',
          upsert: false,
        });

      if (uploadError) {
        return { success: false, error: uploadError.message };
      }

      const publicUrl = this.getPublicUrl(path);

      return {
        success: true,
        data: { path, publicUrl },
      };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Upload failed',
      };
    }
  }

  async uploadFile(options: FileUploadOptions): Promise<UploadResult> {
    const {
      categorySlug,
      subcategorySlug,
      patternSlug,
      file,
    } = options;

    const path = this.generateFilePath(categorySlug, subcategorySlug, patternSlug, file.name);

    try {
      const { error: uploadError } = await supabase.storage
        .from(BUCKET_NAME)
        .upload(path, file, {
          cacheControl: '3600',
          upsert: false,
        });

      if (uploadError) {
        return { success: false, error: uploadError.message };
      }

      const publicUrl = this.getPublicUrl(path);

      return {
        success: true,
        data: { path, publicUrl },
      };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Upload failed',
      };
    }
  }

  async deleteFromStorage(path: string): Promise<{ success: boolean; error?: string }> {
    try {
      const { error } = await supabase.storage.from(BUCKET_NAME).remove([path]);
      if (error) {
        return { success: false, error: error.message };
      }
      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Delete failed',
      };
    }
  }

  async deletePatternImage(imageId: string, storagePath: string | null): Promise<{ success: boolean; error?: string }> {
    try {
      if (storagePath) {
        await this.deleteFromStorage(storagePath);
      }

      const { error } = await supabase
        .from('pattern_images')
        .delete()
        .eq('id', imageId);

      if (error) {
        return { success: false, error: error.message };
      }

      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Delete failed',
      };
    }
  }

  async deletePatternFile(fileId: string, storagePath: string): Promise<{ success: boolean; error?: string }> {
    try {
      await this.deleteFromStorage(storagePath);

      const { error } = await supabase
        .from('pattern_files')
        .delete()
        .eq('id', fileId);

      if (error) {
        return { success: false, error: error.message };
      }

      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Delete failed',
      };
    }
  }

  async setPrimaryImage(patternId: string, imageId: string): Promise<{ success: boolean; error?: string }> {
    try {
      const { error: clearError } = await supabase
        .from('pattern_images')
        .update({ is_primary: false })
        .eq('pattern_id', patternId);

      if (clearError) {
        return { success: false, error: clearError.message };
      }

      const { error: setError } = await supabase
        .from('pattern_images')
        .update({ is_primary: true })
        .eq('id', imageId);

      if (setError) {
        return { success: false, error: setError.message };
      }

      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Update failed',
      };
    }
  }

  async setPrimaryFile(patternId: string, fileId: string): Promise<{ success: boolean; error?: string }> {
    try {
      const { error: clearError } = await supabase
        .from('pattern_files')
        .update({ is_primary: false })
        .eq('pattern_id', patternId);

      if (clearError) {
        return { success: false, error: clearError.message };
      }

      const { error: setError } = await supabase
        .from('pattern_files')
        .update({ is_primary: true })
        .eq('id', fileId);

      if (setError) {
        return { success: false, error: setError.message };
      }

      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Update failed',
      };
    }
  }

  async insertPatternImage(
    patternId: string,
    imagePath: string,
    publicUrl: string,
    options: {
      imageType?: 'photo' | 'blueprint' | 'schematic' | 'detail' | 'finished';
      displayOrder?: number;
      isPrimary?: boolean;
      altText?: MultilingualText;
    } = {}
  ): Promise<{ data: PatternImage | null; error?: string }> {
    const {
      imageType = 'photo',
      displayOrder = 0,
      isPrimary = false,
      altText = { en: '', fr: '', ar: '' },
    } = options;

    try {
      const { data, error } = await supabase
        .from('pattern_images')
        .insert({
          pattern_id: patternId,
          image_url: publicUrl,
          storage_path: imagePath,
          image_type: imageType,
          display_order: displayOrder,
          is_primary: isPrimary,
          alt_text: altText,
          thumbnail_url: publicUrl,
        })
        .select()
        .single();

      if (error) {
        return { data: null, error: error.message };
      }

      return { data };
    } catch (err) {
      return {
        data: null,
        error: err instanceof Error ? err.message : 'Insert failed',
      };
    }
  }

  async insertPatternFile(
    patternId: string,
    filePath: string,
    publicUrl: string,
    fileName: string,
    fileType: FileType,
    options: {
      fileSize?: number;
      displayName?: MultilingualText;
      description?: MultilingualText;
      displayOrder?: number;
      isPrimary?: boolean;
    } = {}
  ): Promise<{ data: PatternFile | null; error?: string }> {
    const {
      fileSize,
      displayName = { en: fileName, fr: fileName, ar: fileName },
      description = { en: '', fr: '', ar: '' },
      displayOrder = 0,
      isPrimary = false,
    } = options;

    try {
      const { data, error } = await supabase
        .from('pattern_files')
        .insert({
          pattern_id: patternId,
          storage_path: filePath,
          public_url: publicUrl,
          file_name: fileName,
          file_type: fileType,
          file_size: fileSize,
          display_name: displayName,
          description,
          display_order: displayOrder,
          is_primary: isPrimary,
        })
        .select()
        .single();

      if (error) {
        return { data: null, error: error.message };
      }

      return { data };
    } catch (err) {
      return {
        data: null,
        error: err instanceof Error ? err.message : 'Insert failed',
      };
    }
  }

  async getPatternImages(patternId: string): Promise<{ data: PatternImage[] | null; error?: string }> {
    try {
      const { data, error } = await supabase
        .from('pattern_images')
        .select('*')
        .eq('pattern_id', patternId)
        .order('display_order', { ascending: true });

      if (error) {
        return { data: null, error: error.message };
      }

      return { data };
    } catch (err) {
      return {
        data: null,
        error: err instanceof Error ? err.message : 'Fetch failed',
      };
    }
  }

  async getPatternFiles(patternId: string): Promise<{ data: PatternFile[] | null; error?: string }> {
    try {
      const { data, error } = await supabase
        .from('pattern_files')
        .select('*')
        .eq('pattern_id', patternId)
        .order('display_order', { ascending: true });

      if (error) {
        return { data: null, error: error.message };
      }

      return { data };
    } catch (err) {
      return {
        data: null,
        error: err instanceof Error ? err.message : 'Fetch failed',
      };
    }
  }

  async getCoverImage(patternId: string): Promise<{ data: PatternImage | null; error?: string }> {
    try {
      const { data, error } = await supabase
        .from('pattern_images')
        .select('*')
        .eq('pattern_id', patternId)
        .eq('is_primary', true)
        .maybeSingle();

      if (error) {
        return { data: null, error: error.message };
      }

      if (!data) {
        const { data: firstImage, error: firstError } = await supabase
          .from('pattern_images')
          .select('*')
          .eq('pattern_id', patternId)
          .order('display_order', { ascending: true })
          .limit(1)
          .maybeSingle();

        if (firstError) {
          return { data: null, error: firstError.message };
        }

        return { data: firstImage };
      }

      return { data };
    } catch (err) {
      return {
        data: null,
        error: err instanceof Error ? err.message : 'Fetch failed',
      };
    }
  }

  async updateImageDisplayOrder(
    updates: Array<{ id: string; displayOrder: number }>
  ): Promise<{ success: boolean; error?: string }> {
    try {
      for (const update of updates) {
        const { error } = await supabase
          .from('pattern_images')
          .update({ display_order: update.displayOrder })
          .eq('id', update.id);

        if (error) {
          return { success: false, error: error.message };
        }
      }
      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Update failed',
      };
    }
  }

  getFileTypeFromMime(mimeType: string): FileType {
    const mimeMap: Record<string, FileType> = {
      'application/pdf': 'pdf',
      'application/zip': 'zip',
      'application/x-zip-compressed': 'zip',
      'image/svg+xml': 'svg',
      'application/dxf': 'dxf',
      'image/vnd.dxf': 'dxf',
      'application/postscript': 'ai',
      'video/mp4': 'video',
      'video/quicktime': 'video',
      'image/jpeg': 'image',
      'image/png': 'image',
      'image/webp': 'image',
      'image/gif': 'image',
    };

    return mimeMap[mimeType] || 'other';
  }
}

export const storageService = new StorageService();
export default storageService;
