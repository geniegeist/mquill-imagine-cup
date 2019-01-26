//
//  CBRRecordButton.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBRRecordButton.h"

@interface CBRRecordButton ()
@property (weak, nonatomic) IBOutlet UIView *innerLayer;
@property (weak, nonatomic) IBOutlet UIView *outerLayer;
@end

@implementation CBRRecordButton

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

@end
