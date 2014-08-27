//
//  MainViewController.h
//  Down2048
//
//  Created by XiongJian on 14-8-26.
//  Copyright (c) 2014年 com.Static. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLabel.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define COLUMN_NUM 6
#define ROW_NUM 6
#define LABEL_HEIGHT iPhone5 ? 48 : 40
#define LABEL_WIDTH 48
#define SPACE_WIDTH 4

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *labelArray;

@property (strong, nonatomic) MyLabel *standbyLable;
@property (strong, nonatomic) MyLabel *downLable;
@property (strong, nonatomic) UIImageView *gameView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestLabel;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIView *btnView;

- (IBAction)clickVoice:(id)sender;
- (IBAction)clickStart:(id)sender;
- (IBAction)clickRestart:(id)sender;
- (IBAction)clickShare:(id)sender;

@end
