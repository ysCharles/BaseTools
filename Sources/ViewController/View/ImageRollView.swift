//
//  ImageRollView.swift
//  smk
//
//  Created by Charles on 24/02/2017.
//  Copyright © 2017 Matrix. All rights reserved.
//

import UIKit


/// 滚动图片控件
public class ImageRollView: UIView {
    //放置imageView的滚动视图
    fileprivate var scrollView: UIScrollView?
    //页控制器（小圆点）
    fileprivate var pageControl: UIPageControl?
    //数据源
    fileprivate var dataSource: [String]?
    //自动滚动时间
    private var time: TimeInterval = 3
    
    //scrollView的宽和高
    fileprivate var scrollViewWidth: CGFloat?
    fileprivate var scrollViewHeight: CGFloat?
    
    //自动滚动计时器
    fileprivate var autoScrollTimer: Timer?
    
    /// 创建图片滚动器
    ///
    /// - Parameters:
    ///   - frame: 尺寸 frame
    ///   - imagesArr: 图片数组
    public init(frame: CGRect, imagesArr: [String]) {
        super.init(frame: frame)
        
        //获取并设置scrollerView尺寸
        self.scrollViewWidth = frame.width
        self.scrollViewHeight = frame.height
        
        //获取数据
        self.dataSource =  imagesArr
        //设置scrollerView
        self.configScrollView()
        //设置imageView
        self.configImageView()
        //设置页控制器
        self.configPageController()
        if imagesArr.count > 1 {
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
        self.scrollView?.contentSize = CGSize(width: self.scrollViewWidth! * CGFloat((self.dataSource?.count)!), height: self.scrollViewHeight!)
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.showsVerticalScrollIndicator = false
        //滚动视图内容区向左偏移一个 view 的宽度
        self.scrollView?.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.bounces = false
        self.addSubview(self.scrollView!)
    }
    
    //设置imageView
    private func configImageView(){
        //设置初始时左中右三个imageView的图片（分别时数据源中最后一张，第一张，第二张图片）
        if(self.dataSource?.count != 0){
            let count = (self.dataSource?.count)!
            for index in 0 ..< count {
                let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * self.scrollViewWidth!, y: 0, width: self.scrollViewWidth!, height: self.scrollViewHeight!))
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = UIImage(named: (self.dataSource?[index])!)
                self.scrollView?.addSubview(imageView)
            }
        }else{
            // 如果没有图片，站位图
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.scrollViewWidth!, height: self.scrollViewHeight!))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "img_05")
            self.scrollView?.addSubview(imageView)
        }
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
        //滚动一张图片的距离
        let offsetX = (scrollView?.contentOffset.x)! + scrollViewWidth!
        let offset = CGPoint(x: offsetX, y: 0)
        self.scrollView?.setContentOffset(offset, animated: true)
    }
}


// MARK: - UIScrollViewDelegate
extension ImageRollView: UIScrollViewDelegate {
    
    //scrollView滚动完毕后触发
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataSource?.count != 0) {
            let page = Int(offset / scrollViewWidth!)
            
            if page == (self.dataSource?.count)! - 1 { //到了最后一张停止自动滚动
                autoScrollTimer?.invalidate()
            }
            
            //设置页控制器当前页码
            self.pageControl?.currentPage = page
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
        // 如果已经到滚动到过最后 不要在启动定时器 否则 需要重新启动定时器
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        if(self.dataSource?.count != 0) {
            let page = Int(offset / scrollViewWidth!)
            
            if page != (self.dataSource?.count)! - 1 {
                configAutoScrollTimer()
            }
        }
        
    }
}
