//
//  CBLectureView.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBLectureView : UIView
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *lectureName;
@property (nonatomic, copy) NSString *lectureDate;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (void)prepare;
@end

NS_ASSUME_NONNULL_END
