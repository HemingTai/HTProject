//
//  MyViews.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2022/1/19.
//  Copyright © 2022 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct MyViews: View {
    var body: some View {
        Text("Hello, Telegram,Hello, Telegram,Hello, TelegramHello, TelegramHello, TelegramHello, TelegramHello, TelegramHello, TelegramHello, Telegram")
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .padding(.all, 10.0)
            .frame(width: nil, height: 100, alignment: .top)
            .cornerRadius(8)
    }
}

struct MyViews_Previews: PreviewProvider {
    static var previews: some View {
        MyViews()
    }
}
