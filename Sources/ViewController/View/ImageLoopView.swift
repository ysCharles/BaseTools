//
//  ImageLoopView.swift
//  smk
//
//  Created by Charles on 23/02/2017.
//  Copyright © 2017 Matrix. All rights reserved.
//

import UIKit

/// 图片轮播组件代理协议
public protocol ImageLoopViewDelegate {
    //获取数据源
    func handleTapAction(index: Int)->Void
}


/// 循环滚动图片控件
public class ImageLoopView: UIView {
    //代理对象
    public var delegate: ImageLoopViewDelegate?
    
    //屏幕宽度
    private let kScreenWidth = SCREEN_WIDTH
    
    private var time: TimeInterval = 3
    
    //当前展示的图片索引
    fileprivate var currentIndex: Int = 0
    
    //数据源
    fileprivate var dataSource: [String]?
    
    //用于轮播的左中右三个 imageView （不管几张图片都是三个 imageview 交替使用）
    private var leftImageView , middleImageView , rightImageView : UIImageView?
    
    //放置imageView的滚动视图
    private var scrollView: UIScrollView?
    
    //scrollView的宽和高
    fileprivate var scrollViewWidth : CGFloat?
    fileprivate var scrollViewHeight : CGFloat?
    
    //页控制器（小圆点）
    fileprivate var pageControl : UIPageControl?
    
    //自动滚动计时器
    fileprivate var autoScrollTimer:Timer?
    
    
    /// 刷新图片 重新加载数据
    ///
    /// - Parameter imageArr: 图片数据源
    public func reloadData(imageArr: [String]) {
        //获取数据
        self.dataSource = imageArr
        //设置imageView
        self.configImageView()
        //设置页控制器
        self.configPageController()
        if imageArr.count > 1 {
            //设置自动滚动计时器
            self.configAutoScrollTimer()
        }else{
            self.scrollView?.isScrollEnabled = false
        }
    }
    
    
    /// 创建图片轮播器
    ///
    /// - Parameters:
    ///   - frame: 尺寸 frame
    ///   - ImagesArr: 图片数组
    public init(frame: CGRect, ImagesArr:[String]) {
        super.init(frame: frame)
        
        //获取并设置scrollerView尺寸
        self.scrollViewWidth = frame.width
        self.scrollViewHeight = frame.height
        
        //获取数据
        self.dataSource =  ImagesArr
        //设置scrollerView
        self.configScrollView()
        //设置imageView
        self.configImageView()
        //设置页控制器
        self.configPageController()
        if ImagesArr.count > 1 {
            //设置自动滚动计时器
            self.configAutoScrollTimer()
        }else{
            self.scrollView?.isScrollEnabled = false
        }
        self.backgroundColor = UIColor.gray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 配置控件 私有方法
    /// 设置 scrollView
    private func configScrollView() {
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.scrollViewWidth!, height: self.scrollViewHeight!))
        self.scrollView?.delegate = self
        self.scrollView?.contentSize = CGSize(width: self.scrollViewWidth! * 3, height: self.scrollViewHeight!)
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.showsVerticalScrollIndicator = false
        //滚动视图内容区向左偏移一个 view 的宽度
        self.scrollView?.contentOffset = CGPoint(x: self.scrollViewWidth!, y: 0)
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.bounces = false
        self.addSubview(self.scrollView!)
    }
    
    //设置imageView
    private func configImageView(){
            self.leftImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                           width: self.scrollViewWidth!, height: self.scrollViewHeight!))
            self.middleImageView = UIImageView(frame: CGRect(x: self.scrollViewWidth!, y: 0,
                                                             width: self.scrollViewWidth!, height: self.scrollViewHeight! ));
            self.rightImageView = UIImageView(frame: CGRect(x: 2*self.scrollViewWidth!, y: 0,
                                                            width: self.scrollViewWidth!, height: self.scrollViewHeight!));
            
            self.leftImageView?.contentMode = .scaleAspectFill //保持图片比例不变，填充整个 imageview，可能只显示部分图片
            self.leftImageView?.clipsToBounds = true //图片超出部分剪掉
            self.middleImageView?.contentMode = .scaleAspectFill
            self.middleImageView?.clipsToBounds = true
            self.rightImageView?.contentMode = .scaleAspectFill
            self.rightImageView?.clipsToBounds = true
            
            //设置初始时左中右三个imageView的图片（分别时数据源中最后一张，第一张，第二张图片）
            if(self.dataSource?.count != 0){
                self.touchViewAction()
                resetImageViewSource()
            }else{
                // 如果没有图片，站位图
                self.middleImageView?.image = UIImage(named: "img_05")
            }
            
            self.scrollView?.addSubview(self.leftImageView!)
            self.scrollView?.addSubview(self.middleImageView!)
            self.scrollView?.addSubview(self.rightImageView!)
        
    }
    
    //设置页控制器
    private func configPageController() {
        self.pageControl = UIPageControl(frame: CGRect(x: self.scrollViewWidth!/2-60,
                                                       y: self.scrollViewHeight! - 20, width: 120, height: 20))
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.isUserInteractionEnabled = false
        
        if (dataSource?.count)! < 2 {
            pageControl?.isHidden = true
        }
        
        self.addSubview(self.pageControl!)
    }
    
    //设置自动滚动计时器
    func configAutoScrollTimer() {
        
        //设置一个定时器，每time秒钟滚动一次
        autoScrollTimer = Timer.scheduledTimer(timeInterval: time, target: self,
                                               selector: #selector(letItScroll),
                                               userInfo: nil, repeats: true)
    }
    
    //计时器时间一到，滚动一张图片
    @objc func letItScroll(){
        let offset = CGPoint(x: 2*scrollViewWidth!, y: 0)
        self.scrollView?.setContentOffset(offset, animated: true)
    }
    
    //每当滚动后重新设置各个imageView的图片
    func resetImageViewSource() {
        //当前显示的是第一张图片
        if self.currentIndex == 0 {
            self.leftImageView?.image = UIImage(named: self.dataSource!.last!)
            self.middleImageView?.image = UIImage(named: self.dataSource!.first!)
            let rightImageIndex = (self.dataSource?.count)!>1 ? 1 : 0 //保护
            self.rightImageView?.image = UIImage(named: self.dataSource![rightImageIndex])
        }
            //当前显示的是最后一张图片
        else if self.currentIndex == (self.dataSource?.count)! - 1 {
            self.leftImageView?.image = UIImage(named: self.dataSource![self.currentIndex-1])
            self.middleImageView?.image = UIImage(named: self.dataSource!.last!)
            self.rightImageView?.image = UIImage(named: self.dataSource!.first!)
        }
            //其他情况
        else{
            self.leftImageView?.image = UIImage(named: self.dataSource![self.currentIndex-1])
            self.middleImageView?.image = UIImage(named: self.dataSource![self.currentIndex])
            self.rightImageView?.image = UIImage(named: self.dataSource![self.currentIndex+1])
        }
    }
    
    private func touchViewAction(){
        //添加组件的点击事件
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleTapAction(_:)))
        self.addGestureRecognizer(tap)
    }
    //点击事件响应
    @objc func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
        if let dele = self.delegate {
            dele.handleTapAction(index: self.currentIndex)
        }
        
    }
}

extension ImageLoopView: UIScrollViewDelegate {
    //scrollView滚动完毕后触发
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataSource?.count != 0){
            
            //如果向左滑动（显示下一张）
            if(offset >= self.scrollViewWidth!*2){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollViewWidth!, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }
            
            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollViewWidth!, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }
            
            //重新设置各个imageView的图片
            resetImageViewSource()
            //设置页控制器当前页码
            self.pageControl?.currentPage = self.currentIndex
        }
    }
    
    //手动拖拽滚动开始
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //使自动滚动计时器失效（防止用户手动移动图片的时候这边也在自动滚动）
        autoScrollTimer?.invalidate()
    }
    
    //手动拖拽滚动结束
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        //重新启动自动滚动计时器
        configAutoScrollTimer()
        
    }
}
