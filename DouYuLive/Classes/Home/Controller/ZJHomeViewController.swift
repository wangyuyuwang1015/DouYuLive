//
//  ZJHomeViewController.swift
//  DouYuLive
//
//  Created by 邓志坚 on 2018/7/25.
//  Copyright © 2018年 邓志坚. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

private let kTitleH : CGFloat = 40

class ZJHomeViewController: ZJBaseViewController {
    
    private lazy var titles : [String] = ["分类","推荐","全部","LoL","绝地求生","王者荣耀","QQ飞车"]
    private lazy var pageTitleView : ZJPageTitleView = { [weak self] in
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: kTitleH)
        let pageTitleViw = ZJPageTitleView(frame: frame, titles: titles)
        pageTitleViw.delegate = self
        return pageTitleViw
    }()
    
    private lazy var pageContenView : ZJPageContentView = { [weak self] in
        let height : CGFloat = kScreenH - kStatuHeight - kNavigationBarHeight - kTitleH - kTabBarHeight
        let frame = CGRect(x: 0, y: 40, width: kScreenW, height: height)
        var childVCs : [UIViewController] =  [ZJClassifyViewController(),ZJRecommendViewController(),ZJAllViewController(),ZJLOLViewController(),ZJJDQSViewController(),ZJWZRYViewController(),ZJQQCarViewController()]
        let contentView = ZJPageContentView(frame: frame, childVCs: childVCs, parentViewController:self!)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        setUpUI()
        
        ZJNetWorking.requestData(type: .POST, URlString: ZJSignAppURL, parameters: nil) { (response) in
            print(response)
        }
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 设置背景渐变
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        //设置frame和插入view的layer
//        gradientLayer.frame = bounds
//        self.navigationController?.navigationBar..insertSublayer(gradientLayer, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




// MARK: - 遵守PageTitleViewDelegate协议
extension ZJHomeViewController : PageTitleViewDelegate {
    
    func pageTitleView(titleView: ZJPageTitleView, selectedIndex index: Int) {
        pageContenView.setCurrentIndex(currentIndex: index)
    }
}


// MARK: - 遵守PageContentViewDelegate协议
extension ZJHomeViewController : PageContentViewDelegate{
    func pageContentView(contentView: ZJPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setPageTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


// MARK - 配置子控件
extension ZJHomeViewController {
    
    // 配置 UI
    func setUpUI(){
        
        // 不需要调整 scrollview 的内边距
        automaticallyAdjustsScrollViewInsets = false
        // 添加导航栏
        setUpNavigation()
        // 添加标题栏
        setUpPageTitleView()
        
        // 添加 ContentView
        view.addSubview(pageContenView)
    }
    
    // 配置 NavigationBar
    func setUpNavigation() -> Void {
        // 修改状态栏背景颜色
        self.navigationController?.navigationBar.barTintColor = MainOrangeColor
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let size = CGSize(width: 30, height: 30)
        // 左边的按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(norImageName: "home_newSaoicon", size: size)
        // 右边的按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_history"), style:.done, target: self, action: #selector(self.rightItemClick)) //UIBarButtonItem.createBarButton("search_history", "search_history", size)
        
        let searchView  = ZJHomeSearchView()
        searchView.layer.cornerRadius = 5
        searchView.backgroundColor = SearchBGColor
        navigationItem.titleView = searchView
        searchView.snp.makeConstraints { (make) in
            make.center.equalTo((navigationItem.titleView?.snp.center)!)
            make.width.equalTo(AdaptW(230))
            make.height.equalTo(33)
        }
    }
    
    func setUpPageTitleView() {
        
        self.view.addSubview(pageTitleView)
        
    }
    
    @objc func rightItemClick() {
        print("rightItem cLick")
    }
    
    
}



