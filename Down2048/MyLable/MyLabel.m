//
//  MyLable.m
//  Down2048
//
//  Created by XiongJian on 14-8-27.
//  Copyright (c) 2014年 com.Static. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:124/255.0 blue:95/255.0 alpha:0.7];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
