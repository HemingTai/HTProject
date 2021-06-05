//
//  AnimationViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngTai on 2018/11/26.
//  Copyright © 2018 Hem1ng. All rights reserved.
//  动画进阶

import UIKit

class AnimationViewController: UIViewController {
    
    var myView = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "动画"
        self.view.backgroundColor = .white

        myView.frame = CGRect(x: 100, y: 182, width: 175, height: 175)
        myView.backgroundColor = .orange
        myView.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        self.view.addSubview(myView)
    }

    @objc func btnAction() {
//        self.positionAnimation()
//        self.transformAnimation()
//        self.scaleAnimation()
//        self.keyframePositionAnimation()
//        self.keyframeTransformAnimation()
//        self.transitionAnimation()
        self.groupAnimation()
    }
    
    //MARK: ------ 基础动画 ------
    
    /// 位置动画
    func positionAnimation() {
        let posAni = CABasicAnimation(keyPath: "position")
        posAni.fromValue = NSValue(cgPoint: CGPoint(x: 50, y: 50))
        posAni.toValue = NSValue(cgPoint: CGPoint(x: 187.5, y: 333.5))
        posAni.duration = 1
        //forwards表示停留在最新的位置，backwards
        posAni.fillMode = CAMediaTimingFillMode(rawValue: "fowards")
        posAni.isRemovedOnCompletion = false
        //是否按原路径返回
        posAni.autoreverses = true
        
        myView.layer.add(posAni, forKey: "myPos")
    }
    
    /// 旋转动画
    func transformAnimation() {
        let traAni = CABasicAnimation(keyPath: "transform.rotation.z")
        traAni.toValue = Double.pi/4
        traAni.duration = 1
        //forwards表示停留在最新的位置，backwards
        traAni.fillMode = CAMediaTimingFillMode(rawValue: "fowards")
        traAni.isRemovedOnCompletion = false
        //设置重复次数
        traAni.repeatCount = MAXFLOAT
        //是否累积
        traAni.isCumulative = true
        
        myView.layer.add(traAni, forKey: "myTra")
    }
    
    /// 缩放动画
    func scaleAnimation() {
        let scaAni = CABasicAnimation(keyPath: "transform.scale")
        scaAni.toValue = 0.5
        scaAni.duration = 1
        //forwards表示停留在最新的位置，并且不移除动画
        scaAni.fillMode = CAMediaTimingFillMode(rawValue: "fowards")
        scaAni.isRemovedOnCompletion = false
        //设置重复次数
        scaAni.repeatCount = MAXFLOAT
        //是否累积
        scaAni.autoreverses = true
        myView.layer.add(scaAni, forKey: "mySca")
    }
    
    //MARK: ------ 关键帧动画 ------
    
    /// 位移动画
    func keyframePositionAnimation() {
        let kfpAni = CAKeyframeAnimation(keyPath: "position")
        let value1 = NSValue(cgPoint: CGPoint(x: 50, y: 50))
        let value2 = NSValue(cgPoint: CGPoint(x: 150, y: 50))
        let value3 = NSValue(cgPoint: CGPoint(x: 150, y: 150))
        let value4 = NSValue(cgPoint: CGPoint(x: 50, y: 150))
        let value5 = NSValue(cgPoint: CGPoint(x: 50, y: 50))
        kfpAni.values = [value1, value2, value3, value4, value5]
        kfpAni.duration = 1.5
        
        //设置重复次数
        kfpAni.repeatCount = MAXFLOAT
        myView.layer.add(kfpAni, forKey: "myKfp")
    }
    
    /// 旋转动画
    func keyframeTransformAnimation() {
        let kftAni = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let leftAngle = Double.pi/180 * 20
        let rightAngle = Double.pi/180 * -20
        kftAni.values = [leftAngle, rightAngle]
        kftAni.duration = 1.5
        kftAni.autoreverses = true
        //设置重复次数
        kftAni.repeatCount = MAXFLOAT
        myView.layer.add(kftAni, forKey: "myKft")
    }
    
    //MARK: ------ 渐变动画 ------
    func transitionAnimation() {
        myView.backgroundColor = UIColor(patternImage: UIImage(contentsOfFile:Bundle.main.path(forResource: "1", ofType: "jpeg")!)!)
        let tAni = CATransition()
        tAni.type = CATransitionType.push
        tAni.subtype = CATransitionSubtype.fromBottom
        tAni.duration = 1
        myView.layer.add(tAni, forKey: "myt")
    }
    
    //MARK: ------ 组合动画 ------
    func groupAnimation() {
        let traAni = CABasicAnimation(keyPath: "transform.rotation.z")
        traAni.toValue = Double.pi
        traAni.isRemovedOnCompletion = false
        traAni.isCumulative = true
        
        let scaAni = CABasicAnimation(keyPath: "transform.scale")
        scaAni.toValue = 0.5
        scaAni.autoreverses = true
        
        let kfpAni = CAKeyframeAnimation(keyPath: "position")
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 50, y: 50))
        path.addLine(to: CGPoint(x: 150, y: 50))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.addLine(to: CGPoint(x: 50, y: 150))
        path.addLine(to: CGPoint(x: 50, y: 50))
        kfpAni.path = path
        
        let groupAni = CAAnimationGroup()
        groupAni.duration = 1.5
        groupAni.animations = [traAni, scaAni, kfpAni]
        groupAni.fillMode = CAMediaTimingFillMode(rawValue: "fowards")
        groupAni.isRemovedOnCompletion = false
        groupAni.repeatCount = MAXFLOAT
        myView.layer.add(groupAni, forKey: "mygroup")
    }
}
