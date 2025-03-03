import SwiftUI

struct CategoryView: View {
    // 搜索文本
    @State private var searchText = ""
    // 选中的标签
    @State private var selectedTags: Set<String> = []
    // 当前排序方式
    @State private var sortOption = SortOption.latest
    
    // 所有可用的标签
    let tags = ["风景", "人物", "动漫", "艺术", "抽象", "萌宠", "游戏", "建筑", "美食", "汽车", "科技", "时尚"]
    
    // 排序选项
    enum SortOption: String, CaseIterable {
        case latest = "最新"
        case popular = "最热"
        case favorites = "收藏最多"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                SearchBar(searchText: $searchText)
                    .padding()
                
                // 标签筛选区域
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            TagButton(tag: tag, isSelected: selectedTags.contains(tag)) {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // 排序选项
                HStack {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        SortButton(option: option, isSelected: sortOption == option) {
                            sortOption = option
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // 分类网格
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                        ForEach(0..<20) { _ in
                            CategoryCard()
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black)
            .navigationBarTitle("分类", displayMode: .large)
        }
    }
}

// 标签按钮
struct TagButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.white : Color.clear)
                .foregroundColor(isSelected ? .black : .white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

// 排序按钮
struct SortButton: View {
    let option: CategoryView.SortOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(option.rawValue)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
        }
    }
}

// 分类卡片
struct CategoryCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            // 壁纸图片
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .overlay(
                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        Text("示例壁纸")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                )
            
            // 壁纸信息
            VStack(alignment: .leading, spacing: 4) {
                Text("壁纸标题")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Text("分类")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "heart")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("1.2k")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
        .background(Color.black)
        .cornerRadius(12)
    }
}

// 预览
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
            .preferredColorScheme(.dark)
    }
}