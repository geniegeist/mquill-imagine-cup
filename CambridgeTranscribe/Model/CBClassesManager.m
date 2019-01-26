//
//  CBClassesManager.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 25.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBClassesManager.h"

@interface CBClassesManager ()
@end

NSString * const kClasses = @"mquill_classes"; // const pointer
NSString * const pClassName = @"name";
NSString * const pClassLectures = @"lectures";
NSString * const pClassID = @"id";
NSString * const pClassDate = @"date";

NSString * const pLectureName = @"name";
NSString * const pLectureContent = @"content";
NSString * const pLectureID = @"id";
NSString * const pLectureDate = @"date";


@implementation CBClassesManager

+ (instancetype)sharedInstance
{
    static CBClassesManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CBClassesManager alloc] init];
        NSArray *classes = [CBClassesManager classes];
        if (!classes) {
            NSString *content = @"MQuill is a lecture capture app that allows you to make live transcripts of your lectures and save them. That way you have all your lectures in your pocket. You can then use Adi our smart chatbot to ask questions about your lectures such as requests for summaries.\n \nWe are three students who just met at HackCambridge. Areeg is studying Engineering at the University of Cambridge, Duc is studying Mathematics in Berlin and Ioana is studying Computer Science in Edinburgh. In our experience, it is really difficult to keep up with the fast-paced complex lectures nowadays. We developed MQuill to address this issue.";
            NSDictionary *lecture = @{pLectureID: [CBClassesManager uuid], pLectureDate: @([NSDate date].timeIntervalSince1970), pLectureName: @"Welcome", pLectureContent: content};
            
            NSString *content2 = @"Adi is our chatbot solution that helps you to search for keywords in your lecture notes. You can try Adi by asking \"What are the important facts of <lecture name>\" or \"Highlight all the key phrases in <lecture name>\".\n\nIf you want to know more about a specific term, say \"evolution\", you can ask \"Tell me more about evolution\".\n\nFor the future, we plan much more for Adi, for instance: search for lectures, ask for definitions, summarization, ...\n\nAdi is built on Microsoft's Azure services: Speech-to-Text, Natural Language Understanding, Text Analytics and Bing Search.";
            NSDictionary *lecture2 = @{pLectureID: [CBClassesManager uuid], pLectureDate: @([NSDate date].timeIntervalSince1970), pLectureName: @"Chatbot", pLectureContent: content2};
            
            // set default value
            NSDictionary *general = @{pClassID: [[self class] uuid], pClassLectures: @[lecture, lecture2], pClassDate: @([NSDate date].timeIntervalSince1970), pClassName: @"General"};
            [[NSUserDefaults standardUserDefaults] setObject:@[general] forKey:kClasses];
        }
    });
    return sharedInstance;
}

+ (NSArray<NSDictionary *> *)classes {
   return [[NSUserDefaults standardUserDefaults] objectForKey:kClasses];
}

- (void)addClassWithName:(NSString *)name
{
    NSDictionary *class = @{pClassID: [self class].uuid, pClassName: name, pClassLectures:@[], pClassDate: @([NSDate date].timeIntervalSince1970)};
    NSMutableArray *classes = [[[self class] classes] mutableCopy];
    [classes addObject:class];
    [self updateClasses:classes];
}

- (void)addLectureWithName:(NSString *)lectureName content:(NSString *)content toClass:(NSString *)classId
{
    NSMutableDictionary *lecture = [NSMutableDictionary dictionary];
    lecture[pLectureDate] = @([[NSDate date] timeIntervalSince1970]);
    lecture[pLectureID] = [[self class] uuid];
    lecture[pLectureName] = lectureName ? lectureName : @"My Lecture";
    lecture[pLectureContent] = content;
    
    NSMutableDictionary *class = [[self getClassWithId:classId] mutableCopy];
    NSMutableArray<NSDictionary *> *lectures = [class[pClassLectures] mutableCopy];
    [lectures addObject:lecture];
    class[pClassLectures] = lectures;
    [self updateClass:class forClassId:classId];
}

- (NSDictionary *)getClassWithId:(NSString *)classId
{
    NSArray <NSDictionary *> *classes = [[self class] classes];
    __block NSDictionary *result;
    [classes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[pClassID] isEqualToString:classId]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (NSDictionary *)getClassWithName:(NSString *)name
{
    NSArray <NSDictionary *> *classes = [[self class] classes];
    __block NSDictionary *result;
    [classes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj[pClassName] lowercaseString] isEqualToString:name.lowercaseString]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (void)updateClass:(NSDictionary *)class forClassId:(NSString *)classId {
    NSMutableArray <NSDictionary *> *classes = [[[self class] classes] mutableCopy];
    NSUInteger index = [classes indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj[pClassID] isEqualToString:classId];
    }];
    if (index != NSNotFound) {
        [classes replaceObjectAtIndex:index withObject:class];
    }
    [self updateClasses:classes];
}

- (void)updateClasses:(NSArray <NSDictionary *> *)classes {
    [[NSUserDefaults standardUserDefaults] setObject:classes forKey:kClasses];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray <NSDictionary *> *)getClasses
{
    return [[self class] classes];
}

#pragma mark - Helper

+ (NSString *)uuid
{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    return UUID;
}


@end
