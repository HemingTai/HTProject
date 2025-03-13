//
//  DemoViewController.swift
//  SwiftDemos
//
//  Created by heming on 17/2/28.
//  Copyright © 2017年 Mr.Tai. All rights reserved.
//

import UIKit

class TestTableViewCell : UITableViewCell {
    
}

class DemoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    var dataArray = ["无限轮播","地图标注","图片选择器","获取系统权限","跑马灯","缩放动画","弹性动画", "动画进阶", "二维码", "搜索", "CollectionView"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Swift Demos"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(longPressAction(longPressGesture:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1
        tableView.addGestureRecognizer(longPress)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func longPressAction(longPressGesture: UILongPressGestureRecognizer) {
        if longPressGesture.state == .ended {
            tableView.setEditing(!tableView.isEditing, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            let bannerView = TopBannerView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 253))
            //要先设置时间间隔才能自动滚动
            bannerView.autoScrollTimeInterval = 3
            bannerView.enableAutoScroll = true
            cell.contentView.addSubview(bannerView)
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? 253 : 60
    }
    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 1:
                let aMapVc = AnnotationViewController()
                navigationController?.pushViewController(aMapVc, animated: true)
            case 2:
                let cImgVc = ChooseImageViewController()
                navigationController?.pushViewController(cImgVc, animated: true)
            case 3:
                let saVc = SetAuthorizationViewController()
                navigationController?.pushViewController(saVc, animated: true)
            case 4:
                let hrlVc = HorseRaceLampViewController()
                navigationController?.pushViewController(hrlVc, animated: true)
            case 5:
                let scVc = ScaleViewController()
                navigationController?.pushViewController(scVc, animated: true)
            case 6:
                let spVc = SpringViewController()
                navigationController?.pushViewController(spVc, animated: true)
            case 7:
                let aVc = AnimationViewController()
                navigationController?.pushViewController(aVc, animated: true)
            case 8:
                let qVc = QRCodeViewController()
                navigationController?.pushViewController(qVc, animated: true)
            case 9:
                pushViewController(QRCodeViewController.self)
            case 10:
                pushViewController(CollectionViewController.self)
            default:
                break
        }
    }
    
    private func pushViewController<T>(_ type: T.Type) where T: UIViewController {
        navigationController?.pushViewController(type.self.init(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row as Int
            dataArray .remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "More") { (action, view, completion) in
            let shareMenu = UIAlertController(title: nil, message: "Share Using", preferredStyle: .actionSheet)
            let QQAction = UIAlertAction(title:"QQ",style:.default,handler: nil)
            let WeixinAction = UIAlertAction(title: "Weixin", style: .default, handler: nil)
            shareMenu.addAction(QQAction)
            shareMenu.addAction(WeixinAction)
            self.present(shareMenu,animated:true, completion:nil)
            completion(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let index = indexPath.row as Int
            self.dataArray .remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let config = UISwipeActionsConfiguration(actions: [shareAction, deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath != destinationIndexPath {
            let itemValue = self.dataArray[sourceIndexPath.row]
            self.dataArray.remove(at: sourceIndexPath.row)
            if destinationIndexPath.row > self.dataArray.count {
                self.dataArray.append(itemValue)
            }
            else {
                self.dataArray.insert(itemValue, at: destinationIndexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.row < 1 {
            return 0
        } else if indexPath.row < 2 {
            return 1
        } else {
            return 2
        }
    }
}
