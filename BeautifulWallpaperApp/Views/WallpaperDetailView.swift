import SwiftUI

struct WallpaperDetailView: View {
    // 是否显示预览模式
    @State private var isPreviewMode = false
    // 是否已收藏
    @State private var isFavorited = false
    // 图片亮度调节
    @State private var brightness: Double = 0
    // 图片模糊度调节
    @State private var blur: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 壁纸预览区域
                ZStack(alignment: .bottom) {
                    // 临时使用颜色块代替图片
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 500)
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                Text("示例壁纸")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        )
                        .blur(radius: blur)
                        .brightness(brightness)
                    
                    // 预览模式下的调节控制面板
                    if isPreviewMode {
                        VStack(spacing: 20) {
                            // 亮度调节
                            HStack {
                                Image(systemName: "sun.min")
                                    .foregroundColor(.white)
                                Slider(value: $brightness, in: -0.5...0.5)
                                Image(systemName: "sun.max")
                                    .foregroundColor(.white)
                            }
                            
                            // 模糊度调节
                            HStack {
                                Image(systemName: "circle")
                                    .foregroundColor(.white)
                                Slider(value: $blur, in: 0...10)
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15)
                        .padding()
                    }
                }
                
                // 操作按钮组
                HStack(spacing: 30) {
                    Button(action: {
                        isPreviewMode.toggle()
                        if !isPreviewMode {
                            // 重置调节参数
                            brightness = 0
                            blur = 0
                        }
                    }) {
                        VStack {
                            Image(systemName: isPreviewMode ? "eye.fill" : "eye")
                                .font(.system(size: 24))
                            Text("预览")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        // TODO: 实现下载功能
                    }) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 24))
                            Text("下载")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        isFavorited.toggle()
                    }) {
                        VStack {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                            Text("收藏")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        // TODO: 实现分享功能
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 24))
                            Text("分享")
                                .font(.caption)
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.vertical, 20)
                
                // 壁纸信息
                VStack(alignment: .leading, spacing: 15) {
                    // 标题和作者
                    VStack(alignment: .leading, spacing: 8) {
                        Text("壁纸标题")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(.gray)
                            Text("作者名称")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 标签
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["风景", "自然", "山水"], id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    
                    // 统计信息
                    HStack(spacing: 20) {
                        StatisticItem(icon: "eye", value: "1.2k", label: "浏览")
                        StatisticItem(icon: "heart", value: "368", label: "收藏")
                        StatisticItem(icon: "arrow.down", value: "256", label: "下载")
                    }
                    
                    Divider()
                        .background(Color.gray)
                    
                    // 相关推荐
                    VStack(alignment: .leading, spacing: 12) {
                        Text("相关推荐")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<5) { _ in
                                    RelatedWallpaperCard()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.black)
        .navigationBarTitle("壁纸详情", displayMode: .inline)
    }
}

// 统计项目组件
struct StatisticItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

// 相关推荐卡片
struct RelatedWallpaperCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 120, height: 160)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                )
            
            Text("相关壁纸")
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

// 预览
struct WallpaperDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WallpaperDetailView()
        }
        .preferredColorScheme(.dark)
    }
}