import SwiftUI
import UIKit

class WallpaperDownloadManager {
    static let shared = WallpaperDownloadManager()
    
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // 获取缓存目录路径
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("wallpapers")
        
        // 创建缓存目录
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // 下载壁纸
    func downloadWallpaper(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // 检查内存缓存
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        // 检查磁盘缓存
        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if fileManager.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            cache.setObject(image, forKey: url.absoluteString as NSString)
            completion(.success(image))
            return
        }
        
        // 下载壁纸
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "WallpaperError", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法加载图片"])))
                return
            }
            
            // 保存到缓存
            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            try? data.write(to: fileURL)
            
            completion(.success(image))
        }.resume()
    }
    
    // 设置壁纸
    func setWallpaper(_ image: UIImage, for location: WallpaperLocation, completion: @escaping (Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            completion(NSError(domain: "WallpaperError", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法处理图片"]))
            return
        }
        
        // 保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        // 由于iOS的限制，我们无法直接设置系统壁纸
        // 这里我们可以提示用户手动设置
        completion(nil)
    }
    
    // 清理缓存
    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // 获取缓存大小
    func getCacheSize() -> Int64 {
        guard let contents = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        return contents.reduce(0) { result, url in
            guard let size = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize else {
                return result
            }
            return result + Int64(size)
        }
    }
}

// 壁纸位置枚举
enum WallpaperLocation {
    case lockScreen
    case homeScreen
    case both
}