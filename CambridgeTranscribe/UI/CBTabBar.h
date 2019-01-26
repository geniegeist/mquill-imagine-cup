//
//  CBTabBar.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CBTabBar;
@protocol CBTabBarDelegate <NSObject>
- (void)tabBarRecordButtonTapped:(CBTabBar *)tabBar;
- (void)tabBarLecturesButtonTapped:(CBTabBar *)tabBar;
- (void)tabBarAskMeButtonTapped:(CBTabBar *)tabBar;

@end

@interface CBTabBar : UIView
@property (nonatomic, assign) id<CBTabBarDelegate> delegate;

- (void)startPulse;
- (void)stopPulse;

- (void)collapse;
- (void)expand;
@end

NS_ASSUME_NONNULL_END
