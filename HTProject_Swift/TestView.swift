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
    @State var age = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("input name here...", text: viewModel.name.binding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Name: \(viewModel.name.value)")
            Text("Age: \(age)")
            Button {
                viewModel.age.value! += 1
                age += 1
            } label: {
                Text("increase")
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
}
