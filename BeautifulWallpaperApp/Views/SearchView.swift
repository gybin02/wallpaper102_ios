import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var searchHistory = ["风景壁纸", "动漫壁纸", "萌宠壁纸"]
    @State private var hotSearches = ["自然风光", "二次元", "可爱动物", "科技感", "简约"]
    @State private var isSearching = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 搜索栏
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("搜索壁纸", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            if !searchText.isEmpty {
                                isSearching = true
                                if !searchHistory.contains(searchText) {
                                    searchHistory.insert(searchText, at: 0)
                                }
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            }
            .padding()
            
            if !isSearching {
                // 搜索历史
                if !searchHistory.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("搜索历史")
                                .font(.headline)
                            Spacer()
                            Button(action: { searchHistory.removeAll() }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        FlowLayout(spacing: 8) {
                            ForEach(searchHistory, id: \.self) { item in
                                HistoryTag(text: item) {
                                    searchText = item
                                    isSearching = true
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // 热门搜索
                VStack(alignment: .leading, spacing: 12) {
                    Text("热门搜索")
                        .font(.headline)
                    
                    FlowLayout(spacing: 8) {
                        ForEach(hotSearches, id: \.self) { item in
                            HotSearchTag(text: item, rank: hotSearches.firstIndex(of: item)! + 1) {
                                searchText = item
                                isSearching = true
                            }
                        }
                    }
                }
                .padding()
            } else {
                // 搜索结果
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                        ForEach(0..<10) { _ in
                            SearchResultCard()
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

// 流式布局
struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    let content: () -> Content
    
    init(spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastHeight = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            content() // ✅ 这里现在返回的是 `View` 而不是 `[AnyView]`
                .background(GeometryReader { innerGeo in
                    Color.clear.onAppear {
                        lastHeight = innerGeo.size.height
                    }
                })
                .alignmentGuide(.leading) { dimension in
                    if abs(width - dimension.width) > geometry.size.width {
                        width = 0
                        height -= lastHeight
                    }
                    let result = width
                    width -= dimension.width
                    return result
                }
                .alignmentGuide(.top) { _ in
                    let result = height
                    return result
                }
        }
    }
}

// 历史标签
struct HistoryTag: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption)
                Text(text)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .foregroundColor(.white)
    }
}

// 热门搜索标签
struct HotSearchTag: View {
    let text: String
    let rank: Int
    let action: () -> Void
    
    var rankColor: Color {
        switch rank {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text("\(rank)")
                    .font(.caption)
                    .foregroundColor(rankColor)
                Text(text)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .foregroundColor(.white)
    }
}

// 搜索结果卡片
struct SearchResultCard: View {
    var body: some View {
        VStack(alignment: .leading) {
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
            
            Text("搜索结果标题")
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.top, 4)
            
            Text("分类 · 作者")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .background(Color.black)
        .cornerRadius(12)
    }
}

// 预览
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .preferredColorScheme(.dark)
    }
}
