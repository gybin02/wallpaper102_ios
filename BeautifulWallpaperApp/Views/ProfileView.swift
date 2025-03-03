import SwiftUI

struct ProfileView: View {
    // 用户名
    @State private var username = "用户名"
    // 是否开启通知
    @State private var notificationsEnabled = true
    // 是否开启自动播放
    @State private var autoplayEnabled = true
    // 缓存大小
    @State private var cacheSize = "0MB"
    
    private let downloadManager = WallpaperDownloadManager.shared
    
    private func updateCacheSize() {
        let size = downloadManager.getCacheSize()
        let mb = Double(size) / 1024 / 1024
        cacheSize = String(format: "%.1fMB", mb)
    }
    
    var body: some View {
        NavigationView {
            List {
                // 初始化时更新缓存大小
                .onAppear {
                    updateCacheSize()
                }
                // 用户信息区域
                Section {
                    HStack(spacing: 15) {
                        // 用户头像
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        // 用户信息
                        VStack(alignment: .leading, spacing: 4) {
                            Text(username)
                                .font(.title3)
                                .fontWeight(.medium)
                            Text("ID: 888888")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // 编辑按钮
                        Button(action: {
                            // TODO: 实现编辑个人信息功能
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // 通用设置
                Section(header: Text("通用设置")) {
                    // 通知开关
                    Toggle(isOn: $notificationsEnabled) {
                        Label {
                            Text("通知提醒")
                        } icon: {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // 自动播放开关
                    Toggle(isOn: $autoplayEnabled) {
                        Label {
                            Text("自动播放")
                        } icon: {
                            Image(systemName: "play.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                // 存储管理
                Section(header: Text("存储管理")) {
                    Button(action: {
                        downloadManager.clearCache()
                        updateCacheSize()
                    }) {
                        HStack {
                            Label {
                                Text("清理缓存")
                            } icon: {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Text(cacheSize)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // 关于
                Section(header: Text("关于")) {
                    // 版本信息
                    HStack {
                        Label {
                            Text("当前版本")
                        } icon: {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    // 隐私政策
                    NavigationLink(destination: Text("隐私政策页面")) {
                        Label {
                            Text("隐私政策")
                        } icon: {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.purple)
                        }
                    }
                    
                    // 用户协议
                    NavigationLink(destination: Text("用户协议页面")) {
                        Label {
                            Text("用户协议")
                        } icon: {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color.black)
            .navigationBarTitle("我的", displayMode: .large)
        }
    }
}

// 预览
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}