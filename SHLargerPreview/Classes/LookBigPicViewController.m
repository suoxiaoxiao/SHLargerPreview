//
//  PicViewController.m
//  LookBigPic
//
//  Created by apple on 15/10/13.
//  Copyright © 2015年 xincheng. All rights reserved.
//

#import "LookBigPicViewController.h"
#import "PicImgScrollView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define DurationTime 0.5

typedef NS_ENUM(NSInteger,PushType) {
    PushTypeFromVC,
    PushTypeFromView
};


@interface LookBigPicViewController ()<UIScrollViewDelegate>
{
    UIImageView *snapShotView;
    UIView *zhezhaoView;
}


@property(nonatomic,retain)UIScrollView *bigScr;
@property(nonatomic,retain)NSArray *smallImgArr;
@property(nonatomic,retain)NSArray *bigImgArr;


@property (nonatomic,retain)UILabel *pageLable;
@property (nonatomic,retain)NSArray *titleArr;


/**保证当前图片放大（忘记缩小）划出屏幕回到原状*/
@property(nonatomic,assign)CGPoint currentContentOffSet;

/**当前选中的index*/
@property(nonatomic,assign)NSInteger index;

/**上界面传进来的view(UIImageView|UIButton)数组*/
@property(nonatomic,retain)NSArray *smallImgViewArr;

/**push 类型 */
@property(nonatomic,assign)PushType pushType;

@end

@implementation LookBigPicViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        _bigScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH + 20, HEIGHT)];
        _bigScr.delegate = self;
        _bigScr.backgroundColor = [UIColor blackColor];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    _bigScr.contentSize = CGSizeMake((WIDTH + 20) * _bigImgArr.count, HEIGHT);
    _bigScr.pagingEnabled = YES;
    _bigScr.contentOffset = CGPointMake(_index * (WIDTH + 20) ,0);
    
    _currentContentOffSet = CGPointMake(_bigScr.contentOffset.x, _bigScr.contentOffset.y);
   __weak typeof(self)weakSelf = self;
    for (int i = 0; i < _bigImgArr.count;i++) {
        PicImgScrollView *scr = [[PicImgScrollView alloc]initWithFrame:CGRectMake(i * (WIDTH + 20),0,WIDTH,HEIGHT)];
        scr.contentSize = CGSizeMake(WIDTH, HEIGHT);
//        scr.topVcImgStr = _bigImgArr[_index];
        [scr initWithBigImgUrl:_bigImgArr[i] smallImageUrl:_smallImgArr[i]];
        
        scr.singleTapClick = ^(UIImageView *imageView){
            
            [weakSelf popChildViewControllerWithImage:imageView];

        };
        
        [_bigScr addSubview:scr];
    }
    
    for (int i = 0 ; i < [self.titleArr count]; i++) {
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(i * (WIDTH + 20), HEIGHT - 120, WIDTH,40)];
        lable.text = self.titleArr[i];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:16];
        [_bigScr addSubview:lable];
    }

    [self.view addSubview:_bigScr];
    
}


-(void)configAllImageUrlArray:(NSArray *)imageArray andTargets:(id)targert andIndex:(NSInteger)index
{
    [self configAllBigUrlArray:imageArray andSmallUrlArray:imageArray andTargets:targert andIndex:index];
}


-(void)configAllBigUrlArray:(NSArray *)bigUrlArray andSmallUrlArray:(NSArray*)smallUrlArr andTargets:(id)targert andIndex:(NSInteger)index
{
    _bigImgArr = bigUrlArray;
    _smallImgArr = smallUrlArr;
    _index = index;
    
    snapShotView = [[UIImageView alloc]init];
    snapShotView.contentMode = UIViewContentModeScaleAspectFill;
    snapShotView.clipsToBounds = YES;
    zhezhaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    zhezhaoView.backgroundColor = [UIColor blackColor];
    zhezhaoView.alpha = 0.0;
    
    
    self.pageLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 65, 40, 50, 50)];
    self.pageLable.center = CGPointMake(WIDTH / 2.f, HEIGHT - 40);
    
    self.pageLable.font = [UIFont systemFontOfSize:17];;
    self.pageLable.text = [NSString stringWithFormat:@"%ld/%lu",(long)_index+1,(unsigned long)_bigImgArr.count];
    self.pageLable.textColor = [UIColor whiteColor];
    self.pageLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pageLable];
    
}


#pragma mark ------------- scrollViewDelegate --------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pages = scrollView.contentOffset.x / scrollView.frame.size.width;
    _index = pages;
    
     self.pageLable.text = [NSString stringWithFormat:@"%ld/%lu",_index+1,(unsigned long)_bigImgArr.count];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x == _currentContentOffSet.x ) {
        return;
    }
    _currentContentOffSet.x = scrollView.contentOffset.x;
    for (id scr in scrollView.subviews) {
        if ([[scr class] isSubclassOfClass:[UIScrollView class]]) {
            [scr resetZoom];
        }
    }
}

#pragma mark -------------- 从上界面点击位置转场pop -------------------------

-(void)pushChildViewControllerWithArray:(NSArray *)viewArray
{
    self.pushType = PushTypeFromView;
    
    self.smallImgViewArr = viewArray;
    
    //转场之前 判断内存中是否有小图和大图  只要是其中一个不满足就从中心push
    NSString *smallkey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_smallImgArr[_index]]];
   BOOL isExitSmallImg = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:smallkey];
    
    NSString *bigkey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_bigImgArr[_index]]];
     BOOL isExitBigImg = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:bigkey];
    
    if (isExitSmallImg && isExitBigImg) {
        
        [self pushAnimation];

    }else
    {
        [self pushChildViewControllerFromCenter];
    }

}

+ (UIWindow *)gainCurrentWindow {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (window == nil) {
        window = [UIApplication sharedApplication].keyWindow;
        if (window == nil) {
            window = [[UIApplication sharedApplication].windows lastObject];
        }
    }
    return window;
}

-(void)pushAnimation
{
    
    UIView *touchView = self.smallImgViewArr[_index];
    CGRect rect = [touchView convertRect:touchView.bounds toView:[LookBigPicViewController gainCurrentWindow]];
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view setClipsToBounds:YES];
    self.view.alpha = 0;
    UIView *currentModelView = self.smallImgViewArr[self.index];
    if ([currentModelView isKindOfClass:[UIImageView class]]) {
        self->snapShotView.contentMode = currentModelView.contentMode;
    }
    
    [[LookBigPicViewController gainCurrentWindow] addSubview:self.view];
    [[LookBigPicViewController gainCurrentWindow].rootViewController addChildViewController:self];
    
    [[LookBigPicViewController gainCurrentWindow] addSubview:self->zhezhaoView];
    [[LookBigPicViewController gainCurrentWindow] addSubview:self->snapShotView];

    snapShotView.frame = rect;

    [snapShotView sd_setImageWithURL:[NSURL URLWithString:_smallImgArr[_index]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (self->snapShotView.image == nil) {
            [[LookBigPicViewController gainCurrentWindow] addSubview:self.view];
            return;
        }
        __weak typeof(self)wself = self;
        CGFloat scale = self->snapShotView.image.size.width / self->snapShotView.image.size.height;
        [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            __strong typeof(wself)sself = wself;
            sself->zhezhaoView.alpha = 1.0;
            sself->snapShotView.bounds = CGRectMake(0, 0, WIDTH,WIDTH / scale);
            
            //如果是长图
            if (sself->snapShotView.bounds.size.height > HEIGHT) {
                sself->snapShotView.center = CGPointMake(WIDTH / 2.f, sself->snapShotView.bounds.size.height / 2.f);
            }else
            {
                sself->snapShotView.center = CGPointMake(WIDTH / 2.f,HEIGHT / 2.f);
            }
            
            
        } completion:^(BOOL finished) {
            self.view.alpha = 1;
            [self->snapShotView removeFromSuperview];
            [self->zhezhaoView removeFromSuperview];
        }];

    }];

}

#pragma mark -------------- 从上界面点击位置转场pop -------------------------

-(void)popChildViewControllerWithImage:(UIImageView *)imageView
{

    //如果push方式是viewControllerPush的话 单击 功能将失去。
    if (self.pushType != PushTypeFromView) {
     
        return;
    }
    
    //如果是从中心进场的 也只能从中心退出
    if (self.smallImgViewArr == nil) {
        [self popChildViewControllerFromCenter];
        return;
    }
    
    //判断大图是否被加载到了内存中
    NSString *smallkey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_smallImgArr[_index]]];
    BOOL isSmallImgExit = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:smallkey];
//    BOOL isSmallImgExit = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:smallkey];
    
    NSString *bigkey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_bigImgArr[_index]]];
    BOOL isBigImgExit = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:bigkey];
//    BOOL isBigImgExit = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:bigkey];
    
    
    if (isBigImgExit&&isSmallImgExit) {
        [self popAnimation:imageView];
    }else
    {
        [self popChildViewControllerFromCenter];

    }
}

-(void)popAnimation:(UIImageView *)imageView
{
    
    snapShotView.image = imageView.image;
    
    UIView *view = (UIView *)[_smallImgViewArr objectAtIndex:_index];
    CGRect rect = [view convertRect:view.bounds toView:[LookBigPicViewController gainCurrentWindow]];
    
    CGRect rect1 = [imageView convertRect:imageView.bounds toView:[LookBigPicViewController gainCurrentWindow]];
    
    snapShotView.frame = rect1;
    
    [[LookBigPicViewController gainCurrentWindow] addSubview:zhezhaoView];
    [[LookBigPicViewController gainCurrentWindow] addSubview:snapShotView];
    [self.view removeFromSuperview];
    
    
    [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self->zhezhaoView.alpha = 0.0;
        self->snapShotView.frame = rect;
        
    } completion:^(BOOL finished) {
        
        [self->snapShotView removeFromSuperview];
        [self->zhezhaoView removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark -------------- 从中心转场push -------------------------

-(void)pushChildViewControllerFromCenter
{
    self.pushType = PushTypeFromView;
    
    [[LookBigPicViewController gainCurrentWindow] addSubview:self.view];
    [[LookBigPicViewController gainCurrentWindow].rootViewController addChildViewController:self];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:DurationTime animations:^{
        self.view.alpha = 1.0;
    }];
    
}
#pragma mark -------------- 从中心转场pop -------------------------


-(void)popChildViewControllerFromCenter
{
    
    [UIView animateWithDuration:DurationTime animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}

-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
