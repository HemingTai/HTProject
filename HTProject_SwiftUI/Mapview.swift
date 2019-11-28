//
//  Mapview.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ng on 2019/10/9.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

import SwiftUI
import MapKit

//在SwiftUI中要使用UIView或者其子类，你需要让你的view遵循UIViewRepresentable协议
struct Mapview: UIViewRepresentable {
    //makeUIView(context:)来创建View
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    //updateUIView(_:context:)来更新view
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 31.245105, longitude: 121.506377)
        let span = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.000001)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct Mapview_Previews: PreviewProvider {
    static var previews: some View {
        Mapview()
    }
}
