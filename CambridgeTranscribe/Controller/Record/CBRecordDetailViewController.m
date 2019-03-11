//
//  CBRecordDetailViewController.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 20.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBRecordDetailViewController.h"
#import <MicrosoftCognitiveServicesSpeech/SPXSpeechApi.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CBRecordDetailViewController ()
@property (nonatomic, strong) SPXSpeechRecognizer *speechRecognizer;
@property (nonatomic, assign, readwrite) BOOL isPlaying;
@property (nonatomic, strong) UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *transcriptTextViewWrapper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTranscriptTextViewConstraint;

@property (nonatomic, copy, readwrite) NSString *transcript;
@property (nonatomic, copy) NSString *sofar;
@end

@implementation CBRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // model
    self.isPlaying = false;
    self.transcript = @"";
    self.sofar = @"";
    

    // UI
    self.transcriptTextViewWrapper.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor clearColor];
}


#pragma mark - Getter

- (SPXSpeechRecognizer *)speechRecognizer
{
    if (!_speechRecognizer) {
        SPXSpeechConfiguration *speechConfig = [[SPXSpeechConfiguration alloc] initWithSubscription:@"9ffbf97363c6488a8a3b8db23d9ddf77" region:@"westus"];
        if (!speechConfig) {
            NSLog(@"Could not load speech config");
            return nil;
        }
        
        _speechRecognizer = [[SPXSpeechRecognizer alloc] init:speechConfig];
    }
    return _speechRecognizer;
}


#pragma mark - Record

- (void)recognizeFromMicrophone {
    if (self.isPlaying) return;
    
    NSLog(@"Start recognising");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.bottomTranscriptTextViewConstraint.constant = 140;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    });
    
    SPXSpeechRecognizer* speechRecognizer = self.speechRecognizer;
    if (!speechRecognizer) {
        NSLog(@"Could not create speech recognizer");
        return;
    }
    
    [speechRecognizer addRecognizedEventHandler:^(SPXSpeechRecognizer * _Nonnull recognizer, SPXSpeechRecognitionEventArgs * _Nonnull args) {
        SPXRecognitionResult *result = args.result;
        NSLog(@"Recognized");
        NSLog(@"%@", result.text);
        self.sofar = [NSString stringWithFormat:@"%@ %@", self.sofar, result.text];
    }];
    [speechRecognizer addRecognizingEventHandler:^(SPXSpeechRecognizer * _Nonnull recognizer, SPXSpeechRecognitionEventArgs * _Nonnull args) {
        SPXRecognitionResult *result = args.result;
        NSLog(@"%@", result.text);
        
        if (result.text) {
            self.transcript = [NSString stringWithFormat:@"%@ %@", self.sofar, result.text];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveTranscriptData:transcript:)]) {
                [self.delegate didReceiveTranscriptData:self transcript:self.transcript];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateTranscriptTextView];
            });
        }
    }];
    [speechRecognizer addCanceledEventHandler:^(SPXSpeechRecognizer * _Nonnull recognizer, SPXSpeechRecognitionCanceledEventArgs * _Nonnull args) {
        NSLog(@"Error");
    }];
    [speechRecognizer startContinuousRecognition];
    self.isPlaying = true;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logo.alpha = 1;
        self.headerLabel.text = @"Transcribing...";
    });
}

- (void)stopRecording {
    if (!self.isPlaying) return;
    
    NSLog(@"Stop recording");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bottomTranscriptTextViewConstraint.constant = 188;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        
       
    });
    
    
    [self.speechRecognizer stopContinuousRecognition];
    self.isPlaying = false;
    
    if ([self.delegate respondsToSelector:@selector(didStopTranscript:)]) {
        [self.delegate didStopTranscript:self];
    }
}

- (void)updateTranscriptTextView
{

}

@end
