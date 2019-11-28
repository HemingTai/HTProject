//
//  HorseRaceLampViewController.swift
//  TestSwift
//
//  Created by heming on 16/9/8.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

import UIKit

class HorseRaceLampViewController: UIViewController {
    var bgLabel      : UILabel?
    var contentLabel : UILabel?
    var titleArray   = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
    var timer        : Timer?
    var count        = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        bgLabel = UILabel(frame: frame);
        bgLabel?.clipsToBounds = true
        bgLabel!.backgroundColor = UIColor.black
        self.view.addSubview(bgLabel!)
        
        contentLabel = UILabel(frame: CGRect(x: 100, y: 0, width: 100, height: 30))
        contentLabel!.text = titleArray[0]
        contentLabel!.textAlignment = .left
        contentLabel!.textColor = UIColor.white
        contentLabel?.backgroundColor = UIColor.clear
        contentLabel!.font = UIFont.systemFont(ofSize: 15)
        bgLabel!.addSubview(contentLabel!)
        
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.nextDay), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 2.0, delay: 2.0, options: [.curveLinear, .repeat], animations: {
            var f = self.contentLabel!.frame
            f.origin.x = f.origin.x-self.bgLabel!.frame.size.width-self.contentLabel!.frame.size.width
            self.contentLabel!.frame = f
        })
    }
    
    @objc func nextDay() {
        let index = self.count%self.titleArray.count
        self.contentLabel?.text = self.titleArray[index]
        self.count += 1
        if self.count == self.titleArray.count {
            self.count = 0
        }
    }
}
