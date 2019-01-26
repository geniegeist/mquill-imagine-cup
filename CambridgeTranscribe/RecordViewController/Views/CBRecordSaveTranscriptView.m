//
//  CBRecordSaveTranscriptView.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 24.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBRecordSaveTranscriptView.h"
@import SkyFloatingLabelTextField;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CBRecordSaveTranscriptView()
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *textfield;
@end

@implementation CBRecordSaveTranscriptView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = YES;
    self.textfield.titleFont = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:12];
}

- (IBAction)tap:(id)sender
{
    [self.textfield resignFirstResponder];
}


@end
