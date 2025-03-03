import SwiftUI

// 壁纸数据模型
struct WallpaperModel: Identifiable, Codable {
    let id: String
    let title: String
    let author: String
    let description: String?
    let imageUrl: String
    let thumbnailUrl: String
    let category: String
    let tags: [String]
    let uploadDate: Date
    let downloadCount: Int
    let likeCount: Int
    var isFavorited: Bool
    
    // 自定义编码键
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case description
        case imageUrl = "image_url"
        case thumbnailUrl = "thumbnail_url"
        case category
        case tags
        case uploadDate = "upload_date"
        case downloadCount = "download_count"
        case likeCount = "like_count"
        case isFavorited = "is_favorited"
    }
}

// 壁纸状态管理
class WallpaperStore: ObservableObject {
    @Published var wallpapers: [WallpaperModel] = []
    @Published var favoriteWallpapers: [WallpaperModel] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let downloadManager = WallpaperDownloadManager.shared
    
    // 加载壁纸列表
    func loadWallpapers() {
        isLoading = true
        // TODO: 实现从API加载壁纸数据
        isLoading = false
    }
    
    // 加载收藏的壁纸
    func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: "favoriteWallpapers"),
              let favorites = try? JSONDecoder().decode([WallpaperModel].self, from: data) else {
            return
        }
        favoriteWallpapers = favorites
    }
    
    // 添加到收藏
    func addToFavorites(_ wallpaper: WallpaperModel) {
        var updatedWallpaper = wallpaper
        updatedWallpaper.isFavorited = true
        favoriteWallpapers.append(updatedWallpaper)
        saveFavorites()
    }
    
    // 从收藏中移除
    func removeFromFavorites(_ wallpaper: WallpaperModel) {
        favoriteWallpapers.removeAll { $0.id == wallpaper.id }
        saveFavorites()
    }
    
    // 保存收藏列表
    private func saveFavorites() {
        guard let data = try? JSONEncoder().encode(favoriteWallpapers) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "favoriteWallpapers")
    }
    
    // 下载壁纸
    func downloadWallpaper(_ wallpaper: WallpaperModel, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: wallpaper.imageUrl) else {
            completion(.failure(NSError(domain: "WallpaperError", code: -1, userInfo: [NSLocalizedDescriptionKey: "无效的图片URL"])))
            return
        }
        
        downloadManager.downloadWallpaper(from: url, completion: completion)
    }
}