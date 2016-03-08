//
//  WJCarouselAndGuide.h
//  WJCarouselAndGuide
//
//  Created by 高文杰 on 16/3/8.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJCarouselAndGuideDelegate <NSObject>

- (void)clickWithUrl:(NSString *)url;
- (void)hideTabBarOrNavBar:(BOOL)hide;
@end

@interface WJCarouselAndGuide : UIView

@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,weak) id<WJCarouselAndGuideDelegate>delegate;

/**
 * 显示启动引导页面
 */
-(void)showFirstTimeGuide:(NSArray *)imageArray;

/**
 * 显示广告轮播
 */
-(void)showImages:(NSArray *)imageArray urls:(NSArray *)urlArray isRepeat:(BOOL)isRepeat isTiming:(BOOL)isTiming;

/**
 * 移除广告轮播
 */
- (void)removeAdvert;
@end
