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
        chapters: item.chapters[0]?.server_data || [],
      };
    } catch (error) {
      console.error(`OTruyenService [getMangaMetadata] Error:`, error.message);
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
