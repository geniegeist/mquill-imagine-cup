//
//  CBChatbotViewController.m
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 20.01.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import "CBChatbotViewController.h"
#import <Shift/Shift-umbrella.h>
#import <Speech/Speech.h>
#import <ApiAI/ApiAI.h>
#import "CBClassesManager.h"
#import "CBChatbotHint.h"
#import <FFPopup/FFPopup.h>

@interface CBChatbotViewController ()
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *request;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) NSTimer *detectionTimer;

@property (nonatomic, strong) ShiftView_Objc *shiftView;

@property (nonatomic, strong) UITextView *welcome;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, strong) CBClassesManager *classesManager;

@property(nonatomic, strong) ApiAI *apiAI;

@property (nonatomic, strong) FFPopup *hintPopup;

@property (nonatomic, strong) NSString *currentClass;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
NSString * const kFirstTime = @"mquill_chatbot_first_time";

@implementation CBChatbotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.speechRecognizer= [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-UK"]];
    self.request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    UIButton *record = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    [record setTitle:@"I am looking for..." forState:UIControlStateNormal];
    record.center = self.view.center;
    record.frame = CGRectOffset(record.frame, 0, 200);
    record.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    [record addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    record.layer.cornerRadius = 20;
    record.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:20];
    self.recordButton = record;
    [self.view addSubview:record];
    
    UITextView *welcome = [[UITextView alloc] initWithFrame:CGRectMake(32, 50, 300, 500)];
    welcome.text = @"Hey there! What lecture do you want to polish up on?";
    welcome.textColor = [UIColor whiteColor];
    welcome.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:24];
    welcome.editable = NO;
    welcome.backgroundColor = [UIColor clearColor];
    welcome.bounces = YES;
    self.welcome = welcome;
    [self.view addSubview:welcome];
    self.isRecording = false;
    
    self.classesManager = [CBClassesManager sharedInstance];
    
    // API
    self.apiAI = [[ApiAI alloc] init];
    
    // Define API.AI configuration here.
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    configuration.clientAccessToken = @"52de39d3cd5748ae8d72a11dbfba5f6a";
    
    self.apiAI.configuration = configuration;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shiftView startTimedAnimation];
    
    BOOL firstTime = ![[NSUserDefaults standardUserDefaults] boolForKey:kFirstTime];
    if (firstTime) {
        CBChatbotHint *chatbotHint = [[[UINib nibWithNibName:@"CBChatbotHint" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
        chatbotHint.frame = CGRectMake(0, 0, 320, 64);
        chatbotHint.alpha = 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lol)];
        [chatbotHint addGestureRecognizer:tap];
        
        FFPopup *popUp = [FFPopup popupWithContentView:chatbotHint];
        popUp.shouldDismissOnBackgroundTouch = YES;
        popUp.showType = FFPopupShowType_BounceInFromBottom;
        popUp.maskType = FFPopupMaskType_None;
        [popUp showAtCenterPoint:CGPointMake(CGRectGetWidth(self.view.bounds)/2.0, CGRectGetMaxY(self.view.bounds) - 210) inView:self.view];
        
        self.hintPopup = popUp;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstTime];
    }
}

- (void)lol {
    [self.hintPopup dismissAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat ypos = 84;
    self.welcome.frame = CGRectMake(24, ypos, CGRectGetWidth(self.view.bounds) - 24 * 2, CGRectGetHeight(self.view.bounds) - ypos - 170);
}

-  (void)record {
    if (!self.isRecording) {
        self.isRecording = true;
        [self recordAndRecognizeSpeech];
    } else {
        self.isRecording = false;
        [self handleSend];
    }
}

- (void)recordAndRecognizeSpeech {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isRecording = true;
        self.welcome.text = @"Just speak and I will know what you mean...";
        [self.recordButton setTitle:@"Stop recording" forState:UIControlStateNormal];
        self.recordButton.backgroundColor = [UIColor redColor];
    });

    AVAudioInputNode *node = self.audioEngine.inputNode;
    AVAudioFormat *recordingFormat = [node outputFormatForBus:0];
    [node installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.request appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    
    
    if (error) {
        NSLog(@"%@", error);
    }

    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
            NSString *bestString = [result.bestTranscription formattedString];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.welcome.text = bestString;
            });
            __block BOOL isFinal =false;
            
            if (!result) {
                isFinal = [result isFinal];
            }

            if (self.detectionTimer.isValid) {
                [NSTimer scheduledTimerWithTimeInterval:1 repeats:false block:^(NSTimer * _Nonnull timer) {
                    [self.detectionTimer invalidate];
                }];
            } else {
                self.detectionTimer = [NSTimer scheduledTimerWithTimeInterval:4 repeats:false block:^(NSTimer * _Nonnull timer) {
                    [self handleSend];
                    isFinal = true;
                    [self.detectionTimer invalidate];
                }];
            }
            NSLog(@"%@", bestString);
        } else {
            NSLog(@"%@", error);
        }
    }];
}
        
- (void)handleSend {
    NSLog(@"Handle send");
    [self stop];
    
    NSString *userRequest = self.welcome.text.lowercaseString;
    AITextRequest *request = [self.apiAI textRequest];
    request.query = @[userRequest];
    //self.currentClass = @"Chemistry";
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        // Handle success ...
        dispatch_async(dispatch_get_main_queue(), ^{
            // NSLog(@"%@", request);
            NSLog(@"%@", response);
            NSString *speech = response[@"result"][@"fulfillment"][@"speech"];
            NSString *intent = response[@"result"][@"metadata"][@"intentName"];
            NSDictionary *parameters = response[@"result"][@"parameters"];
            
            NSString *lookfor;
            
            if ([userRequest containsString:@"keyword"] || [userRequest containsString:@"key word"] || [userRequest containsString:@"key"] || [userRequest containsString:@"keywords"] || [userRequest containsString:@"fact"] || [userRequest containsString:@"facts"] || [userRequest containsString:@"important"] || [userRequest containsString:@"highlights"]) {
                
                if ([userRequest containsString:@" in "]) {
                    NSRange range = [userRequest rangeOfString:@" in " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                } else if ([userRequest containsString:@" lecture "]) {
                    NSRange range = [userRequest rangeOfString:@" lecture " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                } else if ([userRequest containsString:@" class "]) {
                    NSRange range = [userRequest rangeOfString:@" class " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                } else if ([userRequest containsString:@" of "]) {
                    NSRange range = [userRequest rangeOfString:@" of " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                } else if ([userRequest containsString:@" about "]) {
                    NSRange range = [userRequest rangeOfString:@" of " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                }
            }

            
            if ([intent isEqualToString:@"Key Words"]) {
                
                if (lookfor.length > 0) {
                    NSDictionary *class = [self.classesManager getClassWithName:@"general"];
                    NSArray <NSDictionary *> *lectures = class[pClassLectures];
                    NSDictionary *resLecture;
                    for (NSDictionary *lecture in lectures) {
                        if ([[lecture[pLectureName] lowercaseString] isEqualToString:lookfor]) {
                            resLecture = lecture;
                            break;
                        }
                    }
                    
                    if (resLecture) {
                        NSString *content = resLecture[pLectureContent];
                        NSDictionary *document = [[self keywordSearch:content][@"documents"] firstObject];
                        if (document) {
                            NSArray <NSString *> *keywords = document[@"keyPhrases"];
                            NSString *responseStr = @"Here, it is all summed up: ";
                            NSUInteger index = 0;
                            for (NSString *key in keywords) {
                                if (index == [keywords count]-1) {
                                    responseStr = [NSString stringWithFormat:@"%@and %@.", responseStr, key];
                                } else if (index == [keywords count]-2) {
                                    responseStr = [NSString stringWithFormat:@"%@%@ ", responseStr, key];
                                } else {
                                    responseStr = [NSString stringWithFormat:@"%@%@, ", responseStr, key];
                                }
                                index++;
                            }
                            responseStr = [NSString stringWithFormat:@"%@\n\n If you want to know more about %@, you can ask \"What can you tell me about %@\".", responseStr, [keywords firstObject], [keywords firstObject]];
                            self.welcome.text = responseStr;
                        } else {
                            self.welcome.text = [NSString stringWithFormat:@"I am sorry. I could not find any keywords for %@", lookfor];
                        }
                    } else {
                        // nothing found
                        self.welcome.text = [NSString stringWithFormat:@"I am sorry. I tried to search for any lecture with the name \"%@\". Maybe you were looking for the lecture \"%@\"? If yes, then try: \"Give me the important facts in %@\"", lookfor, [lectures firstObject][pLectureName], lookfor];
                    }
                } else {
                    // do dialogflow things
                    self.welcome.text = speech;
                    NSString *param = parameters[@"engineering"];
                    
                    if (!param) {
                        
                        if (!param) {
                            NSString *param = parameters[@"any"];
                            
                            if (!param) {
                                param = [NSString stringWithFormat: @"%@", parameters[@"classes"]];
                            }
                        }
                    }
                    
                    if (param) {
                        NSDictionary *class = [self.classesManager getClassWithName:@"general"];
                        NSArray <NSDictionary *> *lectures = class[pClassLectures];
                        NSDictionary *resLecture;
                        for (NSDictionary *lecture in lectures) {
                            if ([[lecture[pLectureName] lowercaseString] isEqualToString:param]) {
                                resLecture = lecture;
                                break;
                            }
                        }
                        
                        if (resLecture) {
                            NSString *content = resLecture[pLectureContent];
                            NSDictionary *document = [[self keywordSearch:content][@"documents"] firstObject];
                            if (document) {
                                NSArray <NSString *> *keywords = document[@"keyPhrases"];
                                NSString *responseStr = @"Here, it is all summed up: ";
                                NSUInteger index = 0;
                                for (NSString *key in keywords) {
                                    if (index == [keywords count]-1) {
                                        responseStr = [NSString stringWithFormat:@"%@and %@.", responseStr, key];
                                    } else if (index == [keywords count]-2) {
                                        responseStr = [NSString stringWithFormat:@"%@%@ ", responseStr, key];
                                    } else {
                                        responseStr = [NSString stringWithFormat:@"%@%@, ", responseStr, key];
                                    }
                                    index++;
                                }
                                responseStr = [NSString stringWithFormat:@"%@\n\n If you want to know more about %@, you can ask \"What can you tell me about %@\".", responseStr, [keywords firstObject], [keywords firstObject]];
                                self.welcome.text = responseStr;
                            } else {
                                self.welcome.text = [NSString stringWithFormat:@"I am sorry. I could not find any keywords for %@", param];
                            }
                        } else {
                            // nothing found
                            self.welcome.text = [NSString stringWithFormat:@"I am sorry. I tried to search for any lecture with the name \"%@\". Maybe you were looking for the lecture \"%@\"? If yes, then try: \"Give me the important facts in %@\"", param, [lectures firstObject][pLectureName], param];
                        }
                    } else {
                        self.welcome.text = @"I am sorry. I don't know in which lecture I should look for keywords. Try something like: \"What are the key phrases in ...\"";
                    }
                }
                
                // NSDictionary *dict = [self keywordSearch:content];
            } else if ([intent isEqualToString:@"Find Class"]) {
                self.welcome.text = speech;
                NSLog(@"%@", parameters[@"classes"][0]);
                NSString *myClass;
                if (![parameters[@"classes"] isKindOfClass:[NSString class]]) {
                    myClass = parameters[@"classes"][0];
                    NSLog(@"adneafnejk");
                } else {
                    myClass = parameters[@"classes"];
                }
                self.currentClass = myClass;
                self.welcome.text = [NSString stringWithFormat:@"What are you looking for in your %@ class?", myClass];
            } else if ([intent.lowercaseString isEqualToString:[NSString stringWithFormat: @"Further questions"].lowercaseString]) {
                self.welcome.text = speech;
                
                /*
                NSString *objectToSearch = [[parameters allValues] firstObject];
                NSLog(@"%@", objectToSearch);
                NSDictionary *result = [self bingSearch: objectToSearch];
                NSLog(@"%@", result[@"entities"][@"value"][0][@"description"]);
                self.welcome.text = result[@"entities"][@"value"][0][@"description"];
                if (!self.welcome.text) {
                    self.welcome.text = @"Unfortunately, I have found nothing";
                }*/
                
                
                if ([userRequest containsString:@" in "]) {
                    NSRange range = [userRequest rangeOfString:@" in " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                } else if ([userRequest containsString:@" of "]) {
                    NSRange range = [userRequest rangeOfString:@" of " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                } else if ([userRequest containsString:@" about "]) {
                    NSRange range = [userRequest rangeOfString:@" about " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                } else if ([userRequest containsString:@" for "]) {
                    NSRange range = [userRequest rangeOfString:@" for " options:NSBackwardsSearch];
                    if (range.location != NSNotFound) {
                        lookfor = [userRequest substringFromIndex:range.location+range.length];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        lookfor = [lookfor stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
                        NSLog(@"%@", lookfor);
                    }
                }
                
                if (lookfor.length > 0) {
                    NSDictionary *result = [self bingSearch: lookfor];
                    NSLog(@"%@", result[@"entities"][@"value"][0][@"description"]);
                    self.welcome.text = result[@"entities"][@"value"][0][@"description"];
                    if (!self.welcome.text) {
                        self.welcome.text = @"Unfortunately, I have found nothing";
                    } else if (self.welcome.text.length == 0) {
                        self.welcome.text = [NSString stringWithFormat:@"I started a search for %@ but could not find anything about it.", lookfor];
                    }
                } else {
                    // do dialogflow things
                    self.welcome.text = @"I am sorry. I do not know what to search for.";
                }
                
            } else if ([intent.lowercaseString isEqualToString:@"switch class"]) {
                self.welcome.text = speech;
            } else {
                self.welcome.text = speech;
            }
        });
    } failure:^(AIRequest *request, NSError *error) {
        // Handle error ...
    }];
    
    [self.apiAI enqueue:request];
}

- (void)stop {
    self.isRecording = false;
    [self.audioEngine.inputNode removeTapOnBus:0];
    [self.audioEngine stop];
    [self.recognitionTask cancel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setTitle:@"I am looking for..." forState:UIControlStateNormal];
        self.recordButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    });
}

- (NSDictionary *)keywordSearch:(NSString *)text
{
        NSString* path = @"https://uksouth.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases";
        
        NSMutableURLRequest* _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
        [_request setHTTPMethod:@"POST"];
        // Request headers
        [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_request setValue:@"e76d6d65d71c43bfa5e8d21be0d3dd30" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
        // Request body
        [_request setHTTPBody:[[NSString stringWithFormat:@"{\"documents\":[{\"language\": \"en\", \"id\": 1,\"text\":\"%@\"}]}", text] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData* _connectionData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        
        if (nil != error)
        {
            NSLog(@"Error: %@", error);
        }
        else
        {
            NSError* error = nil;
            NSMutableDictionary* json = nil;
            NSString* dataString = [[NSString alloc] initWithData:_connectionData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", dataString);
            
            if (nil != _connectionData)
            {
                json = [NSJSONSerialization JSONObjectWithData:_connectionData options:NSJSONReadingMutableContainers error:&error];
            }
            
            if (error || !json)
            {
                NSLog(@"Could not parse loaded json with error:%@", error);
            }
            
            NSLog(@"%@", json);
            _connectionData = nil;
            
            return json;
        }
    return nil;
}

- (BOOL)findSimilarity:(NSString *)s1 and:(NSString *)s2 {
    NSString* path = [NSString stringWithFormat:@"https://westus.api.cognitive.microsoft.com/academic/v1.0/similarity?s1=%@&%@", s1, s2];
    
    NSMutableURLRequest* _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [_request setHTTPMethod:@"POST"];
    // Request headers
    [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:@"e76d6d65d71c43bfa5e8d21be0d3dd30" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData* _connectionData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
    
    if (nil != error)
    {
        NSLog(@"Error: %@", error);
    }
    else
    {
        NSError* error = nil;
        NSMutableDictionary* json = nil;
        NSString* dataString = [[NSString alloc] initWithData:_connectionData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", dataString);
        
        if (nil != _connectionData)
        {
            json = [NSJSONSerialization JSONObjectWithData:_connectionData options:NSJSONReadingMutableContainers error:&error];
        }
        
        if (error || !json)
        {
            NSLog(@"Could not parse loaded json with error:%@", error);
        }
        
        NSLog(@"%@", json);
        _connectionData = nil;
        
        return false;
    }
    
    return false;
}



- (NSDictionary *)bingSearch:(NSString *)keyword
{
    NSString* path = [NSString stringWithFormat:@"https://api.cognitive.microsoft.com/bing/v7.0/entities/?q=%@&mkt=en-us&count=5&offset=0&safesearch=Moderate", [keyword stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSMutableURLRequest* _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [_request setHTTPMethod:@"GET"];
    // Request headers
    [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:@"7155ef8c9bde4ff4bdaf3f2057cb21b8" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData* _connectionData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
    
    if (nil != error)
    {
        NSLog(@"Error: %@", error);
    }
    else
    {
        NSError* error = nil;
        NSMutableDictionary* json = nil;
        NSString* dataString = [[NSString alloc] initWithData:_connectionData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", dataString);
        
        if (nil != _connectionData)
        {
            json = [NSJSONSerialization JSONObjectWithData:_connectionData options:NSJSONReadingMutableContainers error:&error];
        }
        
        if (error || !json)
        {
            NSLog(@"Could not parse loaded json with error:%@", error);
        }
        
        NSLog(@"%@", json);
        _connectionData = nil;
        
        return json;
    }
    
    return @{};
}

@end
