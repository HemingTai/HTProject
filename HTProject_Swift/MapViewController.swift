//
//  MapViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2020/11/26.
//  Copyright © 2020 Hem1ngT4i. All rights reserved.
//

import UIKit
import MapKit

enum MapType {
    enum Scheme: String {
        case AppleMap = "http://maps.apple.com"
        case GoogleMap = "comgooglemaps://"
        case AMap = "iosamap://"
    }
    enum Title: String {
        case AppleMap = "Apple Map"
        case GoogleMap = "Google Map"
        case AMap = "Amap"
    }
    enum URL: String {
        case AppleMap = "http://maps.apple.com?q=%@"
        case GoogleMap = "comgooglemaps://?q=%@"
        case AMap = "iosamap://poi?sourceApplication=SMAMobile&name=%@"
    }
}

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var maps: [MapType.Scheme] = []
        var titles: [MapType.Title] = []
        var urls: [MapType.URL] = []
        if canOpenMap(scheme: .AppleMap) {
            maps.append(.AppleMap)
            titles.append(.AppleMap)
            urls.append(.AppleMap)
        }
        if canOpenMap(scheme: .GoogleMap) {
            maps.append(.GoogleMap)
            titles.append(.GoogleMap)
            urls.append(.GoogleMap)
        }
        if canOpenMap(scheme: .AMap) {
            maps.append(.AMap)
            titles.append(.AMap)
            urls.append(.AMap)
        }
        var actions = [UIAlertAction]()
        for i in 0 ..< maps.count {
            let shceme = String(format: urls[i].rawValue, "纳贤路799号").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            actions.append( initAlertAction(title: titles[i].rawValue, handler: { self.open(scheme: shceme)}))
        }
        showActionSheet(title: "Map", actions: actions)
    }
    
    private func canOpenMap(scheme: MapType.Scheme) -> Bool {
        guard let url = URL(string: scheme.rawValue) else { return false}
        return UIApplication.shared.canOpenURL(url)
    }
    
    private func open(scheme: String) {
        guard let url = URL(string: scheme) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in })
    }
    
    private func initAlertAction(title: String, handler: @escaping () -> Void) -> UIAlertAction {
        UIAlertAction(title: title, style: .default) { _ in handler() }
    }
    
    private func showActionSheet(title: String, message: String? = nil, actions: [UIAlertAction]) {
        let prompt = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { prompt.addAction($0) }
        prompt.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
        self.present(prompt, animated: true, completion: nil)
    }
}
