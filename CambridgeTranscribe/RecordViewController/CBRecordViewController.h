//
//  CBRecordViewController.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 19.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CBRecordViewController : UIViewController
@property (nonatomic, assign, readonly) BOOL isRecording;
- (void)record;
@end

NS_ASSUME_NONNULL_END
