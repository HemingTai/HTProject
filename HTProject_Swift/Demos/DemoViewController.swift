//
//  DemoViewController.swift
//  SwiftDemos
//
//  Created by heming on 17/2/28.
//  Copyright © 2017年 Mr.Tai. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var dataArray = ["无限轮播","地图标注","图片选择器","获取系统权限","跑马灯","缩放动画","弹性动画"]
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "SwiftDemos"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(tableView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(longPressAction(longPressGesture:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1
        tableView.addGestureRecognizer(longPress)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        if indexPath.row == 0 {
            let bannerView = TopBannerView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 253))
            //要先设置时间间隔才能自动滚动
            bannerView.autoScrollTimeInterval = 5
            bannerView.enableAutoScroll = true
            cell.contentView.addSubview(bannerView)
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 253
        }
        return 60
    }
    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: break
        case 1:
            let aMapVc = AnnotationViewController()
            self.navigationController?.pushViewController(aMapVc, animated: true)
        case 2:
            let cImgVc = ChooseImageViewController()
            self.navigationController?.pushViewController(cImgVc, animated: true)
        case 3:
            let saVc = SetAuthorizationViewController()
            self.navigationController?.pushViewController(saVc, animated: true)
        case 4:
            let hrlVc = HorseRaceLampViewController()
            self.navigationController?.pushViewController(hrlVc, animated: true)
        case 5:
            let scVc = ScaleViewController()
            self.navigationController?.pushViewController(scVc, animated: true)
        case 6:
            let spVc = SpringViewController()
            self.navigationController?.pushViewController(spVc, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row as Int
            dataArray .remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .normal, title: "More") { (UITableViewRowAction, NSIndexPath) in
            let shareMenu = UIAlertController(title: nil, message: "Share Using", preferredStyle: .actionSheet)
            let QQAction = UIAlertAction(title:"QQ",style:.default,handler: nil)
            let WeixinAction = UIAlertAction(title: "Weixin", style: .default, handler: nil)
            shareMenu.addAction(QQAction)
            shareMenu.addAction(WeixinAction)
            self.present(shareMenu,animated:true, completion:nil)
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (UITableViewRowAction, NSIndexPath) in
            let index = indexPath.row as Int
            self.dataArray .remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction,shareAction]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func longPressAction(longPressGesture:UILongPressGestureRecognizer) {
        if longPressGesture.state == UIGestureRecognizer.State.ended {
            if tableView.isEditing == false {
                tableView.setEditing(true, animated: true)
            }
            else {
                tableView.setEditing(false, animated: true)
            }
        }
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
}

