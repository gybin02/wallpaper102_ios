import SwiftUI

struct FavoriteView: View {
    // 是否处于编辑模式
    @State private var isEditing = false
    // 选中的壁纸
    @State private var selectedWallpapers: Set<Int> = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 收藏列表
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                        ForEach(0..<10) { index in
                            FavoriteCard(isEditing: $isEditing,
                                       isSelected: selectedWallpapers.contains(index),
                                       onSelect: {
                                           if selectedWallpapers.contains(index) {
                                               selectedWallpapers.remove(index)
                                           } else {
                                               selectedWallpapers.insert(index)
                                           }
                                       })
                        }
                    }
                    .padding()
                }
                
                // 编辑模式下的底部工具栏
                if isEditing {
                    HStack(spacing: 20) {
                        Button(action: {
                            // 取消选择
                            selectedWallpapers.removeAll()
                        }) {
                            Text("取消选择")
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            // 全选
                            for i in 0..<10 {
                                selectedWallpapers.insert(i)
                            }
                        }) {
                            Text("全选")
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            // 删除选中项
                            // TODO: 实现删除逻辑
                        }) {
                            Text("删除")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                }
            }
            .background(Color.black)
            .navigationBarTitle("收藏", displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    isEditing.toggle()
                    if !isEditing {
                        selectedWallpapers.removeAll()
                    }
                }) {
                    Text(isEditing ? "完成" : "编辑")
                }
            )
        }
    }
}

// 收藏卡片
struct FavoriteCard: View {
    @Binding var isEditing: Bool
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 壁纸图片
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
                
                // 壁纸信息
                VStack(alignment: .leading, spacing: 4) {
                    Text("壁纸标题")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text("收藏时间: 2024-01-20")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
            }
            
            // 编辑模式下的选择按钮
            if isEditing {
                Button(action: onSelect) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .blue : .white)
                        .font(.title2)
                        .padding(8)
                }
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
                .padding(8)
            }
        }
        .background(Color.black)
        .cornerRadius(12)
    }
}

// 预览
struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .preferredColorScheme(.dark)
    }
}