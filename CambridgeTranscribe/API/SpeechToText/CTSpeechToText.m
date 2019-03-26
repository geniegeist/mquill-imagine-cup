//
//  CTSpeechToText.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 13.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CTSpeechToText.h"
#import <MicrosoftCognitiveServicesSpeech/SPXSpeechApi.h>

@interface CTSpeechToText()
@property (nonatomic, copy) NSString *subscriptionKey;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, strong) SPXSpeechRecognizer *speechRecognizer;
@end

@implementation CTSpeechToText

+ (NSString *)subscriptionKey {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Info" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    return dict[@"speechApiKey"];
}

+ (NSString *)region {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Info" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    return dict[@"speechRegion"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _subscriptionKey = self.class.subscriptionKey;
        _region = self.class.region;
        _isPlaying = NO;
    }
    return self;
}

- (SPXSpeechRecognizer *)speechRecognizer
{
    if (!_speechRecognizer) {
        SPXSpeechConfiguration *speechConfig = [[SPXSpeechConfiguration alloc] initWithSubscription:self.subscriptionKey region:self.region];
        if (!speechConfig) {
            NSLog(@"Could not load speech config");
            return nil;
        }
        
        _speechRecognizer = [[SPXSpeechRecognizer alloc] init:speechConfig];
    }
    return _speechRecognizer;
}

- (void)startRecognizing {
    NSLog(@"Start recognising");
    __weak typeof(self) weakSelf = self;
    self.isPlaying = YES;

    [self.speechRecognizer addRecognizedEventHandler:^(SPXSpeechRecognizer * _Nonnull recognizer,
                                                       SPXSpeechRecognitionEventArgs * _Nonnull args) {
        SPXRecognitionResult *result = args.result;
        NSLog(@"%@", result.text);
        
        if (weakSelf.delegate) {
            [weakSelf.delegate speechToText:weakSelf didRecognizeUtterance:result.text utteranceId:result.resultId];
        }
    }];
    
    [self.speechRecognizer addRecognizingEventHandler:^(SPXSpeechRecognizer * _Nonnull recognizer,
                                                        SPXSpeechRecognitionEventArgs * _Nonnull args) {
        SPXRecognitionResult *result = args.result;
        if (weakSelf.delegate) {
            [weakSelf.delegate speechToText:weakSelf isReconigizingUtterance:result.text utteranceId:result.resultId];
        }
        NSLog(@"%@ %@", result.properties, result.text);
    }];
    
    [self.speechRecognizer addCanceledEventHandler:^(SPXSpeechRecognizer * _Nonnull recognizer,
                                                SPXSpeechRecognitionCanceledEventArgs * _Nonnull args) {
        if (weakSelf.delegate) {
            [weakSelf.delegate speechToTextDidCancel:weakSelf];
        }
        NSLog(@"Error");
    }];
    
    [self.speechRecognizer startContinuousRecognition];
}

- (void)stopRecognizing
{
    self.isPlaying = NO;
    [self.speechRecognizer stopContinuousRecognition];
    self.speechRecognizer = nil;
}

- (void)recognizeUtterance:(void (^)(NSString * _Nonnull))completionBlock
{
    [self.speechRecognizer recognizeOnceAsync:^(SPXSpeechRecognitionResult * _Nonnull result) {
        completionBlock(result.text);
    }];
}

@end
