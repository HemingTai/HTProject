//
//  EntityListView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2021/6/19.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct EntityListView: View {
    var body: some View {
        Group {
            EntityListItemView()
            EntityListItemView()
            EntityListItemView()
        }
    }
}

struct EntityListView_Previews: PreviewProvider {
    static var previews: some View {
        EntityListView()
    }
}
