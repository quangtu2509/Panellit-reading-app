const axiosClient = require('../utils/axios-client');
require('dotenv').config();

const API_BASE = process.env.OTRUYEN_API_BASE;
const CDN_BASE = process.env.OTRUYEN_CDN_BASE;
const CHAPTER_API = process.env.OTRUYEN_CHAPTER_API;

class OTruyenService {
  /**
   * Fetch manga metadata by slug
   * API: https://otruyenapi.com/v1/api/truyen-tranh/{slug}
   */
  async getMangaMetadata(slug) {
    try {
      const response = await axiosClient.get(`${API_BASE}/truyen-tranh/${slug}`);
      const data = response.data;

      if (data.status !== 'success') {
        throw new Error('Failed to fetch manga from OTruyen');
      }

      const item = data.data.item;
      return {
        title: item.name,
        slug: item.slug,
        cover: `${CDN_BASE}/${item.thumb_url}`,
        author: item.author,
        status: item.status,
        summary: item.content,
        categories: (item.category || []).map((c) => c.name),
        chapters: item.chapters[0]?.server_data || [],
      };
    } catch (error) {
      console.error(`OTruyenService [getMangaMetadata] Error:`, error.message);
      throw error;
    }
  }

  /**
   * Search manga by keyword
   * API: https://otruyenapi.com/v1/api/tim-kiem?keyword={keyword}&page=1
   */
  async searchManga(keyword, page = 1) {
    try {
      const response = await axiosClient.get(`${API_BASE}/tim-kiem`, {
        params: { keyword, page },
      });
      const data = response.data;

      if (data.status !== 'success') {
        throw new Error('OTruyen search failed');
      }

      const items = data.data.items || [];
      return {
        totalItems: data.data.params?.pagination?.totalItems || items.length,
        currentPage: page,
        items: items.map((item) => ({
          title: item.name,
          slug: item.slug,
          cover: `${CDN_BASE}/${item.thumb_url}`,
          status: item.status,
          categories: (item.category || []).map((c) => c.name),
          chaptersLatest: (item.chaptersLatest || []).map((c) => ({
            chapterName: c.chapter_name,
          })),
        })),
      };
    } catch (error) {
      console.error(`OTruyenService [searchManga] Error:`, error.message);
      throw error;
    }
  }

  /**
   * Fetch home feed: newly updated manga list
   * API: https://otruyenapi.com/v1/api/danh-sach/truyen-moi?page=1
   */
  async getHomeFeed(page = 1) {
    try {
      const response = await axiosClient.get(`${API_BASE}/danh-sach/truyen-moi?page=${page}`);
      const data = response.data;

      if (data.status !== 'success') {
        throw new Error('Failed to fetch home feed from OTruyen');
      }

      const items = data.data.items || [];
      return items.map((item) => ({
        title: item.name,
        slug: item.slug,
        cover: `${CDN_BASE}/${item.thumb_url}`,
        status: item.status,
        categories: (item.category || []).map((c) => c.name),
        updatedAt: item.updatedAt || '',
        chaptersLatest: (item.chaptersLatest || []).map((c) => ({
          chapterName: c.chapter_name,
          chapterApiData: c.chapter_api_data || '',
        })),
      }));
    } catch (error) {
      console.error(`OTruyenService [getHomeFeed] Error:`, error.message);
      throw error;
    }
  }

  /**
   * Fetch manga list by category/genre slug
   * API: https://otruyenapi.com/v1/api/the-loai/{slug}?page=1
   */
  async getCategoryManga(slug, page = 1) {
    try {
      const response = await axiosClient.get(`${API_BASE}/the-loai/${slug}`, {
        params: { page },
      });
      const data = response.data;

      if (data.status !== 'success') {
        throw new Error(`OTruyen category fetch failed for slug: ${slug}`);
      }

      const items = data.data.items || [];
      const pagination = data.data.params?.pagination || {};
      return {
        categoryName: data.data.seoOnPage?.titleHead || slug,
        totalItems: pagination.totalItems || items.length,
        currentPage: page,
        items: items.map((item) => ({
          title: item.name,
          slug: item.slug,
          cover: `${CDN_BASE}/${item.thumb_url}`,
          status: item.status,
          categories: (item.category || []).map((c) => c.name),
          chaptersLatest: (item.chaptersLatest || []).map((c) => ({
            chapterName: c.chapter_name,
            chapterApiData: c.chapter_api_data || '',
          })),
        })),
      };
    } catch (error) {
      console.error(`OTruyenService [getCategoryManga] Error:`, error.message);
      throw error;
    }
  }

  /**
   * Fetch chapter image paths and map them to absolute URLs
   * API: https://sv1.otruyencdn.com/v1/api/chapter/{chapterId}
   */
  async getChapterImages(chapterId) {
    try {
      const response = await axiosClient.get(`${CHAPTER_API}/${chapterId}`);
      const data = response.data;

      if (data.status !== 'success') {
        throw new Error('Failed to fetch chapter images from OTruyen');
      }

      const { chapter_path, chapter_image } = data.data.item;
      const domain_cdn = data.data.domain_cdn;

      // Map relative paths to absolute URLs using the dynamic CDN domain and path
      const images = chapter_image.map((img) => `${domain_cdn}/${chapter_path}/${img.image_file}`);

      return {
        chapterId,
        images,
      };
    } catch (error) {
      console.error(`OTruyenService [getChapterImages] Error:`, error.message);
      throw error;
    }
  }
}

module.exports = new OTruyenService();
