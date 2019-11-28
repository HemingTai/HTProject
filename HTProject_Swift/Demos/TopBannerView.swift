//
//  HomeBannerView.swift
//  TestSwift
//
//  Created by heming on 16/7/26.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

import Foundation
import UIKit

enum Direction
{
    case DirectionLeft    //向左滑
    case DirectionRight   //向右滑
    case DirectionNone    //未滑动
}

class TopBannerView: UIView,UIScrollViewDelegate
{
    var autoScrollTimeInterval:TimeInterval?               //自动滚动时间间隔
    var scrollView            :UIScrollView?               //滚动视图
    var imgWidth              :CGFloat?                    //图片宽度
    var imgHeight             :CGFloat?                    //图片高度
    var pageControl           :UIPageControl?              //分页控制器
    var currentView           :UIImageView?                //当前视图
    var nextView              :UIImageView?                //下一视图
    var currentIndex          :NSInteger?                  //当前索引
    var nextIndex             :NSInteger?                  //下一索引
    var ADsArray              :[UIColor]?                  //图片数组
    var timer                 :Timer?                      //定时器
    var enableAutoScroll:Bool = true                       //自动滚动
    {
        didSet
        {
            if enableAutoScroll
            {
                self.startTimer()
            }
        }
    }
    var direction : Direction = .DirectionNone  //滚动方向
    {
        //设置新值之前
        willSet
        {
            if newValue == direction
            {
                return
            }
        }
        //设置新值之后
        didSet
        {
            //向右滚动
            if direction == .DirectionRight
            {
                nextView?.frame = CGRect(x: 0, y: 0, width: imgWidth!, height: imgHeight!)
                nextIndex = currentIndex!-1
                if nextIndex! < 0
                {
                    nextIndex = (ADsArray?.count)! - 1
                }
            }
            //向左滚动
            if direction == .DirectionLeft
            {
                nextView?.frame = CGRect(x: 2*imgWidth!, y: 0, width: imgWidth!, height: imgHeight!)
                nextIndex = (currentIndex!+1) % (ADsArray?.count)!
            }
            nextView?.backgroundColor = ADsArray![nextIndex!]
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        imgWidth  = frame.size.width
        imgHeight = frame.size.height
        
        scrollView = UIScrollView(frame: frame)
        scrollView?.delegate = self
        scrollView?.isPagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.contentSize = CGSize(width: 3*imgWidth!, height: imgHeight!)
        scrollView?.contentOffset = CGPoint(x: imgWidth!, y: 0)
        self.addSubview(scrollView!)
        
        currentView = UIImageView(frame: CGRect(x: imgWidth!, y: 0, width: imgWidth!, height: imgHeight!))
        scrollView?.addSubview(currentView!)
        
        nextView = UIImageView(frame: CGRect(x: 2*imgWidth!, y: 0, width: imgWidth!, height: imgHeight!))
        scrollView?.addSubview(nextView!)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: imgHeight!-20, width: imgWidth!, height: 20))
        pageControl?.hidesForSinglePage = true
        pageControl?.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pageControl?.currentPageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.2)
        self.addSubview(pageControl!)
        
        ADsArray = [UIColor.orange,UIColor.lightGray,UIColor.red,UIColor.blue,UIColor.purple]
        currentView?.backgroundColor = ADsArray![0]
        currentIndex = 0
        nextIndex = 0
        pageControl?.currentPage = currentIndex!
        pageControl?.numberOfPages = (ADsArray?.count)!
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        if timer != nil
        {
            if timer!.isValid
            {
                timer?.invalidate()
            }
            timer = nil
        }
    }
    
    /// 开启定时器
    func startTimer()
    {
        self.stopTimer()
        if (ADsArray?.count)! > 1
        {
            timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval!, target: self, selector: #selector(self.nextImage), userInfo: nil, repeats: true)
        }
        else
        {
            return
        }
    }
    
    /// 关闭定时器
    func stopTimer()
    {
        if timer != nil && (timer?.isValid)!
        {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 滚动到下一张图片
    @objc func nextImage()
    {
        scrollView?.setContentOffset(CGPoint(x: imgWidth!*2, y: 0), animated: true)
    }
    
    //MARK: -----UIScrollViewDelegate-----
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetX = scrollView.contentOffset.x;
        self.direction = offsetX > imgWidth! ? .DirectionLeft : offsetX < imgWidth! ? .DirectionRight : .DirectionNone
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.pauseScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        self.pauseScroll()
    }
    
    //开始拖拽时停止定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        self.stopTimer()
    }
    
    //拖拽结束后开启定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        self.startTimer()
    }
    
    ///停止滚动
    func pauseScroll()
    {
        let offset = self.scrollView!.contentOffset.x;
        let index = offset / self.imgWidth!
        //1表示没有滚动
        if index == 1
        {
            return
        }
        self.currentIndex = self.nextIndex
        self.pageControl?.currentPage = self.currentIndex!
        self.currentView?.frame = CGRect(x: self.imgWidth!, y: 0, width: self.imgWidth!, height: self.imgHeight!)
        self.currentView?.backgroundColor = self.nextView?.backgroundColor
        self.scrollView?.contentOffset = CGPoint(x: imgWidth!, y: 0)
    }
}
