//
//  CBRecordDetailViewController.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 20.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CBRecordDetailViewController;
@protocol CBRecordDelegate <NSObject>
- (void)didReceiveTranscriptData:(CBRecordDetailViewController *)recordDetailViewController transcript:(NSString *)transcript;
- (void)didStopTranscript:(CBRecordDetailViewController *)recordDetailViewController;
@end

@interface CBRecordDetailViewController : UIViewController
@property (nonatomic, assign) id <CBRecordDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *transcript;
@property (nonatomic, assign, readonly) BOOL isPlaying;

- (void)recognizeFromMicrophone;
- (void)stopRecording;

@property (nonatomic, assign) BOOL showDiscardedState;
@end

NS_ASSUME_NONNULL_END
