//
//  CTSpeechToText.h
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 13.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CTSpeechToText;
@protocol CTSpeechToTextDelegate <NSObject>
@required
- (void)speechToText:(CTSpeechToText *)speechToText didRecognizeUtterance:(NSString *)utterance utteranceId:(NSString *)utteranceId;
- (void)speechToText:(CTSpeechToText *)speechToText isReconigizingUtterance:(NSString *)utterance utteranceId:(NSString *)utteranceId;
- (void)speechToTextDidCancel:(CTSpeechToText *)speechToText;
@end

@interface CTSpeechToText : NSObject
@property (nonatomic, assign) id<CTSpeechToTextDelegate> delegate;
@property (nonatomic, assign) BOOL isPlaying;
- (void)startRecognizing;
- (void)stopRecognizing;

- (void)recognizeUtterance:(void (^)(NSString *))completionBlock;
@end

NS_ASSUME_NONNULL_END
