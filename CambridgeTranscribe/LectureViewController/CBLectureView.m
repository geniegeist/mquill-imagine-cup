//
//  CBLectureView.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBLectureView.h"

@interface CBLectureView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CBLectureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = YES;
}

#pragma mark - Getter

- (void)setContent:(NSString *)content
{
    _content = [content copy];
    self.textView.text = content;
    [self.textView setContentOffset:CGPointZero animated:NO];
}

- (void)setLectureName:(NSString *)lectureName
{
    _lectureName = [lectureName copy];
    self.titleLabel.text = _lectureName;
}

- (void)setLectureDate:(NSString *)lectureDate
{
    _lectureDate = [lectureDate copy];
    self.dateLabel.text = lectureDate;
}

- (void)prepare
{
    [self.textView setContentOffset:CGPointZero animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.textView setContentOffset:CGPointZero animated:NO];
}

@end
