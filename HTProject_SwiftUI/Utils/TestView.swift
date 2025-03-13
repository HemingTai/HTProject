//
//  TestView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2025/3/13.
//  Copyright © 2025 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @ObservedObject var viewModel: TestViewModel
    @State var age: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                TextField("input name...", text: viewModel.name.binding)
                    .frame(width: 200, height: 20)
                    .textFieldStyle(.roundedBorder)
                    .border(Color.blue)
                    .cornerRadius(4)
                    .keyboardType(.default)
            }
            Button {
                viewModel.age.value! += 1
            } label: {
                Text("show age")
            }
        }
    }
}
