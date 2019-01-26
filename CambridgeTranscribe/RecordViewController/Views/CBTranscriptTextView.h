//
//  CBTranscriptTextView.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBTranscriptTextView : UIView
@property (nonatomic, copy) NSString *text;

- (void)startTimer;
- (void)endTimer;
- (void)reset;

- (void)positionTextView;

@property (nonatomic, assign) BOOL showEmptyState;
@property (nonatomic, assign) BOOL showSavedState;
@property (nonatomic, assign) BOOL showDiscardedState;
@end

NS_ASSUME_NONNULL_END
