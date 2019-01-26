//
//  ViewController.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 19.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "ViewController.h"
#import "CBRecordViewController.h"
#import "CBClassesViewController.h"
#import "CBChatbotViewController.h"
#import "CBTabBar.h"
#import <Shift/Shift-umbrella.h>

@interface ViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, CBTabBarDelegate>
@property (nonatomic, copy) NSString *serviceRegion;
@property (nonatomic, copy) NSString *speechKey;

@property (nonatomic, strong) ShiftView_Objc *shiftView;
@property (nonatomic, strong) CBTabBar *tabBar;

@property (nonatomic, strong) CBRecordViewController *recordVC;
@property (nonatomic, strong) CBClassesViewController *classesVC;
@property (nonatomic, strong) CBChatbotViewController *chatbotVC;

@property (nonatomic, strong) UIPageViewController *pageVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serviceRegion = @"westus";
    self.speechKey = @"e508068e871a45e881a58543354061ff";
    
    // View
    
    ShiftView_Objc *shiftView = [[ShiftView_Objc alloc] initWithFrame:self.view.bounds];
    [shiftView setColors:@[
                           [UIColor colorWithRed:156/255.0 green:39.0/255.0 blue:176.0/255.0 alpha:1],
                           [UIColor colorWithRed:255/255.0 green:64/255.0 blue:129.0/255.0 alpha:1],
                           [UIColor colorWithRed:123/255.0 green:31.0/255.0 blue:162.0/255.0 alpha:1],
                           [UIColor colorWithRed:32/255.0 green:76.0/255.0 blue:255.0/255.0 alpha:1],
                           [UIColor colorWithRed:32/255.0 green:158.0/255.0 blue:255.0/255.0 alpha:1],
                           [UIColor colorWithRed:90/255.0 green:120.0/255.0 blue:127.0/255.0 alpha:1],
                           [UIColor colorWithRed:58/255.0 green:255.0/255.0 blue:217.0/255.0 alpha:1],
                           ]];
    shiftView.backgroundColor = [UIColor redColor];
    [shiftView startTimedAnimation];
    // [self.view addSubview:shiftView];
    self.shiftView = shiftView;
    self.view = self.shiftView;

    
    // PageView
    
    self.recordVC = [[CBRecordViewController alloc] init];
    self.classesVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"classesVC"];
    self.chatbotVC = [[CBChatbotViewController alloc] init];
    
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{}];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    //pageVIewController.dataSource = self;
    [pageViewController setViewControllers:@[self.recordVC]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:true
                                completion:^(BOOL finished) {
        
    }];
    pageViewController.view.backgroundColor = [UIColor clearColor];
    self.pageVC = pageViewController;
    
    [self addChildViewController:pageViewController];
    pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    
    // TabBar
    
    const CGFloat tabBarHeight = 130;
    CBTabBar *tabBar = [[[UINib nibWithNibName:@"CBTabBar" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    [self.view addSubview:tabBar];
    tabBar.frame = CGRectMake(0,CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.bounds), tabBarHeight);
    tabBar.delegate = self;
    self.tabBar = tabBar;
}

#pragma mark - TabBar delegate

- (void)tabBarRecordButtonTapped:(CBTabBar *)tabBar
{    
    if (self.recordVC.isRecording) {
        [tabBar stopPulse];
    } else {
        [tabBar startPulse];
    }
    
    [self.recordVC record];
}

- (void)tabBarLecturesButtonTapped:(CBTabBar *)tabBar
{
    [self.pageVC setViewControllers:@[self.classesVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (void)tabBarAskMeButtonTapped:(CBTabBar *)tabBar
{
    [self.pageVC setViewControllers:@[self.chatbotVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - UIPageViewController Data Source


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.recordVC == viewController) {
        return self.classesVC;
    }
    
    if (self.chatbotVC == viewController) {
        return self.recordVC;
    }
    
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.recordVC == viewController) {
        return self.chatbotVC;
    }
    
    if (self.classesVC == viewController) {
        return self.recordVC;
    }
    
    return nil;
}

#pragma mark - UIPageViewController delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed;
{
    UIViewController *prevVC = [previousViewControllers firstObject];
    if (prevVC) {
        if ((prevVC == self.recordVC && completed) || (prevVC != self.recordVC && !completed)) {
            const CGFloat tabBarHeight = 100;
            [self.tabBar collapse];
            self.tabBar.frame = CGRectMake(0,CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.bounds), tabBarHeight);
        } else {
            [self.tabBar expand];
        }
    }

    NSLog(@"Hallo");
}

#pragma mark - Other


@end
