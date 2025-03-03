import SwiftUI

struct ContentView: View {
    // 当前选中的标签页
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 发现页面
            DiscoverView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "sparkles" : "sparkles")
                    Text("发现")
                }.tag(0)
            
            // 分类页面
            CategoryView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                    Text("分类")
                }
                .tag(1)
            
            // 收藏页面
            FavoriteView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "heart.fill" : "heart")
                    Text("收藏")
                }
                .tag(2)
            
            // 我的页面
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("我的")
                }
                .tag(3)
        }
        //                .tabViewStyle(TabViewStyle.)
        .accentColor(.white) // 设置选中时的颜色为白色
        .preferredColorScheme(.dark) // 强制使用暗色模式
    }
}
// 预览
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
