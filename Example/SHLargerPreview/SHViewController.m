//
//  SHViewController.m
//  SHLargerPreview
//
//  Created by suoxiaoxiao on 06/12/2019.
//  Copyright (c) 2019 suoxiaoxiao. All rights reserved.
//

#import "SHViewController.h"
#import <UIImageView+WebCache.h>
#import <LookBigPicViewController.h>

@interface SHViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (nonatomic , strong) NSArray *sources;

@end

@implementation SHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sources = @[@"http://gss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/d788d43f8794a4c25eb379a40df41bd5ac6e39a8.jpg",
         @"http://pic4.nipic.com/20090826/1412106_040106033282_2.jpg",
         @"http://pic31.nipic.com/20130715/10837242_141415632109_2.jpg"];
    
    [self.image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(jump:)]];
    [self.image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(jump:)]];
    [self.image3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(jump:)]];
    
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:self.sources[0]]];
    [self.image2 sd_setImageWithURL:[NSURL URLWithString:self.sources[1]]];
    [self.image3 sd_setImageWithURL:[NSURL URLWithString:@"http://pic31.nipic.com/20130715/10837242_141415632109_2.jpg"]];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)jump:(UIGestureRecognizer *)ges {
    
    LookBigPicViewController *vc = [[LookBigPicViewController alloc] init];
    [vc configAllImageUrlArray:self.sources
                    andTargets:[ges view]
                      andIndex:[ges view].tag];
    
    [vc pushChildViewControllerWithArray:@[self.image1,self.image2,self.image3]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
