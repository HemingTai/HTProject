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
        VStack {
            Mapview()
                .frame(height: 300)
                .offset(x: 0, y: -44)
            
            CircleImage()
                .offset(x: 0, y: -164)
            
            VStack(alignment: .leading) {
                Text("Television Tower")
                    .font(.title)
                HStack {
                    Text("Shanghai Television Tower")
                        .font(.subheadline)
                    Spacer()
                    Text("Lujiazui")
                        .font(.subheadline)
                }
                    .offset(x: 0, y: 10)
            }
                .padding()
                .offset(x: 0, y: -150)
        }
            .edgesIgnoringSafeArea(.top)
    }
}

#if DEBUG
struct ContentView_previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
