//
//  CBTranscriptTextView.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBTranscriptTextView.h"
#import "MZTimerLabel.h"

@interface CBTranscriptTextView ()
@property (weak, nonatomic) IBOutlet UIView *discardedStateView;
@property (weak, nonatomic) IBOutlet UIView *savedStateView;
@property (weak, nonatomic) IBOutlet UIView *emptyStateView;
@property (weak, nonatomic) IBOutlet MZTimerLabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CBTranscriptTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 32, 32, 32);
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    self.textView.text = text;
}

#pragma mark - Public

- (void)startTimer
{
    [self.timerLabel start];
}

- (void)endTimer
{
    [self.timerLabel pause];
}

- (void)reset
{
    [self.timerLabel reset];
    self.textView.text = @"Transcribing...";
}

- (void)positionTextView
{
    NSRange lastLine = NSMakeRange(self.textView.text.length - 1, 1);
    [self.textView scrollRangeToVisible:lastLine];
}

#pragma mark - Getter & Setter

- (void)setShowEmptyState:(BOOL)showEmptyState
{
    _showEmptyState = showEmptyState;
    
    self.emptyStateView.hidden = !showEmptyState;
}

- (void)setShowSavedState:(BOOL)showSavedState
{
    _showSavedState = showSavedState;
    
    self.savedStateView.hidden = !showSavedState;
}

- (void)setShowDiscardedState:(BOOL)showDiscardedState
{
    _showDiscardedState = showDiscardedState;
    
    self.discardedStateView.hidden = !showDiscardedState;
}

@end
