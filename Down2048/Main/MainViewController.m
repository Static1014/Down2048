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
    UIImageView *ad;

    int score;
    int bestScore;

    BOOL isPlaying;
    BOOL overFlg;
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
    isPlaying = NO;
    overFlg = NO;

    score = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"BEST_SCORE"] == nil) {
        bestScore = 0;
    } else {
        bestScore = [(NSNumber*)[defaults objectForKey:@"BEST_SCORE"] intValue];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    self.bestLabel.text = [NSString stringWithFormat:@"%d",bestScore];

    self.labelArray = [NSMutableArray arrayWithCapacity:36];
}

#pragma mark - action

- (void)bornStandbyLabelAndDownLabel {
    if (self.standbyLable == nil) {
        self.standbyLable = [[MyLabel alloc]init];
    }
    self.standbyLable.number = arc4random()%2 ? DOWN_NUM1 : DOWN_NUM2;
    [self.standbyLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];

    self.standbyLable.location = arc4random()%COLUMN_NUM + 1;
    self.standbyLable.frame = CGRectMake(LABEL_WIDTH*(self.standbyLable.location-1)+self.standbyLable.location*SPACE_WIDTH, SPACE_WIDTH, LABEL_WIDTH, LABEL_HEIGHT);
    [self.gameView addSubview:self.standbyLable];

    if (self.downLable == nil) {
        self.downLable = [[MyLabel alloc]init];
    }
    self.downLable.number = arc4random()%2 ? DOWN_NUM1 : DOWN_NUM2;
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
    /*
     *  Check Game Over
     *  If there is a Label with different number at this new location, game over;
     *
     */
    switch ([self checkGameOver]) {
        case GAME_OVER:
            isPlaying = NO;
            [self updateBestScore];

            [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
            [self.startBtn setTitle:@"Start" forState:UIControlStateHighlighted];

            [self.downLable removeFromSuperview];
            self.standbyLable.backgroundColor = [UIColor redColor];

            [downTimer invalidate];
            downTimer = nil;

            [self showGameOverAlert];
            break;

        case GAME_SAME:
            for (MyLabel *temp in self.labelArray) {
                if (self.standbyLable.location + 10 == temp.location) {
                    temp.number *= 2;
                    [temp setText:[NSString stringWithFormat:@"%d",temp.number]];
                    [self updateScore];

                    [self changeStandbyLabel];
                }
            }
            break;

        case GAME_CONTINUE:
            self.downLable.number = self.standbyLable.number;
            [self.downLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];
            self.downLable.location = 10 + self.standbyLable.location;
            self.downLable.frame = CGRectMake(LABEL_WIDTH*(self.standbyLable.location-1)+self.standbyLable.location*SPACE_WIDTH, SPACE_WIDTH*2 + (LABEL_HEIGHT), LABEL_WIDTH, LABEL_HEIGHT);

            self.standbyLable.number = arc4random()%2 ? DOWN_NUM1 : DOWN_NUM2;
            [self.standbyLable setText:[NSString stringWithFormat:@"%d",self.standbyLable.number]];
            self.standbyLable.backgroundColor = [UIColor colorWithRed:106/255.0 green:214/255.0 blue:125/255.0 alpha:0.7];

            self.standbyLable.location = arc4random()%COLUMN_NUM + 1;
//            self.standbyLable.location = 2;
            self.standbyLable.frame = CGRectMake(LABEL_WIDTH*(self.standbyLable.location-1)+self.standbyLable.location*SPACE_WIDTH, SPACE_WIDTH, LABEL_WIDTH, LABEL_HEIGHT);

            downTimer = [NSTimer scheduledTimerWithTimeInterval:Time target:self selector:@selector(moveDownLabel) userInfo:nil repeats:YES];
            break;

        default:
            break;
    }
}

- (void)showGameOverAlert {
    UIAlertView *gameOverAlert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"Game Over" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Restart", nil];
    gameOverAlert.tag = 10;
    [gameOverAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            [self clickRestart:nil];
        } else {
            overFlg = YES;
        }
    }
}

- (void)updateScore {
    score += ONE_STEP_SCORE;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",score];
}

- (void)updateBestScore {
    if (score > bestScore) {
        bestScore = score;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInt:bestScore] forKey:@"BEST_SCORE"];
        [defaults synchronize];

        self.bestLabel.text = [NSString stringWithFormat:@"%d",bestScore];
    }
}

- (int)checkGameOver {
    for (MyLabel *temp in self.labelArray) {
        if (self.standbyLable.location + 10 == temp.location) {
            return self.standbyLable.number != temp.number?GAME_OVER:GAME_SAME;
        }
    }

    return GAME_CONTINUE;
}

- (void)moveDownLabel {
    int indexColumn = self.downLable.location%10;
    int indexRow = self.downLable.location/10;

    if (indexRow == ROW_NUM) {
        //  Have been the bottom of the GameView.
        [downTimer invalidate];
        downTimer = nil;
        [self createNewLabel];
        
        [self changeStandbyLabel];
    } else {
        if ([self checkExistLabelAtNext] != nil) {
            //  There is a Label below DownLable.
            [downTimer invalidate];
            downTimer = nil;

            MyLabel *existLabel = [self checkExistLabelAtNext];
            if (existLabel.number == self.downLable.number) {
                existLabel.number *= 2;
                [existLabel setText:[NSString stringWithFormat:@"%d",existLabel.number]];

                [self updateScore];
            } else {
                [self createNewLabel];
            }

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

- (MyLabel*)checkExistLabelAtNext {
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
- (void)initBtnView {
    //    [self.labelView setFrame:CGRectMake(0, 20, 320, iPhone5?60:50)];
    //    [self.btnView setFrame:CGRectMake(0, iPhone5?448:320, 320, 70)];
    
}

-(void)initGameView
{
    self.gameView=[[UIImageView alloc] initWithFrame:CGRectMake(2, iPhone5?80:70, 316, SPACE_WIDTH*8+(LABEL_HEIGHT)*7)];
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

#pragma mark - Buttons Actions
- (IBAction)clickVoice:(id)sender {

}

- (IBAction)clickStart:(id)sender {
    if (overFlg) {
        overFlg = NO;
        [self clickRestart:nil];
        return;
    }

    if (isPlaying) {
        //  Pause game.
        [self showAds:YES];
        
        isPlaying = NO;
        [self.startBtn setTitle:@"Resume" forState:UIControlStateNormal];
        [self.startBtn setTitle:@"Resume" forState:UIControlStateHighlighted];

        [downTimer invalidate];
        downTimer = nil;
    } else {
        //  Start or resume game.
        [self showAds:NO];

        isPlaying = YES;
        [self.startBtn setTitle:@"Pause" forState:UIControlStateNormal];
        [self.startBtn setTitle:@"Pause" forState:UIControlStateHighlighted];

        if (self.downLable == nil) {
            [self bornStandbyLabelAndDownLabel];
        } else {
            downTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveDownLabel) userInfo:nil repeats:YES];
            [self moveDownLabel];
        }
    }

}

- (IBAction)clickRestart:(id)sender {
    [downTimer invalidate];
    downTimer = nil;

    [self showAds:NO];
    for (MyLabel *temp in self.labelArray) {
        [temp removeFromSuperview];
    }
    [self.labelArray removeAllObjects];
    [self.standbyLable removeFromSuperview];
    [self.downLable removeFromSuperview];

    isPlaying = YES;
    overFlg = NO;
    [self updateBestScore];
    score = 0;
    self.scoreLabel.text = @"0";
    [self.startBtn setTitle:@"Pause" forState:UIControlStateNormal];
    [self.startBtn setTitle:@"Pause" forState:UIControlStateHighlighted];
    [self bornStandbyLabelAndDownLabel];
}

- (IBAction)clickShare:(id)sender {
}

- (void)showAds:(BOOL)show {
    if (ad == nil) {
        ad = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, self.gameView.frame.size.width-40, self.gameView.frame.size.height-20)];
        ad.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    }

    if (show) {
        [self.gameView addSubview:ad];
    } else {
        if (ad != nil) {
            [ad removeFromSuperview];
        }
    }
}
@end
