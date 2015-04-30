//
//  RCSBaseViewController.m
//  RestaurantControlSystem
//
//  Created by Bogdan Stasjuk on 02/12/2013.
//  Copyright (c) 2013 BestApp Studio. All rights reserved.
//

#import "RCSBaseViewController.h"

@interface RCSBaseViewController ()

@property(nonatomic, strong) UILabel *lblSum;
@property(nonatomic, strong) UIButton *orderBtn;

@end


@implementation RCSBaseViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setupBgImg];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self enabledMakeOrder:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self customTitle:@""];
    
    [super viewWillDisappear:animated];
    
}
#pragma mark - Public methods

- (void)setSumWhenTableId:(NSUInteger)sumOrder{
    
    [self.lblSum setText:[NSString stringWithFormat:@"%d",sumOrder]];
    if(sumOrder == 0)
        [self.lblSum setText:@""];
  
}

- (void)setupBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [Settings image:ImageForNavBarBtnBack];
    btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnBackPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}
- (void)setupStopListBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"stop_list_button.png"];
    btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnStopListPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}
- (void)setupVirtualListBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"stop_list_button.png"];
    btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.width);
    [btn setImage:[UIImage imageNamed:@"virt_table_btn.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnVirtualListPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void)setupLblAmountWithBtnOrder:(BOOL)isBtnOrderExist
{
    [self initLblAmount];

    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.lblSum.frame.size.width, self.lblSum.frame.size.height)];
    [customView addSubview:self.lblSum];

    if (isBtnOrderExist) {
        
        self.orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *btnImg = [Settings image:ImageForMenuBtnOrder];
        _orderBtn.frame = CGRectMake((self.lblSum.frame.size.width - btnImg.size.width) / 2, self.lblSum.frame.size.height, btnImg.size.width, btnImg.size.height);
        [_orderBtn setImage:btnImg forState:UIControlStateNormal];
        [_orderBtn addTarget:self action:@selector(btnOrderPressed) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect customViewFrame = customView.frame;
        customViewFrame.size.height += _orderBtn.frame.size.height;
        customView.frame = customViewFrame;
        
        [customView addSubview:_orderBtn];
    }
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void)enabledMakeOrder:(BOOL)state{
    [_orderBtn setEnabled:state];
}
#pragma mark - Actions
- (void)btnStopListPressed{
    
}
- (void)btnVirtualListPressed{
    
}
- (void)btnOrderPressed
{
    if ([self.delegate respondsToSelector:@selector(btnOrderPressed)]) {
        
        [self.delegate btnOrderPressed];
    }
}

- (void)btnBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Private methods

- (void)customTitle:(NSString*)title{
    
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;

    CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y -= 20.f;
    self.titleLabel = [[UILabel alloc] initWithFrame:rect];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _titleLabel.shadowColor = [Settings color:ColorForNavBarTitleShadow];
    _titleLabel.shadowOffset = [Settings offset:OffsetForNavBarTitleShadow];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [Settings color:ColorForNavBarTitle];
    [self.navigationController.navigationBar addSubview:_titleLabel];
 
    _titleLabel.text = title;

}

- (void)initLblAmount
{
    UIImage *lblImg = [Settings image:ImageForMenuLblAmount];
    self.lblSum = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, lblImg.size.width, lblImg.size.height)];
    self.lblSum.backgroundColor = [UIColor colorWithPatternImage:lblImg];
    self.lblSum.textAlignment = NSTextAlignmentCenter;
    self.lblSum.font = [Settings font:FontForLblAmount];
    self.lblSum.textColor = [Settings color:ColorForLblAmount];
}


#pragma mark - Private methods

- (void)setupBgImg
{
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[Settings image:ImageForControllerViewBg]];
    CGFloat bgImgTop = 0;//  [Settings isIpad] ? 0 : [Settings image:ImageForNavBarBg].size.height;
    bgImg.frame = CGRectMake(bgImg.frame.origin.x,
                             bgImgTop,
                             [Settings screenWidth],
                             [Settings screenHeight] - [Settings image:ImageForNavBarBg].size.height - [Settings image:ImageForTabBarBg].size.height);
    
    self.viewFrame = bgImg.frame;
    
    [self.view addSubview:bgImg];

}

@end
