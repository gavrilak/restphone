//
//  BASNoticeTableViewCell.h
//  RestrauntSystem
//
//  Created by Sergey on 06.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BASNoticeTableViewCell : UITableViewCell

@property(nonatomic,strong)  NSDictionary* contentData;

@property(nonatomic, strong) NSString       *title;
@property(nonatomic, assign) BOOL           separatorEnabled;
@property(nonatomic, assign) NoticeState    noticeState;

- (void)setCornerRadius;
- (void)setBottomCornerRadius;
- (void)setTopCornerRadius;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withContent:(NSDictionary*)contentData;


@end
