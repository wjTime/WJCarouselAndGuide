//
//  WJCarouselAndGuide.m
//  WJCarouselAndGuide
//
//  Created by 高文杰 on 16/3/8.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#import "WJCarouselAndGuide.h"



@interface WJCarouselAndGuide (){
    
    UIScrollView *_src;
    NSArray *_imageArray;
    NSArray *_urlArray;
    NSInteger _currentPage;
    NSUInteger _count;
    BOOL _isRepeat;
    BOOL _isTiming;
    NSTimer *_timer;
    BOOL _isGuide;
    BOOL _isShowLastPageBtn;
    
    
}

@end

@implementation WJCarouselAndGuide

-(void)showFirstTimeGuide:(NSArray *)imageArray isShowLastPageBtn:(BOOL)show{
    _isShowLastPageBtn = show;
    _isGuide = YES;
    if (![self isLaunchFirst]) {
        [self removeAdvert];
        return;
    }
    
    _imageArray = [NSArray arrayWithArray:imageArray];
    [self customView];
    [self reloadData];
}

-(void)showImages:(NSArray *)imageArray urls:(NSArray *)urlArray isRepeat:(BOOL)isRepeat isTiming:(BOOL)isTiming {
    _imageArray = [NSArray arrayWithArray:imageArray];
    _urlArray = [NSArray arrayWithArray:urlArray];
    _isRepeat = isRepeat;
    _isTiming = isTiming;
    [self customView];
    [self reloadData];
}

- (BOOL)isLaunchFirst{
    NSUserDefaults *userTimes = [NSUserDefaults standardUserDefaults];
    NSString *times = [userTimes objectForKey:@"WJLaunchTimes"];
    if (times.length) {
        NSInteger number = [times integerValue];
        number ++;
        [userTimes setObject:[NSString stringWithFormat:@"%ld",number] forKey:@"WJLaunchTimes"];
        [userTimes synchronize];
        return NO;
    }else{
        [userTimes setObject:@"1" forKey:@"WJLaunchTimes"];
        [userTimes synchronize];
        return YES;
    }
    
}

- (void)setImageArray:(NSArray *)imageArray{
    
    _imageArray = [NSArray arrayWithArray:imageArray];
    
}


//重写父类方法
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //定制view
        //[self customView];
        
    }
    return self;
}
-(void)customView{
    
    //    if (_isGuide) {
    //        if (![self isLaunchFirst]) {
    //            return;
    //        }
    //    }
    
    //创建ScrollView
    _src= [[UIScrollView alloc]initWithFrame:self.bounds];
    _src.backgroundColor = [UIColor blackColor];
    _src.pagingEnabled = YES;
    _src.showsHorizontalScrollIndicator = NO;
    _src.bounces = NO;
    _src.delegate = self;
    [self addSubview:_src];
    
}
//刷新数据
-(void)reloadData{
    
    
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(150, self.frame.size.height-30, 100, 30)];
    
    
    if (_isRepeat) {
        
        NSUInteger number = _imageArray.count;
        NSMutableArray *repeatArray = [NSMutableArray arrayWithArray:_imageArray];
        NSMutableArray *repeatUrlArray = [NSMutableArray arrayWithArray:_urlArray];
        
        [repeatArray insertObject:_imageArray[number-1] atIndex:0];
        [repeatUrlArray insertObject:_urlArray[number-1] atIndex:0];
        
        [repeatArray addObject:_imageArray[0]];
        [repeatUrlArray addObject:_urlArray[0]];
        
        
        _count = repeatArray.count;
        
        for (int i = 0; i < _count; i++) {
            UIButton *imageView = [[UIButton alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [imageView setBackgroundImage:[UIImage imageNamed:repeatArray[i]] forState:UIControlStateNormal];
            [imageView addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [imageView setTitle:repeatUrlArray[i] forState:UIControlStateNormal];
            [imageView setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [_src addSubview:imageView];
            
        }
        
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = repeatArray.count - 2;
        _currentPage = 1;
        _src.contentSize = CGSizeMake(repeatArray.count*self.frame.size.width, self.frame.size.height);
        _src.contentOffset = CGPointMake(self.frame.size.width,0);
    }else{
        
        for (int i = 0; i < _imageArray.count; i++) {
            UIButton *imageView = [[UIButton alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [imageView setBackgroundImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
            imageView.tag = 900 + i;
            [imageView setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [imageView setTitle:_urlArray[i] forState:UIControlStateNormal];
            [imageView addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [_src addSubview:imageView];
            
            if (i == _imageArray.count - 1 && _isShowLastPageBtn) {
    
                self.button = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 22, 60, 30)];
                self.button.titleLabel.font = [UIFont systemFontOfSize:12];
                [self.button setTitle:@"点击进入" forState:UIControlStateNormal];
                self.button.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
                [self.button addTarget:self action:@selector(removeAdvert) forControlEvents:UIControlEventTouchUpInside];
                self.button.layer.cornerRadius = 3;
                self.button.layer.masksToBounds = YES;
                [imageView addSubview:self.button];
               
            }
            
            
        }
        _pageControl.numberOfPages = _imageArray.count;
        _src.contentSize = CGSizeMake(_imageArray.count*self.frame.size.width, self.frame.size.height);
        if ([_delegate respondsToSelector:@selector(hideTabBarOrNavBar:)]) {
            [_delegate hideTabBarOrNavBar:YES];
        }
    }
    
    [self addSubview:_pageControl];
    
    if (_isTiming && _isRepeat) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(repeatCircle) userInfo:nil repeats:YES];
    }
    
}

- (void)click:(UIButton *)button{
    
    if (_isGuide) {
        if (button.tag == 899 + _imageArray.count && self.clickLastPageCanDissmiss) {
            [self removeAdvert];
        }else{
            button.userInteractionEnabled = NO;
        }
    }else{
        if ([_delegate respondsToSelector:@selector(clickWithUrl:)] && _delegate) {
            [_delegate clickWithUrl:button.titleLabel.text];
        }
    }
}

- (void)repeatCircle{
    
    CGPoint point = CGPointMake(_src.contentOffset.x + self.frame.size.width, 0);
    
    [UIView animateWithDuration:0.7 animations:^{
        _src.contentOffset = CGPointMake(point.x, point.y);
    }];
    
    [self contentOffsetAndPage];
    
}

- (void)contentOffsetAndPage{
    
    CGPoint point = _src.contentOffset;
    
    if (_isRepeat) {
        
        if (point.x == 0) {
            _src.contentOffset = CGPointMake(self.frame.size.width * (_count - 2), 0);
        }
        if (point.x == self.frame.size.width * (_count - 1)) {
            _src.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
        
        _currentPage = _src.contentOffset.x/self.frame.size.width;
        _pageControl.currentPage = _currentPage-1;
        
        
    }else{
        
        _pageControl.currentPage = point.x/self.frame.size.width;
        
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [_timer invalidate];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self contentOffsetAndPage];
    
    if (_isTiming && _isRepeat) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(repeatCircle) userInfo:nil repeats:YES];
    }
    
    
}
- (void)removeAdvert{
    
    _timer = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(hideTabBarOrNavBar:)]) {
            [_delegate hideTabBarOrNavBar:NO];
        }
        [self removeFromSuperview];
        
    }];
    
    
}

- (void)dealloc{
    _timer = nil;
    NSLog(@"dealloc");
}





@end
