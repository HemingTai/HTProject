//
//  BadgeView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2021/6/19.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct BadgeView: View {
    
    @State var text = "IT Service Request"
    @State var badgeColor = Color(red: 35/255.0, green: 28/255.0, blue: 165/255.0)
    
    var body: some View {
        ZStack {
            badgeColor
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
        }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
