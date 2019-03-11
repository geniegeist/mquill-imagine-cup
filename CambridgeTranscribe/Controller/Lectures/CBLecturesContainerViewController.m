//
//  CBClassesViewController.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 20.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBLecturesContainerViewController.h"
#import "CBClassCollectionViewController.h"

@interface CBLecturesContainerViewController ()

@end

@implementation CBLecturesContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    return;
    CBClassCollectionViewController *collectionVC = [[CBClassCollectionViewController alloc] init];
    
    [self addChildViewController:collectionVC];
    collectionVC.view.frame = self.view.frame;
    [self.view addSubview:collectionVC.view];
    [collectionVC didMoveToParentViewController:self];
    collectionVC.collectionView.alwaysBounceVertical = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
