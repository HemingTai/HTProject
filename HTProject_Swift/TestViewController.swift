//
//  TestViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ng on 2019/9/23.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //当我们在一个普通的 controller, view 上重写这个属性，只会影响当前的视图，不会影响前面的 controller 和后续 present 的 controller
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        /********* [unowned self] 和 [weak self]区别 *********
         * swift虽然使用了ARC自动引用计数来管理内存，但是也不能保证完全准确，在使用闭包的时候有可能会引起循环引用
         * 所以此时只需将闭包捕获列表定义为弱引用(weak)或者无主引用(unowned)即可解决问题
         * 如果捕获（比如 self）可以被设置为 nil，也就是说它可能在闭包前被销毁，那么就要将捕获定义为 weak
         * 如果它们一直是相互引用，即同时销毁的，那么就可以将捕获定义为 unowned
         */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
    deinit {
        print("deinit")
    }
    
    //监听系统模式的变化并作出响应，需要在监听的viewController中重写下列函数，注意:参数为变化前的traitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            // 判断两个UITraitCollection对象是否不同
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                print("模式已变化")
                self.view.backgroundColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .black
                    } else {
                        return .white
                    }
                })
            }
            
            // 通过当前traitCollection得到对应UIColor，再转换成CGColor
            let resolvedColor = UIColor.blue.resolvedColor(with: self.traitCollection)
            _ = resolvedColor.cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UIViewController()
        //需要指定推出模式为fullScreen，在iOS 13中，默认模式变成automatic，这样推出来的视图不会调用父视图的willDisappear和willAppear
        vc.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            vc.view.backgroundColor = .systemBackground
        }
        self.present(vc, animated: true, completion: nil)
    }
}
