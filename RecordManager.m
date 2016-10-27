//
//  RecordManager.m
//  RecordDemo
//
//  Created by 郭正茂 on 16/10/26.
//  Copyright © 2016年 ldjt. All rights reserved.
//

#import "RecordManager.h"
#import <AVFoundation/AVFoundation.h>
@interface RecordManager()<AVAudioRecorderDelegate>
@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)NSTimer *timer;
@end
@implementation RecordManager
-(id)initWithPath:(NSString*)path{
    self=[super init];
    if (self) {
        NSURL *url=[NSURL fileURLWithPath:path];
        NSError *error=nil;
        self.audioRecorder=[[AVAudioRecorder alloc] initWithURL:url settings:[self defualtSettings] error:&error];
        self.audioRecorder.meteringEnabled = YES;
        self.audioRecorder.delegate=self;
        if(error){
             NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
        }
        self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
        self.timer.fireDate=[NSDate distantFuture];
    }
    return self;
}
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    NSLog(@"%f",progress);
    if (self.audioPowerChangeBlock) {
        self.audioPowerChangeBlock(progress);
    }
//    [self.audioPower setProgress:progress];
}
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
-(NSMutableDictionary*)defualtSettings{
    NSMutableDictionary* recordSettings=[[NSMutableDictionary alloc] init];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    return recordSettings;
}
-(void)beginRecord{
    if(![self.audioRecorder isRecording]){
        [self.audioRecorder prepareToRecord];
        [self.audioRecorder record];
        self.timer.fireDate=[NSDate distantPast];
    }
}
-(void)pauseRecord{
    if([self.audioRecorder isRecording]){
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantPast];
    }
}
-(void)stopRecord{
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    if (self.audioPowerChangeBlock) {
        self.audioPowerChangeBlock(0.0);
    }
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
//    if (![self.audioPlayer isPlaying]) {
//        [self.audioPlayer play];
//    }
    NSLog(@"录音完成!");
}
@end
