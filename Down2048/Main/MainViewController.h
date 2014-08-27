//
//  MainViewController.h
//  Down2048
//
//  Created by XiongJian on 14-8-26.
//  Copyright (c) 2014年 com.Static. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLabel.h"

#define COLUMN_NUM 6
#define ROW_NUM 6

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *labelArray;

@property (strong, nonatomic) MyLabel *standbyLable;
@property (strong, nonatomic) MyLabel *downLable;
@property (strong, nonatomic) UIImageView *gameView;

@property (strong, nonatomic) IBOutlet UIButton *voiceBtn;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIButton *restartBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UILabel *scoreLable;
@property (strong, nonatomic) IBOutlet UILabel *bestLable;
@end
