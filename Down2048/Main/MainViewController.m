//
//  MainViewController.m
//  Down2048
//
//  Created by XiongJian on 14-8-26.
//  Copyright (c) 2014年 com.Static. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () {
    NSTimer *StandbyTimer, *downTimer;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self addBackGround];
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData {
    self.locationArray = [NSMutableArray arrayWithObjects:
                          [NSNumber numberWithInt:11],
                          [NSNumber numberWithInt:12],
                          [NSNumber numberWithInt:13],
                          [NSNumber numberWithInt:14],
                          [NSNumber numberWithInt:15],
                          [NSNumber numberWithInt:16],

                          [NSNumber numberWithInt:21],
                          [NSNumber numberWithInt:22],
                          [NSNumber numberWithInt:23],
                          [NSNumber numberWithInt:24],
                          [NSNumber numberWithInt:25],
                          [NSNumber numberWithInt:26],

                          [NSNumber numberWithInt:31],
                          [NSNumber numberWithInt:32],
                          [NSNumber numberWithInt:33],
                          [NSNumber numberWithInt:34],
                          [NSNumber numberWithInt:35],
                          [NSNumber numberWithInt:36],

                          [NSNumber numberWithInt:41],
                          [NSNumber numberWithInt:42],
                          [NSNumber numberWithInt:43],
                          [NSNumber numberWithInt:44],
                          [NSNumber numberWithInt:45],
                          [NSNumber numberWithInt:46],

                          [NSNumber numberWithInt:51],
                          [NSNumber numberWithInt:52],
                          [NSNumber numberWithInt:53],
                          [NSNumber numberWithInt:54],
                          [NSNumber numberWithInt:55],
                          [NSNumber numberWithInt:56],

                          [NSNumber numberWithInt:61],
                          [NSNumber numberWithInt:62],
                          [NSNumber numberWithInt:63],
                          [NSNumber numberWithInt:64],
                          [NSNumber numberWithInt:65],
                          [NSNumber numberWithInt:66],

                          nil];

    [self bornStandbyLabelAndDownLabel];
}

#pragma mark - action
- (void)bornStandbyLabelAndDownLabel {
    self.standbyLable = [[MyLabel alloc]init];
    self.standbyLable.number = arc4random()%100 + 1;
    [self.standbyLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];

    self.standbyLable.location = arc4random()%COLUMN_NUM + 1;
    self.standbyLable.frame = CGRectMake(48*(self.standbyLable.location-1)+self.standbyLable.location*4, 4, 48, 48);
    [self.gameView addSubview:self.standbyLable];

    self.downLable = [[MyLabel alloc]init];
    self.downLable.number = arc4random()%100 + 1;
    [self.downLable setText:[NSString stringWithFormat:@"%d",self.downLable.number]];

    self.downLable.location = 10 + arc4random()%COLUMN_NUM + 1;
    self.downLable.frame = CGRectMake(48*(self.downLable.location%10-1)+self.downLable.location%10*4, 4 + 52, 48, 48);
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
    self.downLable.frame = CGRectMake(48*(self.standbyLable.location-1)+self.standbyLable.location*4, 4 + 52, 48, 48);

    self.standbyLable.number = arc4random()%100 + 1;
    [self.standbyLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];

    self.standbyLable.location = arc4random()%COLUMN_NUM + 1;
    self.standbyLable.frame = CGRectMake(48*(self.standbyLable.location-1)+self.standbyLable.location*4, 4, 48, 48);

    downTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveDownLabel) userInfo:nil repeats:YES];
}

- (void)moveDownLabel {
    int indexColumn = self.downLable.location%10;
    int indexRow = self.downLable.location/10;

    if (indexRow == ROW_NUM) {
        // Have been the bottom of the GameView
        [downTimer invalidate];

        [self changeStandbyLabel];
    } else if (1 == 2) {

    } else {
        // Move one step down.
        int x = 48*(indexColumn-1) + indexColumn*4;
        int y = 4 + 52*(indexRow+1);
        self.downLable.frame = CGRectMake(x, y, 48, 48);

        self.downLable.location = (indexRow+1)*10 +indexColumn;
    }
}

- (CGRect)caculateDownLabelLocation:(int)location {


    return CGRectMake(0, 0, 0, 0);
}


#pragma mark - initLayout
-(void)addBackGround
{
    self.gameView=[[UIImageView alloc] initWithFrame:CGRectMake(2, 80, 316, 368)];
    self.gameView.userInteractionEnabled=YES;
    [self.view addSubview:self.gameView];

    UIGraphicsBeginImageContext(self.gameView.frame.size);
    [self.gameView.image drawInRect:self.gameView.frame];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapButt);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 238/255.0, 228/255.0, 218/255.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());

    // 边框
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 314, 2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 314, 366);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 2, 366);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 2, 2);

    // 竖线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 54, 52);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 54, 364);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 106, 52);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 106, 364);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 158, 52);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 158, 364);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 210, 52);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 210, 364);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 262, 52);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 262, 364);

    // 横线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 4, 54);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, 54);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 4, 106);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, 106);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 4, 158);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, 158);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 4, 210);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, 210);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 4, 262);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, 262);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 4, 314);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 312, 314);

    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.gameView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

//    [self testLable:14];
}

- (void)testLable:(int)y {
    UIImageView *test0 = [[UIImageView alloc]initWithFrame:CGRectMake(4+2, 68+2+y, 48, 48)];
    [self.view addSubview:test0];
    test0.backgroundColor = [UIColor greenColor];
    UIImageView *test1 = [[UIImageView alloc]initWithFrame:CGRectMake(56+2, 120+2+y, 48, 48)];
    [self.view addSubview:test1];
    test1.backgroundColor = [UIColor greenColor];
    UIImageView *test2 = [[UIImageView alloc]initWithFrame:CGRectMake(108+2, 172+2+y, 48, 48)];
    [self.view addSubview:test2];
    test2.backgroundColor = [UIColor greenColor];
    UIImageView *test3 = [[UIImageView alloc]initWithFrame:CGRectMake(160+2, 224+2+y, 48, 48)];
    [self.view addSubview:test3];
    test3.backgroundColor = [UIColor greenColor];
    UIImageView *test4 = [[UIImageView alloc]initWithFrame:CGRectMake(212+2, 276+2+y, 48, 48)];
    [self.view addSubview:test4];
    test4.backgroundColor = [UIColor greenColor];
    UIImageView *test5 = [[UIImageView alloc]initWithFrame:CGRectMake(264+2, 328+2+y, 48, 48)];
    [self.view addSubview:test5];
    test5.backgroundColor = [UIColor greenColor];
    UIImageView *test6 = [[UIImageView alloc]initWithFrame:CGRectMake(264+2, 380+2+y, 48, 48)];
    [self.view addSubview:test6];
    test6.backgroundColor = [UIColor greenColor];
}

@end
