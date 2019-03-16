//
//  CBClassCollectionViewController.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 20.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBClassCollectionViewController.h"
#import "CBClassCollectionViewCell.h"
#import "CBClassesManager.h"
#import "NSDate+TimeAgo.h"
#import "CBLectureView.h"
#import "FFPopup.h"

@interface CBClassCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) CBClassesManager *classesManager;
@property (nonatomic, strong) FFPopup *popup;
@property (nonatomic, strong) NSString *currentContent;
@end

@implementation CBClassCollectionViewController

static NSString * const reuseIdentifier = @"reuse";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);

    self.classesManager = [CBClassesManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}

#pragma mark - Getter

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [(NSArray *)[self.classesManager getClasses][0][pClassLectures] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray <NSDictionary *> *lectures = [self.classesManager getClasses][0][pClassLectures];
    NSDictionary *lecture = lectures[indexPath.item];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[lecture[pLectureDate] integerValue]];
    
    cell.classTitle.text = lecture[pLectureName];
    cell.dateLabel.text = date.timeAgo;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width*0.43, 100);
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray <NSDictionary *> *lectures = [self.classesManager getClasses][0][pClassLectures];
    NSDictionary *lecture = lectures[indexPath.item];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy - hh:mm a";
    NSDate *lectureDate = [NSDate dateWithTimeIntervalSince1970:[lecture[pLectureDate] integerValue]];
    
    NSLog(@"%@", lecture);
    
    CBLectureView *lectureView = [[[UINib nibWithNibName:@"CBLectureView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    lectureView.lectureName = lecture[pLectureName];
    lectureView.content = lecture[pLectureContent];
    lectureView.lectureDate = [dateFormatter stringFromDate:lectureDate];
    
    self.currentContent = lecture[pLectureContent];
    
    [lectureView.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    const CGFloat sidePadding = 16.0;
    const CGFloat width = self.view.bounds.size.width - sidePadding * 2;
    const CGFloat height = self.view.bounds.size.height * 0.8;
    lectureView.frame = CGRectMake(sidePadding, (self.view.bounds.size.height - height) / 2.0, width, height);
    
    FFPopup *popUp = [FFPopup popupWithContentView:lectureView];
    popUp.shouldDismissOnBackgroundTouch = YES;
    popUp.showType = FFPopupShowType_BounceInFromBottom;
    [popUp show];
        
    self.popup = popUp;
}

- (void)share
{
    [self.popup dismissAnimated:YES];
    
    NSArray * activityItems = @[self.currentContent];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypePostToFacebook,UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeAirDrop];
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityController animated:YES completion:nil];
}


@end
