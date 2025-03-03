import SwiftUI

struct DiscoverView: View {
    // 滚动视图的偏移量
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 顶部搜索栏
                SearchBar()
                    .padding(.horizontal)
                
                // 精选推荐区域
                FeaturedSection()
                
                // 分类导航
                CategoryNavigationSection()
                
                // 每日推荐
                DailyRecommendationSection()
                
                // 最新上线
                NewArrivalsSection()
            }
            .padding(.bottom)
        }
        .background(Color.black)
        .navigationBarTitle("发现", displayMode: .large)
    }
}

// 搜索栏
struct SearchBar: View {
    @State private var searchText = ""
    @State private var isSearchPresented = false
    
    var body: some View {
        HStack {
            Button(action: { isSearchPresented = true }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    Text("搜索壁纸")
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $isSearchPresented) {
                SearchView()
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// 精选推荐区域
struct FeaturedSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("精选推荐")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { _ in
                        FeaturedCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// 精选卡片
struct FeaturedCard: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // 临时使用颜色块代替图片
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 280, height: 400)
            
            // 渐变遮罩
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
            
            // 标题
            Text("精选壁纸标题")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}

// 分类导航区域
struct CategoryNavigationSection: View {
    let categories = ["风景", "人物", "动漫", "艺术", "抽象", "萌宠", "游戏", "更多"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("分类导航")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    CategoryItem(title: category)
                }
            }
            .padding(.horizontal)
        }
    }
}

// 分类项目
struct CategoryItem: View {
    let title: String
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                )
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

// 每日推荐区域
struct DailyRecommendationSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("每日推荐")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<6) { _ in
                        RecommendationCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// 推荐卡片
struct RecommendationCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 160, height: 200)
            
            Text("推荐壁纸")
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("分类 · 作者")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// 最新上线区域
struct NewArrivalsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最新上线")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                ForEach(0..<6) { _ in
                    NewArrivalCard()
                }
            }
            .padding(.horizontal)
        }
    }
}

// 最新上线卡片
struct NewArrivalCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
            
            Text("最新壁纸")
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.top, 4)
            
            Text("分类 · 作者")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// 预览
struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .preferredColorScheme(.dark)
    }
}