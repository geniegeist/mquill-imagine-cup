//
//  CBRecordSaveTranscriptView.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 24.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBRecordSaveTranscriptView.h"
#import "CBClassesManager.h"
#import "CBROutlineButton.h"
#import "ActionSheetPicker.h"
#import "FCAlertView.h"
@import SkyFloatingLabelTextField;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CBRecordSaveTranscriptView()
@property (weak, nonatomic) IBOutlet UILabel *funTextLabel;
@property (weak, nonatomic) IBOutlet CBROutlineButton *classesButton;
@property (nonatomic, strong) CBClassesManager *classesManager;
@property (nonatomic, strong) NSDictionary *currentClass;
@end

@implementation CBRecordSaveTranscriptView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = YES;
    self.textfield.titleFont = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:12];
    
    self.classesManager = [CBClassesManager sharedInstance];
    self.currentClass = [[self.classesManager getClasses] firstObject];
    [self.classesButton setTitle:self.currentClass[pClassName] forState:UIControlStateNormal];
}

- (IBAction)tap:(id)sender
{
    [self.textfield resignFirstResponder];
}

- (IBAction)classButtonTapped:(id)sender
{
    return;
    /*
    NSArray *colors = [NSArray arrayWithObjects:@"General", nil];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@"Currently there is only one class"
                                              rows:colors
                                  initialSelection:0
                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
                                         }
                                       cancelBlock:^(ActionSheetStringPicker *picker) {
        
                                       }
                                       origin:sender];
    */
    /*
    [picker addCustomButtonWithTitle:@"Create" actionBlock:^{
        FCAlertView *alert = [[FCAlertView alloc] init];
        
        [alert showAlertWithTitle:@"Alert Title"
                  withSubtitle:@"This is your alert's subtitle. Keep it short and concise. 😜👌"
               withCustomImage:nil
           withDoneButtonTitle:nil
                    andButtons:nil];
        
        
        [alert addTextFieldWithPlaceholder:@"Email Address" andTextReturnBlock:^(NSString *text) {
            NSLog(@"The Email Address is: %@", text); // Do what you'd like with the text returned from the field
        }];
    }];
    */
    
    // [picker showActionSheetPicker];
}

- (void)setTranscriptsCount:(NSUInteger)transcriptsCount
{
    _transcriptsCount = transcriptsCount;
    
    self.funTextLabel.text = [NSString stringWithFormat:@"Did you know that you have just transcribed a total of %ld characters 👏", transcriptsCount];
}

@end
