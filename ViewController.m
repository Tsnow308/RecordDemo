//
//  ViewController.m
//  RecordDemod
//
//  Created by 郭正茂 on 16/10/26.
//  Copyright © 2016年 ldjt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)RecordManager *recordManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    NSString *path=[NSString stringWithFormat:@"%@/sound.caf",documentsDirectory];
    UIProgressView *progress=[[UIProgressView alloc] initWithFrame:CGRectMake(10, 200, 300, 4)];
    [self.view addSubview:progress];
    
    self.recordManager=[[RecordManager alloc] initWithPath:path];
    self.recordManager.audioPowerChangeBlock=^(float f){
        [progress setProgress:f];
    };
    UIButton *beginRecordBT=[UIButton buttonWithType:UIButtonTypeCustom];
    beginRecordBT.frame=CGRectMake(10, 60, 60, 30) ;
    [beginRecordBT setBackgroundColor:[UIColor orangeColor]];
    [beginRecordBT setTitle:@"录音" forState:UIControlStateNormal];
    [self.view addSubview:beginRecordBT];
    [beginRecordBT addTarget:self action:@selector(beginRecordAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pauseRecordBT=[UIButton buttonWithType:UIButtonTypeCustom];
    pauseRecordBT.frame=CGRectMake(10, 100, 60, 30);
    [pauseRecordBT setBackgroundColor:[UIColor orangeColor]];
    [pauseRecordBT setTitle:@"暂停" forState:UIControlStateNormal];
    [self.view addSubview:pauseRecordBT];
    [pauseRecordBT addTarget:self action:@selector(pauseRecordAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopRecordBT=[UIButton buttonWithType:UIButtonTypeCustom];
    [stopRecordBT setBackgroundColor:[UIColor orangeColor]];
    stopRecordBT.frame=CGRectMake(10, 140, 60, 30);
    [stopRecordBT setTitle:@"停止" forState:UIControlStateNormal];
    [self.view addSubview:stopRecordBT];
    [stopRecordBT addTarget:self action:@selector(stopRecordAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)beginRecordAction{
    [self.recordManager beginRecord];
}
-(void)pauseRecordAction{
    [self.recordManager pauseRecord];
}
-(void)stopRecordAction{
    [self.recordManager stopRecord];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
