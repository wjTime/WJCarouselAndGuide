# WJCarouselAndGuide
a easy  photo carousel and app first time start show guide view fram 图片轮播 引导页
// WJCarouselAndGuide可用于启动页面、也可用于图片轮播
    
    // 功能二: 显示图片轮播
    [self showLaunchAdvert];
    
    // 功能一: 显示启动页面（引导页面不需要新建页面）
    [self showGuideView];
    
    
}
//---------------------------------------------引导页面Demo-------------------------------------------
// 显示启动引导页面
- (void)showGuideView{
    
    // 创建引导页面的adview
    WJCarouselAndGuide *adview = [[WJCarouselAndGuide alloc]initWithFrame:self.view.bounds];
    
    // 设置代理
    adview.delegate = self;
    
    // 参数一：展示的图片名  参数二:点击图片对应的url  参数三:是否可循环重复滚动  参数四:是否设置定时自动滚动 (要定时自动播放 isRepeat的值也必须是YES)
    [adview showFirstTimeGuide:@[@"1",@"2",@"3"]];
    
    // 设置pageControl的颜色等各种属性
    adview.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    adview.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    // 添加视图
    [self.view addSubview:adview];
}
//  代理方法隐藏顶部导航栏或TabBar状态栏
- (void)hideTabBarOrNavBar:(BOOL)hide{
    if (hide) {
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
    }
}
//---------------------------------------------引导页面Demo-------------------------------------------






//---------------------------------------------图片定时轮播Demo-------------------------------------------
// 显示图片轮播页面
- (void)showLaunchAdvert{
    // 创建adview
    CGRect frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
    WJCarouselAndGuide *adview = [[WJCarouselAndGuide alloc]initWithFrame:frame];
    // 设置代理
    adview.delegate = self;
    // 参数一：展示的图片名  参数二:点击图片对应的url  参数三:是否可循环重复滚动  参数四:是否设置定时自动滚动 (要定时自动播放 isRepeat的值也必须是YES)
    [adview showImages:@[@"4",@"5",@"6"] urls:@[@"www.baidu.com",@"www.sina.com.cn",@"www.163.com"] isRepeat:YES isTiming:YES];
    // pageControl的颜色设置
    adview.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    adview.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    // 添加视图
    [self.view addSubview:adview];
}

// 图片轮播点击事件代理回调
- (void)clickWithUrl:(NSString *)url{
    __block UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = [NSString stringWithFormat:@"点击的url是:%@",url];
    lb.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    lb.alpha = 0.0;
    [UIView animateWithDuration:1 animations:^{
        lb.alpha = 1;
    }];
    [self.view addSubview:lb];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            lb.alpha = 0.0;
        } completion:^(BOOL finished) {
            [lb removeFromSuperview];
        }];
    });
}
//---------------------------------------------图片定时轮播Demo-------------------------------------------
