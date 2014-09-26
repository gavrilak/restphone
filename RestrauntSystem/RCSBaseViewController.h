//
//  RCSBaseViewController.h
//  RestaurantControlSystem
//
//  Created by Bogdan Stasjuk on 02/12/2013.
//  Copyright (c) 2013 BestApp Studio. All rights reserved.
//

@protocol RCSBaseViewControllerDelegate;

@interface RCSBaseViewController : UIViewController

@property(nonatomic, assign) id<RCSBaseViewControllerDelegate> delegate;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, assign) CGRect viewFrame;

- (void)setupBackBtn;
- (void)setupLblAmountWithBtnOrder:(BOOL)isBtnOrderExist;
- (void)setSumWhenTableId:(NSUInteger)sumOrder;
- (void)enabledMakeOrder:(BOOL)state;
- (void)setupVirtualListBtn;
- (void)setupStopListBtn;

# pragma mark - Unavailable methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("initWithNibName:bundle: not available")));
- (id)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("initWithCoder: not available")));

- (void)customTitle:(NSString*)title;
@end


@protocol RCSBaseViewControllerDelegate <NSObject>

@optional
- (void)btnOrderPressed;

@end
