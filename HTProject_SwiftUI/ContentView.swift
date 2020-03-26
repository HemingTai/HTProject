//
//  ContentView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2020/3/26.
//  Copyright © 2020 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Turtle Rock")
                .font(.title)
            HStack {
                Text("Joshua Tree National Park")
                    .font(.subheadline)
                Spacer()
                Text("California")
                .font(.subheadline)
            }
        }
        .padding()
    }
}

#if DEBUG
struct ContentView_previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
