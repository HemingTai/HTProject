//
//  ContentView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2020/3/26.
//  Copyright © 2020 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selected = "1"
    @State private var fruits = ["Apple", "Banana", "Papaya", "Mango"]
    
    var body: some View {
//        NavigationView {
//            if #available(iOS 14.0, *) {
//                List {
//                    ForEach(fruits, id: \.self) { fruit in
//                        Text(fruit)
//                    }
//                    .onDelete { deleteFruit(at :$0) }
//                    .onMove { moveFruit(from: $0, to: $1) }
//                }
//                .navigationTitle("Fruits")
//                .toolbar { EditButton() }
//            }
//        }
//        FormView()
//        VStack {
//            Mapview()
//                .frame(height: 300)
//                .offset(x: 0, y: -44)
//
//            CircleImage()
//                .offset(x: 0, y: -164)
//
//            VStack(alignment: .leading) {
//                Text("Television Tower")
//                    .font(.title)
//                HStack {
//                    Text("Shanghai Television Tower")
//                        .font(.subheadline)
//                    Spacer()
//                    Text("Lujiazui")
//                        .font(.subheadline)
//                }
//                    .offset(x: 0, y: 10)
//            }
//                .padding()
//                .offset(x: 0, y: -150)
//        }
//        TabsView(viewModel: TabsViewModel())
        TagScrollView(tags: (1...20).map { "Item \($0)" }, selectedTag: $selected)
//        ReorderableListView()
    }
    
    func deleteFruit(at: IndexSet) {
        fruits.remove(atOffsets: at)
    }
    
    func moveFruit(from: IndexSet, to: Int) {
        fruits.move(fromOffsets: from, toOffset: to)
    }
}

struct TagScrollView: View {
    let tags: [String]
    @Binding var selectedTag: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedTag == tag ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .onTapGesture {
                            selectedTag = tag
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ReorderableListView: View {
    @State private var items = (1...20).map { "Item \($0)" }
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
            .onMove { indices, newOffset in
                items.move(fromOffsets: indices, toOffset: newOffset)
            }
        }
        .toolbar {
            EditButton()
        }
    }
}

#if DEBUG
struct ContentView_previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
