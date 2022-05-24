//
//  EntityListItemView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2021/6/19.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct EntityListItemView: View {
    
    @State var title = "34567: Sample headline for ticket issue with text on two lines"
    @State var icon = "exclamationmark.3"
    @State var priority = "High"
    @State var phase = "First line support"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            BadgeView()
                .frame(height: 24)
                .cornerRadius(12)
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .lineLimit(2)
                .truncationMode(.tail)
                .frame(height: 44, alignment: .leading)
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: icon).foregroundColor(.orange)
                Text(priority)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.secondary)
                Text(phase)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            Text(phase)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .hidden()
        }.padding(16)
    }
}

struct EntityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        EntityListItemView()
    }
}
