//
//  CBRRecordButton.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBRecordButton.h"

@interface CBRecordButton ()
@property (weak, nonatomic) IBOutlet UIView *innerLayer;
@property (weak, nonatomic) IBOutlet UIView *outerLayer;
@end

@implementation CBRecordButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.outerLayer.layer.borderWidth = 4;
    self.outerLayer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.outerLayer.layer.cornerRadius = CGRectGetWidth(self.outerLayer.bounds) / 2.0;
    self.outerLayer.backgroundColor = [UIColor clearColor];
    
    self.innerLayer.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.outerLayer.layer.cornerRadius = CGRectGetWidth(self.outerLayer.bounds) / 2.0;
    self.innerLayer.layer.cornerRadius = CGRectGetWidth(self.innerLayer.bounds) / 2.0;
}

- (void)greyColor
{
    [UIView animateWithDuration:0.3 animations:^{
        self.outerLayer.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
        self.innerLayer.layer.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    }];
}

- (void)whiteColor
{
    [UIView animateWithDuration:0.3 animations:^{
        self.outerLayer.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        self.innerLayer.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    }];
}

- (void)setActive:(BOOL)active
{
    _active = active;
}

@end
