//
//  PercentView.m
//  NerdFeed
//
//  Created by zhaoqihao on 14-9-3.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "PercentView.h"

@implementation PercentView
@synthesize percent=_percent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 40, 40)];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self.layer setCornerRadius:20];
        CAShapeLayer *spinLayerBg=[[CAShapeLayer alloc]init];
        [spinLayerBg setBounds:self.bounds];
        [spinLayerBg setPosition:CGPointMake(20, 20)];
        [spinLayerBg setFillColor:nil];
        [spinLayerBg setLineCap:kCALineCapRound];
        
        NSUInteger spinWidthBg= 4;
        
        spinLayerBg.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:(self.bounds.size.width - spinWidthBg) / 2.f startAngle:0 endAngle:M_PI * 2 clockwise:YES] CGPath];
        spinLayerBg.lineWidth = spinWidthBg;
        spinLayerBg.strokeColor = [[UIColor colorWithWhite:1 alpha:0.3] CGColor];
        [self.layer addSublayer:spinLayerBg];
        
        
        spinLayer=[[CAShapeLayer alloc]init];
        [spinLayer setBounds:self.bounds];
        [spinLayer setPosition:CGPointMake(20, 20)];
        [spinLayer setFillColor:nil];
        [spinLayer setLineCap:kCALineCapRound];

        NSUInteger spinWidth = 4 ;
        
        spinLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:(self.bounds.size.width - spinWidth) / 2.f startAngle:0 endAngle:M_PI clockwise:YES] CGPath];
        spinLayer.lineWidth = spinWidth;
        spinLayer.strokeColor = [[UIColor colorWithWhite:0 alpha:0.7] CGColor];
        
        [self.layer addSublayer:spinLayer];
        
        [self spinAnimation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spinAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

-(id)initInView:(UIView *)view
{
    CGRect percentViewRect = CGRectMake((view.bounds.size.width - 40) / 2.f, (view.bounds.size.height - 40) / 2.f, 0, 0);
    
    return [self initWithFrame:percentViewRect];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)spinAnimation
{
    if(!spinAnimation){
        spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [spinAnimation setToValue:[NSNumber numberWithFloat:M_PI * INTMAX_MAX]];
        [spinAnimation setDuration:INTMAX_MAX / 1.2];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->spinLayer addAnimation:self->spinAnimation forKey:@"spinAnimation"];
    });    
}

-(void)setPercent:(NSInteger)percent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_percent=percent;
        [self setNeedsDisplay];
    });
}

-(void)drawRect:(CGRect)rect
{
    NSString *percentText;
    UIFont *font;
    
    if(!_percent){
        percentText = @"";
        font = [UIFont boldSystemFontOfSize:18];
    }else{
        percentText = [[NSString stringWithFormat:@"%d",(int)_percent]stringByAppendingString:@"%"];
        font = [UIFont boldSystemFontOfSize:20];
    }
    
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    CGRect textRect = [percentText boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil];
    
    textRect.origin.x = (self.bounds.size.width - textRect.size.width) / 2.f;
    textRect.origin.y = (self.bounds.size.height - textRect.size.height) / 2.f;
    
    [percentText drawInRect:textRect withAttributes:attrDict];
}

@end
