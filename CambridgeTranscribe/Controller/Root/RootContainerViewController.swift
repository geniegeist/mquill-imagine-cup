//
//  RootPageViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 28.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

private struct CONSTANTS {
    enum TabBarHeight: CGFloat {
        case large = 190
        case small = 140
    }
    
    static let TabBarColorGrey = UIColor.init(white: 0.8, alpha: 0.8)
}

private struct Page {
    let viewController: UIViewController
    let isInitial: Bool
    var backgroundView: UIView? {
        get {
            if let block = _backgroundViewBlock {
                return block()
            }
            return _backgroundView
        }
    }
    var tabBarHeight: CGFloat
    var tabBarColor: UIColor
    
    // Private
    
    private let _backgroundView: UIView?
    private let _backgroundViewBlock: (() -> UIView)?
    
    init(viewController: UIViewController,
         backgroundView: UIView? = nil,
         backgroundViewBlock: (() -> UIView)? = nil,
         isInitial: Bool = false,
         tabBarHeight: CGFloat = CONSTANTS.TabBarHeight.small.rawValue,
         tabBarColor: UIColor = UIColor.white) {
        self.viewController = viewController
        _backgroundView = backgroundView
        _backgroundViewBlock = backgroundViewBlock
        self.isInitial = isInitial
        self.tabBarHeight = tabBarHeight
        self.tabBarColor = tabBarColor
    }
}

class RootContainerViewController: UIViewController {
    
    @IBOutlet private weak var tabBarHeightConstraint: NSLayoutConstraint!
    private var snapChatTabBarController: TabBarController!
    private var pageViewController: UIPageViewController!
    
    private var backgroundView: UIView?
    
    private let pages = [Page(viewController: UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "classesVC"),
                              backgroundView: UIView.whiteView(),
                              tabBarColor: CONSTANTS.TabBarColorGrey),
                         Page(viewController: UIStoryboard.init(name: "Record", bundle: nil).instantiateInitialViewController()!,
                              backgroundViewBlock: {() in
                                let view = ColorfulShiftView()
                                view.startTimedAnimation()
                                return view
                              },
                              isInitial: true,
                              tabBarHeight: CONSTANTS.TabBarHeight.large.rawValue),
                         Page(viewController: CBChatbotViewController(),
                              backgroundView: UIView.colorView(UIColor.black),
                              tabBarColor: CONSTANTS.TabBarColorGrey)];
    private var recordViewController: RecordContainerViewController {
        get {
            return pages[1].viewController as! RecordContainerViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView?.frame = view.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tabBar") {
            snapChatTabBarController = segue.destination as? TabBarController
            setupSnapChatTabBarController()
        } else if (segue.identifier == "pageViewController") {
            pageViewController = segue.destination as? UIPageViewController
            setupPageViewController()
        }
    }
    
    // MARK: Setup User Interface
    
    private func setupSnapChatTabBarController() {
        snapChatTabBarController.tabBarView.didTapRecordTabBarItemBlock = {tabBarView in
            // purely visual
            tabBarView.isRecording = !tabBarView.isRecording
            self.recordViewController.record()
        }
        
        snapChatTabBarController.tabBarView.didTapLeftTabBarItemBlock = {tabBarView in
            self.pageViewController.setViewControllers([self.pages[0].viewController], direction: .reverse, animated: true, completion: nil)
            self.pageViewControllerDidTransition(self.pageViewController)
        }
        
        snapChatTabBarController.tabBarView.didTapRightTabBarItemBlock = { tabBarView in
            self.pageViewController.setViewControllers([self.pages[2].viewController], direction: .forward, animated: true, completion: nil)
            self.pageViewControllerDidTransition(self.pageViewController)
        }
    }
    
    private func setupPageViewController() {
        guard let initialPage = pages.first(where: {$0.isInitial}) else {
            assertionFailure("Initial view controller is not set")
            return
        }

        pageViewController.setViewControllers([initialPage.viewController], direction: .forward, animated: true, completion: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let backgroundView = initialPage.backgroundView {
            backgroundView.frame = view.bounds
            view.insertSubview(backgroundView, at: 0)
            self.backgroundView = backgroundView
        }
        
        // adjust tabBarHeight
        tabBarHeightConstraint.constant = initialPage.tabBarHeight
    }
    
    // MARK: User Interface State Events
    
    private func pageViewControllerDidTransition(_ pageViewController: UIPageViewController) {
        guard let currentVC = pageViewController.viewControllers?.first, let currentPage = pages.first(where: {$0.viewController == currentVC}) else {
            return
        }
        
        // do something with currentPage
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.tabBarHeightConstraint.constant = currentPage.tabBarHeight
            self.snapChatTabBarController.color = currentPage.tabBarColor
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: Page View Controller Delegate & Data Source

extension RootContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(where: { $0.viewController == viewController }), index > 0 {
            return pages[index-1].viewController
        }
        
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(where: { $0.viewController == viewController }), index < pages.count - 1 {
            return pages[index+1].viewController
        }
        
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            pageViewControllerDidTransition(pageViewController)
        }
    }
}

private extension UIView {
    class func whiteView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    class func colorView(_ color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}
