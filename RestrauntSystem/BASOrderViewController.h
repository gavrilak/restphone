//
//  BASOrderViewController.h
//  RestrauntSystem
//
//  Created by Sergey on 10.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BASOrderViewController : RCSBaseViewController

@property(nonatomic,strong)NSDictionary* contentData;
@property(nonatomic,strong)NSDictionary* titleInfo;
@property(nonatomic,assign)BOOL isTitle;
@end
