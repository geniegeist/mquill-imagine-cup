//
//  CBROutlineButton.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 24.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBROutlineButton.h"

@implementation CBROutlineButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self prepareUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self prepareUI];
    }
    
    return self;
}

- (void)prepareUI
{
    self.titleEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
    self.layer.borderColor = [UIColor colorWithRed:102/255.0 green:64/255.0 blue:255/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0;
}

@end
