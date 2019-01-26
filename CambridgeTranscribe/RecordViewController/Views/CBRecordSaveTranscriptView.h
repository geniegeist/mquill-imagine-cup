//
//  CBRecordSaveTranscriptView.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 24.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CBROutlineButton;
@interface CBRecordSaveTranscriptView : UIView
@property (weak, nonatomic) IBOutlet UIButton *discardButton;
@property (weak, nonatomic) IBOutlet UIButton *saveTranscribtButton;
@property (weak, nonatomic) IBOutlet CBROutlineButton *classButton;
@end

NS_ASSUME_NONNULL_END
