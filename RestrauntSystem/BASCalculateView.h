//
//  BASCalculateView.h
//  RestrauntSystem
//
//  Created by Sergey on 17.07.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BASCalculateView;

@protocol BASCalculateViewDelegate <NSObject>

@optional
- (void)doneClicked:(BASCalculateView*)view;

@end
@interface BASCalculateView : UIView

@property (nonatomic,strong)NSString* price;
@property (nonatomic, assign)id<BASCalculateViewDelegate>delegate;


@end
