//
//  BASAppDelegate.h
//  ;
//
//  Created by Sergey on 03.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

// TextForApiFuncAuth
// TextForApiFuncMenuItemFormat
// TextForApiFuncMenuCats
// TextForApiFuncMenuDishesFormat
// TextForApiFuncGetUnreadNoticeCnt
// TextForApiFuncGetNotifies
// TextForApiFuncMakeOrderFormat
// TextForApiFuncHalls
// CALCULATEORDER - id order

#import <UIKit/UIKit.h>
#import "Settings.h"

@class BASTabbarViewController;
@class RCSAuthViewController;


@interface BASAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController* navController;
@property (nonatomic, strong) BASTabbarViewController* tabBarController;
@property (nonatomic, strong) RCSAuthViewController* authController;
@property (nonatomic, assign) UserType userType;
@property (nonatomic, assign) NSUInteger noticeCnt;
@property (nonatomic, assign) BOOL isNotice;
@property (nonatomic, assign) BOOL isBackground;
@property (nonatomic, assign) BOOL isOrder;
@property (nonatomic, assign) BOOL isModify;
@property (nonatomic, assign) BOOL isWaiter;
@property (nonatomic, assign) BOOL isShowMessage;
@property (nonatomic, strong) NSDictionary* employeeInfo;
@property (nonatomic, strong) NSArray* orders;
@property (nonatomic, assign) NSUInteger curCoastOrder;
@property (nonatomic, assign) NSUInteger addCoastOrder;
@property (nonatomic, assign) NSUInteger id_table;
@property (nonatomic, assign) NSUInteger id_order;
@property (nonatomic, strong) NSDictionary* titleInfo;
@property (nonatomic, strong) NSString* noticeMessage;
@property (nonatomic, assign) SwitchType switchType;
@property (nonatomic, strong) NSArray* curOrderList;
@property (nonatomic, strong) NSArray* addOrderList;
@property (nonatomic, strong) NSMutableArray* preOrderObjects;

- (NSArray*)sortContent:(NSArray*)source withType:(SwitchType)type;
- (void)deletePreOrderObjects;
- (NSArray*)loadPreOrderObjects;
- (BOOL)isPreOrderTable;
- (void)startbackgroundTask;
- (BOOL) is4InchScreen;
- (void)setNoticeCnt:(NSUInteger)noticeCnt;
- (NSString*)formatMessage:(NSString*)message;

@end
