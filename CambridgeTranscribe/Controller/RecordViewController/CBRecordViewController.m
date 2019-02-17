//
//  CBRecordViewController.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 19.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "FFPopup.h"
#import "CBRecordViewController.h"
#import "CBRecordDetailViewController.h"
#import "CBRecordTranscriptViewController.h"
#import "CBRecordSaveTranscriptView.h"
#import "FCAlertView.h"
#import "CBClassesManager.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CBRecordViewController () <UIPageViewControllerDataSource, CBRecordDelegate>
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) UITextField *classTextfield;
@property (nonatomic, strong) NSString *currentTranscript;
@property (nonatomic, strong) FFPopup *popup;
@property (nonatomic, assign) BOOL isSaving;
@property (nonatomic, strong) CBRecordDetailViewController *recordDetailVC;
@property (nonatomic, strong) CBClassesManager *classesManager;
@property (nonatomic, strong) CBRecordSaveTranscriptView *saveTranscriptView;
@end

@implementation CBRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Model
    self.classesManager = [CBClassesManager sharedInstance];
    self.isSaving = false;

    // UI
    self.view.backgroundColor = [UIColor clearColor];
    
    // CBRecordTranscriptViewController *detailVC2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"recordTranscript"];
    CBRecordDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailrecord"];
    detailVC.delegate = self;
    self.recordDetailVC = detailVC;
    
    self.pages = @[detailVC, /*detailVC2*/];

    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    pageViewController.dataSource = self;
    
    [pageViewController setViewControllers:@[detailVC]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:true
                                completion:nil];
    
    [self addChildViewController:pageViewController];
    pageViewController.view.frame = self.view.frame;
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - Getter

- (BOOL)isRecording
{
    return self.recordDetailVC.isPlaying;
}

#pragma mark - Public

- (void)record
{
    if (!self.recordDetailVC.isPlaying) {
        [self.recordDetailVC recognizeFromMicrophone];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"END");
            NSLog(@"%@", self.recordDetailVC.transcript);
            
            CBRecordSaveTranscriptView *saveTranscriptView = [[[UINib nibWithNibName:@"CBRecordSaveTranscriptView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
            const CGFloat sidePadding = 16.0;
            const CGFloat width = self.view.bounds.size.width - sidePadding * 2;
            const CGFloat height = self.view.bounds.size.height * 0.8;
            saveTranscriptView.frame = CGRectMake(sidePadding, (self.view.bounds.size.height - height) / 2.0, width, height);
            saveTranscriptView.transcriptsCount = self.currentTranscript.length;
            
            [saveTranscriptView.saveTranscribtButton addTarget:self action:@selector(saveTranscript) forControlEvents:UIControlEventTouchUpInside];
            [saveTranscriptView.discardButton addTarget:self action:@selector(discard) forControlEvents:UIControlEventTouchUpInside];
            self.saveTranscriptView = saveTranscriptView;
            
            FFPopup *popUp = [FFPopup popupWithContentView:saveTranscriptView];
            popUp.shouldDismissOnBackgroundTouch = NO;
            popUp.showType = FFPopupShowType_BounceInFromBottom;
            [popUp show];
            self.popup = popUp;
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.recordDetailVC stopRecording];
        });
    }
}

#pragma mark - Record

/*
- (void)didReceiveTranscriptData:(CBRecordDetailViewController *)recordDetailViewController transcript:(NSString *)transcript
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentTranscript = transcript;
        [self.pages[1] setTranscript:transcript];
    });
}
*/

- (void)didStopTranscript:(CBRecordDetailViewController *)recordDetailViewController
{
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"END");
        NSLog(@"%@", recordDetailViewController.transcript);
        
        CBRecordSaveTranscriptView *saveTranscriptView = [[[UINib nibWithNibName:@"CBRecordSaveTranscriptView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
        const CGFloat sidePadding = 16.0;
        const CGFloat width = self.view.bounds.size.width - sidePadding * 2;
        const CGFloat height = self.view.bounds.size.height * 0.8;
        saveTranscriptView.frame = CGRectMake(sidePadding, (self.view.bounds.size.height - height) / 2.0, width, height);
        
        [saveTranscriptView.saveTranscribtButton addTarget:self action:@selector(saveTranscript) forControlEvents:UIControlEventTouchUpInside];
        [saveTranscriptView.discardButton addTarget:self action:@selector(discard) forControlEvents:UIControlEventTouchUpInside];
        
        FFPopup *popUp = [FFPopup popupWithContentView:saveTranscriptView];
        popUp.shouldDismissOnBackgroundTouch = NO;
        popUp.showType = FFPopupShowType_BounceInFromBottom;
        [popUp show];
        self.popup = popUp;
    });
     */
}

- (void)didReceiveTranscriptData:(nonnull CBRecordDetailViewController *)recordDetailViewController transcript:(nonnull NSString *)transcript {
    self.currentTranscript = transcript;
}


#pragma mark - Action

- (void)saveTranscript
{
    if (self.isSaving) return;
    
    self.recordDetailVC.showDiscardedState = NO;
    
    self.isSaving = YES;
    
    NSString *currentClassid = [self.classesManager getClasses][0][pClassID];
    NSString *lectureName = self.saveTranscriptView.textfield.text;
    [self.classesManager addLectureWithName:lectureName content:self.currentTranscript toClass:currentClassid];

    self.isSaving = false;
    
    [self.popup dismissAnimated:true];
}

- (void)discard {
    
    self.recordDetailVC.showDiscardedState = YES;
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert showAlertInView:self
                 withTitle:@"The transcript will be lost!"
              withSubtitle:@"Are you sure that you want to discard the transcript?"
           withCustomImage:nil
       withDoneButtonTitle:@"Discard"
                andButtons:nil];
    
    alert.blurBackground = YES;
    
    
    [alert addButton:@"Do not discard" withActionBlock:^{
        self.recordDetailVC.showDiscardedState = NO;
    }];
    
    [alert doneActionBlock:^{
        [self.popup dismissAnimated:true];
    }];
    
    alert.titleFont = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:20.0];
    alert.subtitleFont = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:17.0];
    
    alert.firstButtonTitleColor = [UIColor blackColor];
    alert.doneButtonTitleColor = [UIColor redColor];
    
    alert.doneButtonCustomFont = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:17.0];
    alert.firstButtonCustomFont = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:17.0];
}


#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return nil;
    /*
     if (viewController == self.pages[0]) {
     return nil;
     }
     
     return self.pages[0];*/
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return nil;
    /*
     if (viewController == self.pages[1]) {
     return nil;
     }
     
     return self.pages[1];
     */
}


@end
