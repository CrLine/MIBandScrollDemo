//
//  CircleView.m
//  ScrollDemo
//
//  Created by Jason Li on 5/7/15.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "CircleView.h"
#include <math.h>
@implementation CircleView



- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    //设置画布的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    //画圆
    CGContextAddArc(context, SCREEN_WIDTH/2, 150, 110, -0.45*M_PI, 1.45*M_PI, 0);
    //CGContextSetFillColorWithColor(context, [UIColor  blueColor].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    //画格子
    for (int i=0; i<180; i++) {
        //计算角度
        float a=-0.5+2.0/180*i;
        CGPoint aPoint=[self initPointA:a];
        CGPoint bPoint=[self initPointB:a];
        CGPoint points[2];
        points[0]=aPoint;
        points[1]=bPoint;
        CGContextAddLines(context, points, 2);
        //根部百分率算出角度
        if(_percent>1||_percent<0)
        {
            _percent=0;
        }
        float b=-0.5+_percent*2.0;
        if (a<b) {
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        }else
        {
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        }
        
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    //CGContextMoveToPoint(context,  SCREEN_WIDTH/2+2,40);
    //CGContextAddArc(context, SCREEN_WIDTH/2+2, 40, 7, -0.6*M_PI, 0.1*M_PI, 1);
    //CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    //CGContextDrawPath(context, kCGPathFillStroke);
    UIImage *image;
    if (_type==0) {
        image=[UIImage imageNamed:@"sleep_icon@2x"];
    }else if (_type==1)
    {
        image=[UIImage imageNamed:@"activity_icon@2x"];
    }else
    {
    image=[UIImage imageNamed:@"s-run_time"];
    }
    [image drawInRect:CGRectMake(SCREEN_WIDTH/2-10, 31, 20, 20)];
    
    //关闭画布
    CGContextClosePath(context);
    
    
}


- (CGPoint)initPointA:(float)a
{
    //根据圆心、半径、计算圆上每一点得位置
    //圆心（x0,y0) 半径 r 角度a0
    //圆上任意一点为
    //x1=x0+r*cos(a0*3.14/180)
    //y1=y0+r*sin(a0*3.14/180)
    float ax=SCREEN_WIDTH/2.0+80*cos(a*M_PI);
    float ay=150+80*sin(a*M_PI);
    CGPoint aPoint=CGPointMake(ax, ay);
    return aPoint;
}

- (CGPoint)initPointB:(float)b
{
    //根据圆心、半径、计算圆上每一点得位置
    float bx=SCREEN_WIDTH/2.0+95*cos(b*M_PI);
    float by=150+95*sin(b*M_PI);
    CGPoint bPoint=CGPointMake(bx, by);
    return bPoint;
}
@end
