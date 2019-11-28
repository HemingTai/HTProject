//
//  ShareViewController.swift
//  TestSwift
//
//  Created by Mr.W on 16/4/15.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

import Foundation
import UIKit

class SpringViewController: UIViewController
{
    var topView  = UIView()
    let fbBtn    = UIButton()
    let twBtn    = UIButton()
    let smsBtn   = UIButton()
    let emailBtn = UIButton()
    let transform1 = CGAffineTransform(translationX: 0, y: 500)
    let transform2 = CGAffineTransform(translationX: 0, y: 700)
    let transform3 = CGAffineTransform(translationX: 0, y: -700)
    let transform4 = CGAffineTransform(translationX: 0, y: -500)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "弹性动画"
        
        let bgImgView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        bgImgView.image = UIImage(named: "launch-568")
        bgImgView.isUserInteractionEnabled = true
        self.view.addSubview(bgImgView)
        
        let blurEffect = UIBlurEffect(style:.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgImgView.bounds
        bgImgView.addSubview(blurEffectView)
        
        topView.frame = CGRect(x: (self.view.frame.size.width-120)/2, y: (self.view.frame.size.height-120-64)/2, width: 120, height: 120)
        topView.backgroundColor = UIColor.clear
        bgImgView.addSubview(topView)
        
        fbBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        fbBtn.setImage(UIImage(named: "facebook"), for: .normal)
        fbBtn.transform = transform1
        topView.addSubview(fbBtn)
        
        twBtn.frame = CGRect(x: 60, y: 0, width: 60, height: 60)
        twBtn.setImage(UIImage(named: "twitter"), for: .normal)
        twBtn.transform = transform4
        topView.addSubview(twBtn)
        
        smsBtn.frame = CGRect(x: 0, y: 60, width: 60, height: 60)
        smsBtn.setImage(UIImage(named: "message"), for: .normal)
        smsBtn.transform = transform2
        topView.addSubview(smsBtn)
        
        emailBtn.frame = CGRect(x: 60, y: 60, width: 60, height: 60)
        emailBtn.setImage(UIImage(named: "email"), for: .normal)
        emailBtn.transform = transform3
        topView.addSubview(emailBtn)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //弹性动画
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations:
            {
                self.fbBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                self.smsBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                UIView.animate(withDuration: 3, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations:
                    {
                        self.emailBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.twBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                    }, completion: nil)
            }, completion: nil)
    }
}
