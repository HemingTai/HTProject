//
//  QRCodeViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngTai on 2018/11/26.
//  Copyright © 2018 Hem1ng. All rights reserved.
//  二维码

import UIKit
import CoreImage

class QRCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "二维码"
        self.view.backgroundColor = .white
        
        let imageView = UIImageView(frame: CGRect(x: 100, y:246, width: 175, height: 175))
        imageView.image = self.generatorQRCode(withUrl: "我爱你中国！")
        self.view.addSubview(imageView)
    }

    /// 生成二维码
    func generatorQRCode(withUrl url: String) -> UIImage {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        
        let data = url.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        let image = filter?.outputImage
        let qrcodeImage = self.generatorHDImage(withImage: image!, size: 200)
        return qrcodeImage
    }
    
    /// 生成高清图片
    func generatorHDImage(withImage image:CIImage, size: CGFloat) -> UIImage {
        let extent = image.extent
        let scale = min(size/extent.width, size/extent.height)
        
        let width = extent.width*scale
        let height = extent.height*scale
        let cs = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(image, from: extent)
        bitmapRef?.interpolationQuality = .none
        bitmapRef?.scaleBy(x: scale, y: scale)
        bitmapRef?.draw(bitmapImage!, in: extent)
        
        let scaledImage = bitmapRef!.makeImage()
        return UIImage(cgImage: scaledImage!)
    }
}
