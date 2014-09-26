//
//  BASTabbarViewController.h
//  RestrauntSystem
//
//  Created by Sergey on 03.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BASTablesController.h"
#import "BASMenuController.h"
#import "BASOrdersController.h"
#import "BASNotiffController.h"

@interface BASTabbarViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, strong) BASTablesController* tablesController;
@property (nonatomic, strong) BASMenuController* menuController;
@property (nonatomic, strong) BASOrdersController* ordersController;
@property (nonatomic, strong) BASNotiffController* notificationsController;

- (void)clearNoticesCount;
- (void)showNoticesCount:(NSUInteger)noticesCnt;

@end
