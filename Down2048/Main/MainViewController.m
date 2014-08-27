//
//  MainViewController.m
//  Down2048
//
//  Created by XiongJian on 14-8-26.
//  Copyright (c) 2014年 com.Static. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () {
    NSTimer *downTimer;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initBtnView];
    
    [self initGameView];
    
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData {
    self.labelArray = [NSMutableArray arrayWithCapacity:36];

    [self bornStandbyLabelAndDownLabel];
}

#pragma mark - action
- (void)bornStandbyLabelAndDownLabel {
    self.standbyLable = [[MyLabel alloc]init];
    self.standbyLable.number = arc4random()%10 + 1;
    [self.standbyLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];

    self.standbyLable.location = arc4random()%COLUMN_NUM + 1;
    self.standbyLable.frame = CGRectMake(LABEL_WIDTH*(self.standbyLable.location-1)+self.standbyLable.location*SPACE_WIDTH, SPACE_WIDTH, LABEL_WIDTH, LABEL_HEIGHT);
    [self.gameView addSubview:self.standbyLable];

    self.downLable = [[MyLabel alloc]init];
    self.downLable.number = arc4random()%10 + 1;
    [self.downLable setText:[NSString stringWithFormat:@"%d",self.downLable.number]];

    self.downLable.location = 10 + arc4random()%COLUMN_NUM + 1;
    self.downLable.frame = CGRectMake(LABEL_WIDTH*(self.downLable.location%10-1)+self.downLable.location%10*SPACE_WIDTH, SPACE_WIDTH*2 + LABEL_WIDTH, LABEL_WIDTH, LABEL_HEIGHT);
    [self.gameView addSubview:self.downLable];

    [self changeStandbyLabel];
}

/*
 *  Change the location of StandbyLabel
 *  DownLabel go back to 1st row.
 *  It alse means that the old StandbyLabel becomes the DownLabel.
 */
- (void)changeStandbyLabel {
    self.downLable.number = self.standbyLable.number;
    [self.downLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];
    self.downLable.location = 10 + self.standbyLable.location;
    self.downLable.frame = CGRectMake(LABEL_WIDTH*(self.standbyLable.location-1)+self.standbyLable.location*SPACE_WIDTH, SPACE_WIDTH*2 + (LABEL_HEIGHT), LABEL_WIDTH, LABEL_HEIGHT);

    self.standbyLable.number = arc4random()%10 + 1;
    [self.standbyLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];
    self.standbyLable.backgroundColor = [UIColor colorWithRed:106/255.0 green:214/255.0 blue:125/255.0 alpha:0.7];

    self.standbyLable.location = arc4random()%COLUMN_NUM + 1;
    self.standbyLable.frame = CGRectMake(LABEL_WIDTH*(self.standbyLable.location-1)+self.standbyLable.location*SPACE_WIDTH, SPACE_WIDTH, LABEL_WIDTH, LABEL_HEIGHT);

    downTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveDownLabel) userInfo:nil repeats:YES];
}

- (void)moveDownLabel {
    int indexColumn = self.downLable.location%10;
    int indexRow = self.downLable.location/10;

    if (indexRow == ROW_NUM) {
        //  Have been the bottom of the GameView.
        [downTimer invalidate];
        [self createNewLabel];
        
        [self changeStandbyLabel];
    } else {
        if ([self checkExistLabel] != nil) {
            //  There is a Label below DownLable.
            [downTimer invalidate];

            MyLabel *existLabel = [self checkExistLabel];
            existLabel.number += self.downLable.number;
            [existLabel setText:[NSString stringWithFormat:@"%d",existLabel.number]];

            [self changeStandbyLabel];
        } else {
            //  Move one step down.
            int x = LABEL_WIDTH*(indexColumn-1) + indexColumn*SPACE_WIDTH;
            int y = SPACE_WIDTH + ((LABEL_HEIGHT)+SPACE_WIDTH)*(indexRow+1);
            self.downLable.frame = CGRectMake(x, y, LABEL_WIDTH, LABEL_HEIGHT);

            self.downLable.location = (indexRow+1)*10 +indexColumn;
        }
    }
}

- (MyLabel*)checkExistLabel {
    for (MyLabel *temp in self.labelArray) {
        if (self.downLable.location + 10 == temp.location) {
            return temp;
        }
    }
    return nil;
}

- (void)createNewLabel {
    int indexColumn = self.downLable.location%10;
    int indexRow = self.downLable.location/10;
    MyLabel *newLabel = [[MyLabel alloc]init];

    newLabel.location = 10*indexRow + indexColumn;
    [newLabel setFrame:CGRectMake(LABEL_WIDTH*(indexColumn-1) + indexColumn*SPACE_WIDTH, SPACE_WIDTH + (SPACE_WIDTH+(LABEL_HEIGHT))*indexRow, LABEL_WIDTH, LABEL_HEIGHT)];

    newLabel.number = self.downLable.number;
    newLabel.tag = self.downLable.number;
    [newLabel setText:[NSString stringWithFormat:@"%d",self.downLable.number]];

    [self.gameView addSubview:newLabel];
    [self.labelArray addObject:newLabel];
}


#pragma mark - initLayout
-(void)initGameView
{
    self.gameView=[[UIImageView alloc] initWithFrame:CGRectMake(2, iPhone5?80:70, 316, SPACE_WIDTH*8+(LABEL_HEIGHT)*7 + 50)];
    self.gameView.userInteractionEnabled=YES;
    [self.view addSubview:self.gameView];

    UIGraphicsBeginImageContext(self.gameView.frame.size);
    [self.gameView.image drawInRect:self.gameView.frame];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapButt);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), SPACE_WIDTH);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 238/255.0, 228/255.0, 218/255.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());

    // 边框
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 314, SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 314, (SPACE_WIDTH*8+(LABEL_HEIGHT)*7)-2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH/2, (SPACE_WIDTH*8+(LABEL_HEIGHT)*7)-2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH/2, SPACE_WIDTH/2);

    // 竖线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 54, SPACE_WIDTH+(LABEL_HEIGHT)+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 54, SPACE_WIDTH*7+(LABEL_HEIGHT)*7);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 106, SPACE_WIDTH+(LABEL_HEIGHT)+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 106, SPACE_WIDTH*7+(LABEL_HEIGHT)*7);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 158, SPACE_WIDTH+(LABEL_HEIGHT)+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 158, SPACE_WIDTH*7+(LABEL_HEIGHT)*7);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 210, SPACE_WIDTH+(LABEL_HEIGHT)+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 210, SPACE_WIDTH*7+(LABEL_HEIGHT)*7);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 262, SPACE_WIDTH+(LABEL_HEIGHT)+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 262, SPACE_WIDTH*7+(LABEL_HEIGHT)*7);

    // 横线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH, (SPACE_WIDTH+(LABEL_HEIGHT))*1+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, (SPACE_WIDTH+(LABEL_HEIGHT))*1+SPACE_WIDTH/2);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH, (SPACE_WIDTH+(LABEL_HEIGHT))*2+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, (SPACE_WIDTH+(LABEL_HEIGHT))*2+SPACE_WIDTH/2);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH, (SPACE_WIDTH+(LABEL_HEIGHT))*3+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, (SPACE_WIDTH+(LABEL_HEIGHT))*3+SPACE_WIDTH/2);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH, (SPACE_WIDTH+(LABEL_HEIGHT))*4+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, (SPACE_WIDTH+(LABEL_HEIGHT))*4+SPACE_WIDTH/2);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH, (SPACE_WIDTH+(LABEL_HEIGHT))*5+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, (SPACE_WIDTH+(LABEL_HEIGHT))*5+SPACE_WIDTH/2);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), SPACE_WIDTH, (SPACE_WIDTH+(LABEL_HEIGHT))*6+SPACE_WIDTH/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, (SPACE_WIDTH+(LABEL_HEIGHT))*6+SPACE_WIDTH/2);

    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.gameView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)initBtnView {
//    [self.labelView setFrame:CGRectMake(0, 20, 320, iPhone5?60:50)];
//    [self.btnView setFrame:CGRectMake(0, iPhone5?448:320, 320, 70)];
}

- (IBAction)clickVoice:(id)sender {
}

- (IBAction)clickStart:(id)sender {
}

- (IBAction)clickRestart:(id)sender {
}

- (IBAction)clickShare:(id)sender {
}
@end
