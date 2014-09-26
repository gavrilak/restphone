//
//  BASModifyView.h
//  RestrauntSystem
//
//  Created by Sergey on 31.07.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BASModifyView;

@protocol BASModifyViewDelegate <NSObject>

@optional
- (void)doneClicked:(BASModifyView*)view withContent:(NSArray*)content;

@end


@interface BASModifyView : UIView

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign)id<BASModifyViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withContent:(NSArray*)contentData  withDelegate:(id<BASModifyViewDelegate>)obj;
@end
