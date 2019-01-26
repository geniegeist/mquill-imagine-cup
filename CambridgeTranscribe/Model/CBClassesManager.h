//
//  CBClassesManager.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const pClassName;
extern NSString *const pClassID;
extern NSString *const pClassLectures;
extern NSString *const pClassDate;
extern NSString *const pLectureName;
extern NSString *const pLectureID;
extern NSString *const pLectureContent;
extern NSString *const pLectureDate;


@interface CBClassesManager : NSObject

+ (instancetype)sharedInstance;

// Classes

- (void)addClassWithName:(NSString *)name;
- (void)addLectureWithName:(NSString *)lectureName content:(NSString *)content toClass:(NSString *)classId;

- (NSArray <NSDictionary *> *)getClasses;
- (NSDictionary *)getClassWithId:(NSString *)classId;
- (NSDictionary *)getClassWithName:(NSString *)className;


@end

NS_ASSUME_NONNULL_END
