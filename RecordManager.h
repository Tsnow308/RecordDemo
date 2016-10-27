//
//  RecordManager.h
//  RecordDemo
//
//  Created by 郭正茂 on 16/10/26.
//  Copyright © 2016年 ldjt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordManager : NSObject
@property(nonatomic,copy)void (^audioPowerChangeBlock)(float power);
-(id)initWithPath:(NSString*)path;
-(void)beginRecord;
-(void)pauseRecord;
-(void)stopRecord;
@end
