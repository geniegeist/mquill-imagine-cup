//
//  CBRRecordButton.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBRecordButton : UIView
- (void)whiteColor;
- (void)greyColor;

@property (nonatomic, assign) BOOL active;
@end

NS_ASSUME_NONNULL_END
