//
//  JSGuideController.swift
//  GuideDemo
//
//  Created by Jesson on 2017/4/19.
//  Copyright © 2017年 Jesson. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

enum GuideType {
    case video //视频
    case picture //图片
}

class JSGuideController: UIViewController {
    
    fileprivate var type:GuideType?
    fileprivate var videoPath:String?
    fileprivate var pictures:[String]?
    
    fileprivate var playerLayer:AVPlayerLayer?
    fileprivate var player:AVPlayer?
    fileprivate var playeItem:AVPlayerItem?
    fileprivate var scrollView:UIScrollView?
    
    fileprivate var enterBtn:UIButton?
    
    fileprivate var pageCtr:UIPageControl?
    
    fileprivate var pushViewController:UIViewController?
    
    fileprivate var presentAnimator:JSPresentAnimator?
    
    /// 初始化该引导页视图，
    ///
    /// - Parameters:
    ///   - guideType: 是视频还是图片
    ///   - picture: 如果是图片，这里传入图片数组，如果是视频，这里传入nil
    ///   - videoPath: 如果是视频，这里传入视频地址，如果是图片，这里传入nil
    ///   - pushViewController: 点击进入按钮展示的页面
    convenience init(guide:GuideType, pictures:[String]?,videoPath:String?,pushViewController:UIViewController?) {
        self.init()
        self.type = guide
        self.pushViewController = pushViewController
        if pictures != nil {
            self.pictures = pictures
        }
        if videoPath != nil {
            self.videoPath = videoPath
        }
        pushViewController?.transitioningDelegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        self.view.backgroundColor = UIColor.white
        switch self.type! {
        case .video:
            self.videoSetUI()
            break
        case .picture:
            self.pictureSetUI()
            break
        default: break
        }
    }
}

extension JSGuideController{
    
    /// 设置是图片的UI界面
    func pictureSetUI(){
        self.scrollView = UIScrollView.init(frame: self.view.bounds)
        self.scrollView?.contentSize = CGSize.init(width: self.view.frame.size.width * CGFloat(self.pictures!.count), height: self.view.bounds.height)
        self.scrollView?.isUserInteractionEnabled = true
//        self.scrollView?.bounces = false
        self.scrollView?.delegate = self
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.isPagingEnabled = true
        for (index,value) in self.pictures!.enumerated() {
            let imageView:UIImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(index) * self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            imageView.isUserInteractionEnabled = true
            if index == self.pictures!.count-1 {
                //左划
                let swipeLeftGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(leftGesAction))
                swipeLeftGesture.direction = .left
                imageView.addGestureRecognizer(swipeLeftGesture)
            }
            imageView.image = UIImage.init(named: value)
            self.scrollView?.addSubview(imageView)
        }
        self.view .addSubview(self.scrollView!)
        self.pageCtr = UIPageControl.init(frame: CGRect.init(x: (self.view.frame.size.width - 100)/2, y: self.view.frame.size.height - 20 - 20 , width: 100, height: 20))
        self.pageCtr!.currentPage = 0
        self.pageCtr!.numberOfPages = self.pictures!.count
        //设置选中的颜色
        self.pageCtr!.currentPageIndicatorTintColor = UIColor.red
        //设置没有选中的颜色
        self.pageCtr!.pageIndicatorTintColor = UIColor.brown
        self.view.addSubview(self.pageCtr!)
        self.createEnterBtn()
    }
    /// 设置是视屏的UI界面
    func videoSetUI(){
        let videoUrl:URL = URL.init(fileURLWithPath: self.videoPath!)
        self.playeItem = AVPlayerItem.init(url: videoUrl)
        self.player = AVPlayer.init(playerItem: self.playeItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer!.frame = self.view.bounds
        self.view.layer.addSublayer(self.playerLayer!)
        self.player!.play()
        //监听播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(playItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playeItem)
        self.createEnterBtn()
        UIView.animate(withDuration: 1.0) {
            self.enterBtn?.alpha = 1
        }
    }
    
    func createEnterBtn(){
        self.enterBtn = UIButton.init(type: UIButtonType.custom)
        self.enterBtn?.setTitle("点击进入", for: .normal)
        self.enterBtn?.setTitleColor(UIColor.lightGray, for: .normal)
        self.enterBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.enterBtn?.frame = CGRect.init(x: (self.view.frame.size.width-100)/2, y: self.view.frame.size.height - 49 - 30, width: 100, height: 30)
        self.enterBtn?.alpha = 0
        self.enterBtn?.addTarget(self, action: #selector(enterBtnAciton), for: .touchUpInside)
        self.view.addSubview(self.enterBtn!)
        self.enterBtn?.layer.cornerRadius = 15
        self.enterBtn?.layer.borderWidth = 0.8
        self.enterBtn?.layer.borderColor = UIColor.red.cgColor
    }
    
    func playItemDidReachEnd(){
        print("视频播放结束了")
        //进行循环播放
        self.player?.seek(to: CMTime.init(value: 0, timescale: 1))
        self.player?.play()
    }
    
    func leftGesAction(){
        print("最后张左划了")
        self.enterBtnAciton()
    }
    
    /// enterBtn的事件
    func enterBtnAciton(){
        print("点击enter")
        self.presentAnimator = JSPresentAnimator()
        self.presentAnimator!.originFrame = self.view.frame
        self.presentAnimator!.originVc = self
        if self.type == GuideType.picture {
             self.present(self.pushViewController!, animated: true, completion: nil)
        }else{
            self.present(self.pushViewController!, animated: true, completion: {
                //清理播放的内存资源
                self.playerLayer?.removeFromSuperlayer()
                self.playerLayer=nil;
                self.player=nil;
            })
        }
    }
}

extension JSGuideController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageCtr?.currentPage = Int(scrollView.contentOffset.x/self.view.frame.size.width)
        if scrollView.contentOffset.x == CGFloat(self.pictures!.count-1)*self.view.frame.size.width {
            UIView.animate(withDuration: 0.5, animations: {
                self.enterBtn?.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: { 
                self.enterBtn?.alpha = 0
            })
            if scrollView.contentOffset.x > CGFloat(self.pictures!.count-1)*self.view.frame.size.width+20 {
                self.enterBtnAciton()
            }
        }
    }
}

extension JSGuideController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentAnimator
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

