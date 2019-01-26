//
//  CBTabBar.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBTabBar.h"
#import "CBRecordButton.h"
#import <PulsingHalo/PulsingHaloLayer.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CBTabBar ()
@property (weak, nonatomic) IBOutlet UIView *leftWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIView *centerWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerWrapperSizeConstraint;
@property (weak, nonatomic) IBOutlet UIView *centerLabel;
@property (nonatomic, strong) CBRecordButton *recordButton;
@property (nonatomic, strong) PulsingHaloLayer *halo;
@end

@implementation CBTabBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.recordButton = [[[UINib nibWithNibName:@"CBRecordButton" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    self.recordButton.userInteractionEnabled = NO;
    [self.centerWrapper addSubview: self.recordButton];
    self.centerWrapper.backgroundColor = [UIColor clearColor];
    self.centerWrapperSizeConstraint.constant = 100;
    
    self.halo = [PulsingHaloLayer layer];
    self.halo.radius = 100;
    self.halo.position = self.centerWrapper.center;
    [self.layer addSublayer:self.halo];
    self.halo.backgroundColor = UIColorFromRGB(0xFFFFFF).CGColor;
    self.halo.pulseInterval = 0.5;
    self.halo.haloLayerNumber = 3;
    self.halo.repeatCount = INFINITY;
    self.halo.hidden = YES;
    [self.halo start];
    
    self.leftImageView.userInteractionEnabled = NO;
    self.leftImageView.image = [self.leftImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.leftImageView.tintColor = [UIColor whiteColor];
    
    self.leftImageView.userInteractionEnabled = NO;
    self.rightImageView.image = [self.rightImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.rightImageView.tintColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.recordButton.frame = self.centerWrapper.bounds;
    self.halo.position = self.centerWrapper.center;
}

- (IBAction)centerButtonTapped:(id)sender {
    [self.delegate tabBarRecordButtonTapped:self];
}

- (IBAction)leftButtonTapped:(id)sender {
    NSLog(@"left butt");
    [self.delegate tabBarLecturesButtonTapped:self];
}

- (IBAction)rightButtonTapped:(id)sender {
    NSLog(@"right butt");
    [self.delegate tabBarAskMeButtonTapped:self];

}

- (void)startPulse
{
    self.centerLabel.hidden = YES;
    [self.halo setHidden:NO];
}

- (void)stopPulse
{
    self.centerLabel.hidden = NO;
    self.halo.hidden = YES;
}

- (void)collapse
{
    self.centerWrapperSizeConstraint.constant = 64;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        self.centerLabel.alpha = 0;
        [self layoutIfNeeded];
        self.rightImageView.tintColor = [UIColor colorWithWhite:0.85 alpha:1];
        self.leftImageView.tintColor = [UIColor colorWithWhite:0.85 alpha:1];
        [self.recordButton greyColor];
    }];
}

- (void)expand
{
    self.centerLabel.hidden = NO;
    self.centerWrapperSizeConstraint.constant = 100;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        self.centerLabel.alpha = 1;
        [self layoutIfNeeded];
        self.rightImageView.tintColor = [UIColor colorWithWhite:1 alpha:1];
        self.leftImageView.tintColor = [UIColor colorWithWhite:1 alpha:1];
        [self.recordButton whiteColor];
    }];
}

@end
