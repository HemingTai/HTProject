//
//  EntityListItemView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2021/6/19.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct EntityListItemView: View {
    
    var body: some View {
        VStack {
            BadgeView()
                .frame(width: 300, height: 28)
                .cornerRadius(14)
            Text("Title")
                .font(.headline)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct EntityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        EntityListItemView()
    }
}
