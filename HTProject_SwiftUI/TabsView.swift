//
//  TabsView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2022/6/13.
//  Copyright © 2022 Hem1ngT4i. All rights reserved.
//

import SwiftUI

class TabsViewModel: ObservableObject {
    @Published var entityTypes = ["Request", "Task", "Incident", "Device", "Infrastructure & Peripheral", "System Element", "Actual Service"]
}

struct TabsView: View {
    @ObservedObject var viewModel: TabsViewModel
    
    var body: some View {
//        ZStack {
//            measureTextWidth().hidden()
            VStack(spacing: 0) {
                Divider().frame(height: 13).overlay(Color.secondary)
                PagerTabStripView() {
                    ForEach(viewModel.entityTypes, id: \.self) { type in
                        MyView(type + " body").pagerTabItem {
                            PagerTabItem(data: type, viewModel: viewModel).measuredSize {
                                print("********** \($0)")
                            }
                        }
                    }
                }
                .pagerTabStripViewStyle(.scrollableBarButton(indicatorBarColor: .blue, tabItemSpacing: 15, tabItemHeight: 31))
                .frame(alignment: .center)
                .background(Color.secondary)
            }
//        }
    }
    
    private func measureTextWidth() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.entityTypes, id: \.self) { label in
                    Text(label)
                        .font(Font.system(size: 16))
                        .measuredSize {
                            print("=============\($0)")
                        }
                }
            }
        }.frame(height: 44)
    }
}

private func MyView(_ text: String) -> some View {
    VStack {
        Spacer()
        Text(text)
            .font(.system(size: 20))
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        Spacer()
    }
}

private class PagerTabItemTheme: ObservableObject {
    @Published var textColor = Color.black
    @Published var textFont = Font.system(size: 16)
}

private struct PagerTabItem: View, PagerTabViewDelegate {
    @ObservedObject private var theme = PagerTabItemTheme()
    
    private let data: String
    private let viewModel: TabsViewModel

    init(data: String, viewModel: TabsViewModel) {
        self.data = data
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(data)
            .foregroundColor(theme.textColor)
            .font(theme.textFont)
//            .frame(maxWidth: .infinity)
    }

    func setState(state: PagerTabViewState) {
        let flag = state == .selected
        theme.textColor = flag ? .red : .black
        theme.textFont = .system(size: flag ? 20 : 16)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(viewModel: TabsViewModel())
    }
}

private struct SizeKey: PreferenceKey {
    static let defaultValue = CGSize.zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    
    func measuredSize(_ perform: @escaping (CGSize) -> ()) -> some View {
        overlay(
            GeometryReader { proxy in
                Color.clear.preference(key: SizeKey.self, value: proxy.size)
            }.onPreferenceChange(SizeKey.self, perform: perform)
        )
    }
}
