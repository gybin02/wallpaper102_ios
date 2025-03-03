import SwiftUI

struct WallpaperPreviewView: View {
    // 模糊度
    @State private var blurAmount: Double = 0
    // 亮度
    @State private var brightness: Double = 0
    // 预览模式
    @State private var previewMode: PreviewMode = .both
    // 显示设置成功提示
    @State private var showingSuccessAlert = false
    
    // 预览模式选项
    enum PreviewMode: String, CaseIterable {
        case lockScreen = "锁屏"
        case homeScreen = "主屏"
        case both = "锁屏和主屏"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 预览区域
            ZStack {
                // 临时使用颜色块代替图片
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    .overlay(
                        VStack(spacing: 4) {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("预览壁纸")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    )
                    .blur(radius: CGFloat(blurAmount))
                    .brightness(brightness)
            }
            .background(Color.black)
            
            // 控制面板
            VStack(spacing: 25) {
                // 模糊度调节
                VStack(alignment: .leading, spacing: 8) {
                    Text("模糊度")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Slider(value: $blurAmount, in: 0...10)
                            .accentColor(.white)
                        Text(String(format: "%.1f", blurAmount))
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(width: 40)
                    }
                }
                
                // 亮度调节
                VStack(alignment: .leading, spacing: 8) {
                    Text("亮度")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Slider(value: $brightness, in: -0.5...0.5)
                            .accentColor(.white)
                        Text(String(format: "%.1f", brightness))
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(width: 40)
                    }
                }
                
                // 预览模式选择
                HStack(spacing: 15) {
                    ForEach(PreviewMode.allCases, id: \.self) { mode in
                        Button(action: {
                            previewMode = mode
                        }) {
                            Text(mode.rawValue)
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(previewMode == mode ? Color.white : Color.clear)
                                .foregroundColor(previewMode == mode ? .black : .white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: previewMode == mode ? 0 : 1)
                                )
                        }
                    }
                }
                
                // 设置按钮
                Button(action: {
                    // 将预览模式转换为壁纸位置
                    let location: WallpaperLocation = switch previewMode {
                    case .lockScreen: .lockScreen
                    case .homeScreen: .homeScreen
                    case .both: .both
                    }
                    
                    // 获取当前预览的图片
                    // TODO: 替换为实际的壁纸图片
                    guard let image = UIImage(systemName: "photo") else { return }
                    
                    // 设置壁纸
                    WallpaperDownloadManager.shared.setWallpaper(image, for: location) { error in
                        if let error = error {
                            print("设置壁纸失败: \(error.localizedDescription)")
                        } else {
                            showingSuccessAlert = true
                        }
                    }
                    showingSuccessAlert = true
                }) {
                    Text("设置壁纸")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
        .background(Color.black)
        .navigationBarTitle("预览", displayMode: .inline)
        .alert(isPresented: $showingSuccessAlert) {
            Alert(
                title: Text("设置成功"),
                message: Text("壁纸已成功设置为" + previewMode.rawValue),
                dismissButton: .default(Text("确定"))
            )
        }
    }
}

// 预览
struct WallpaperPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WallpaperPreviewView()
        }
        .preferredColorScheme(.dark)
    }
}