//
//  RootPageViewController.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 28.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import CHIPageControl

class RootViewController: UIViewController {
    
    private var pageViewController: UIPageViewController!
    private var pageViewControllerScrollView: UIScrollView!
    private var pageControl: CHIPageControlAleppo!
    private var currentPageIndex: Int = 1

    private var lecturesViewController: LecturesViewController!
    private lazy var recordViewController: RecordViewController = {
        return UIStoryboard.init(name: "Record", bundle: nil).instantiateInitialViewController()
        }() as! RecordViewController
    private var dailySummaryViewController: DailySummaryViewController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lecturesViewController = UIStoryboard(name: "Lectures", bundle: nil).instantiateInitialViewController() as? LecturesViewController
        dailySummaryViewController = UIStoryboard(name: "Summary", bundle: nil).instantiateInitialViewController() as? DailySummaryViewController
        
        let pageControlHeight: CGFloat = 10
        let pageControlWidth: CGFloat = 200
        let pageControlFrame = CGRect(x: (view.bounds.size.width - pageControlWidth) / 2.0, y: 45, width: pageControlWidth, height: pageControlHeight)
        pageControl = CHIPageControlAleppo(frame: pageControlFrame)
        pageControl.numberOfPages = 3
        pageControl.padding = 12
        pageControl.radius = pageControlHeight / 2
        pageControl.tintColors = [UIColor(white: 0.1, alpha: 1), UIColor.white, UIColor(white: 0.1, alpha: 1)]
        pageControl.currentPageTintColor = UIColor(rgb: 0x3D7BFF)
        pageControl.set(progress: 1, animated: false)
        view.addSubview(pageControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pageViewController") {
            pageViewController = segue.destination as? UIPageViewController
            setupPageViewController()
        }
    }
        
    // MARK: Setup User Interface

    private func setupPageViewController() {
        pageViewController.setViewControllers([recordViewController], direction: .forward, animated: true, completion: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewControllerScrollView = pageViewController.view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
        pageViewControllerScrollView.delegate = self
    }
}

//MARK: Page View Controller Delegate & Data Source

extension RootViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController == recordViewController) {
            return lecturesViewController
        } else if (viewController == dailySummaryViewController) {
            return recordViewController
        }
        
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController == lecturesViewController) {
            return recordViewController
        } else if (viewController == recordViewController) {
            return dailySummaryViewController
        }
        
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (finished) {
            guard let currentVC = pageViewController.viewControllers?.first else { return }
            if (currentVC == lecturesViewController) {
                pageControl.tintColors = [UIColor.white,UIColor.white,UIColor.white ]
                pageControl.currentPageTintColor = UIColor.white
                currentPageIndex = 0
            } else if (currentVC == recordViewController) {
                pageControl.tintColors = [UIColor.black,UIColor.black,UIColor.black ]
                pageControl.currentPageTintColor = UIColor(rgb: 0x3D7BFF)
                currentPageIndex = 1
            } else if (currentVC == dailySummaryViewController) {
                pageControl.tintColors = [UIColor.white,UIColor.white,UIColor.white ]
                pageControl.currentPageTintColor = UIColor.white
                currentPageIndex = 2
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == pageViewControllerScrollView) {
            let contentOffsetX = scrollView.contentOffset.x
            let width = view.bounds.size.width
            let normalizedOffset = contentOffsetX - width
            let progress = normalizedOffset / width
            pageControl.progress = Double(currentPageIndex) + Double(progress)
            
            if (contentOffsetX > width) {
                view.backgroundColor = UIColor(rgb: 0x479FD7) // blue
            } else {
                view.backgroundColor = UIColor(rgb: 0xFAB943) // orange
            }
            
            guard let currentVC = pageViewController.viewControllers?.first else { return }

            if (currentVC == dailySummaryViewController) {
                if (contentOffsetX > width - width * 0.5) {
                    pageControl.tintColors = [UIColor.white,UIColor.white,UIColor.white ]
                    pageControl.currentPageTintColor = UIColor.white
                } else {
                    pageControl.tintColors = [UIColor.black,UIColor.black,UIColor.black ]
                    pageControl.currentPageTintColor = UIColor(rgb: 0x3D7BFF)
                }
            } else if (currentVC == lecturesViewController) {
                if (contentOffsetX > width + width * 0.5) {
                    pageControl.tintColors = [UIColor.black,UIColor.black,UIColor.black ]
                    pageControl.currentPageTintColor = UIColor(rgb: 0x3D7BFF)
                } else {
                    pageControl.tintColors = [UIColor.white,UIColor.white,UIColor.white ]
                    pageControl.currentPageTintColor = UIColor.white
                }
            }

        }
    }
}
