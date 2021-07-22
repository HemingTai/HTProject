//
//  BadgeView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2021/6/19.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct BadgeView: View {
    @State var text = "Service Request"
    @State var badgeColor = ""
    
    var body: some View {
        Color(.blue)
        Text(text)
            .padding(EdgeInsets(top: -28, leading: 14, bottom: 0, trailing: 14))
            .foregroundColor(.white)
            .font(.system(.headline))
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
