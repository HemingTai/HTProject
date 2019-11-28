//
//  DetailViewController.swift
//  TestSwift
//
//  Created by Mr.W on 16/4/14.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

import UIKit

class ScaleViewController: UIViewController {
    var topView = UIView()
    let transform1 = CGAffineTransform(scaleX: 0.0, y: 0.0)
    let transform2 = CGAffineTransform(translationX: 0, y: 500)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "缩放动画"
        
        let bgImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        bgImgView.image = UIImage(named: "launch-568")
        bgImgView.isUserInteractionEnabled = true
        self.view.addSubview(bgImgView)
        
        let blurEffect = UIBlurEffect(style:.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgImgView.bounds
        bgImgView.addSubview(blurEffectView)
        
        topView.frame = CGRect(x: (self.view.frame.size.width-231)/2, y: 102, width: 231, height: 242)
        topView.backgroundColor = .clear
        topView.transform = transform1.concatenating(transform2)
        bgImgView.addSubview(topView)
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 21, width: 200, height: 50))
        titleLabel.text = "You’ve dined here.\nWhat did you think?"
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "", size: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        topView.addSubview(titleLabel)
        
        let badBtn = UIButton(frame: CGRect(x: 9, y: 100, width: 64, height: 64))
        badBtn.setImage(UIImage(named: "bad"), for: .normal)
        badBtn.layer.cornerRadius = 32
        badBtn.alpha = 0.9
        topView.addSubview(badBtn)
        
        let goodBtn = UIButton(frame: CGRect(x: 83, y: 100, width: 64, height: 64))
        goodBtn.setImage(UIImage(named: "good"), for: .normal)
        goodBtn.layer.cornerRadius = 32
        goodBtn.alpha = 0.9
        topView.addSubview(goodBtn)
        
        let greatBtn = UIButton(frame: CGRect(x: 156, y: 100, width: 64, height: 64))
        greatBtn.setImage(UIImage(named: "great"), for: .normal)
        greatBtn.layer.cornerRadius = 32
        greatBtn.alpha = 0.9
        topView.addSubview(greatBtn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //缩放动画
//        UIView.animateWithDuration(1) { 
//            self.topView.transform = CGAffineTransformMakeScale(1.0, 1.0)
//        }
        //弹性动画
//        UIView.animateWithDuration(2, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: .AllowUserInteraction, animations:
//            {
//                self.topView.transform = CGAffineTransformMakeScale(1.0, 1.0)
//            }, completion: nil)
//        UIView.animateWithDuration(2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .AllowUserInteraction, animations:
//            {
//                self.topView.transform = CGAffineTransformMakeTranslation(0, 0)
//            }, completion: nil)
        //混合动画
        UIView.animate(withDuration: 2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
            let scaleTransform = CGAffineTransform(scaleX: 1, y: 1)
            let translationTransform = CGAffineTransform(translationX: 0, y: 0)
            self.topView.transform = scaleTransform.concatenating(translationTransform)
        }, completion: nil)
    }
}
