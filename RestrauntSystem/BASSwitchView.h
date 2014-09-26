//
//  BASSwitchView.h
//  RestrauntSystem
//
//  Created by Sergey on 12.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol BASSwitchViewDelegate;


@interface BASSwitchView : UIView

@property(nonatomic, assign) id<BASSwitchViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withType:(SwitchType)type withViewType:(BOOL)isNotify;

@end


@protocol BASSwitchViewDelegate <NSObject>

@required
- (void)swithClicked:(BASSwitchView*)view withType:(SwitchType)type;

@end