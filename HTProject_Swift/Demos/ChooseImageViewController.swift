//
//  ChooseImageViewController.swift
//  TestSwift
//
//  Created by heming on 16/4/20.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

import Foundation
import UIKit

class ChooseImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imageView: UIImageView?
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择图片"
        self.view.backgroundColor = UIColor.white
    
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64))
        self.view.addSubview(imageView!)
        imagePicker.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView?.image = info["UIImagePickerControllerOriginalImage"] as! UIImage?
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
