//
//  BASNoticeTableViewCell.m
//  RestrauntSystem
//
//  Created by Sergey on 06.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASNoticeTableViewCell.h"

@interface BASNoticeTableViewCell()

@property(nonatomic, strong) UIImageView *separator;
@property(nonatomic, strong) UILabel *textView;

@end

@implementation BASNoticeTableViewCell

- (void)setNoticeState:(NoticeState)noticeState
{
    _noticeState = noticeState;
    
    UIImage *stateImg = [self getStateImg];
    self.accessoryView = [[UIImageView alloc] initWithImage:stateImg];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.textView.text = title;
    [self.textView sizeToFit];
}

- (void)setSeparatorEnabled:(BOOL)separatorEnabled
{
    _separatorEnabled = separatorEnabled;
    if (_separatorEnabled) {
        
        if (!self.separator) {
            
            [self setupSeparator];
        }
        self.separator.hidden = NO;
        
    } else {
        
        self.separator.hidden = YES;
    }
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withContent:(NSDictionary*)contentData;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentData = [NSDictionary dictionaryWithDictionary:contentData];
        self.backgroundColor = [UIColor blackColor];
        

        self.textView = [UILabel new];
        self.textView.font = [Settings font:FontForNoticesCellTitle];
        self.textView.textColor = [Settings color:ColorForNoticesCellTitle];
        self.textView.backgroundColor = [Settings color:ColorForViewsBgDebug];
        self.textView.numberOfLines = 2;
        self.textView.lineBreakMode = NSLineBreakByWordWrapping;
        [self.textView setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_textView];
        
        self.title = (NSString*)[_contentData objectForKey:@"message"];
        NSNumber *state = (NSNumber*)[_contentData objectForKey:@"message_status"];
        self.noticeState = (NoticeState)[state integerValue];
       
        NSNumber *type = (NSNumber*)[_contentData objectForKey:@"message_type"];
        UIImage *typeImg = [self getIconNoticeType:type];
        self.imageView.image = typeImg;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    [_textView setFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 15.f, 0 , self.contentView.frame.size.width - 80.f, self.contentView.frame.size.height)];
   // [self configSeparatorWithLeft:[Settings floatValue:FloatValueForNoticesSeparatLeft]
              //     andRightOffset:[Settings floatValue:FloatValueForNoticesSeparatRightOffset]];
    
  
}
- (void)setCornerRadius
{
    [self setCornerRadiusWhenRectCorner:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight)];
}
- (void)setTopCornerRadius
{
    [self setCornerRadiusWhenRectCorner:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}

- (void)setBottomCornerRadius
{
    [self setCornerRadiusWhenRectCorner:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
}
- (void)setFrame:(CGRect)frame
{
    CGFloat horizOffset = [Settings floatValue:FloatValueForNoticesCellHorizOffset];
    frame.origin.x += horizOffset;
    frame.size.width -= horizOffset * 2;
    [super setFrame:frame];
    
    [super setClipsToBounds:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public methods

- (UIImage*)getIconNoticeType:(NSNumber *)noticeType
{
    UIImage *img = nil;
    switch (noticeType.integerValue) {
        case NoticeTypeAdmin:
            img = [Settings image:ImageForNoticesIconAdmin];
            break;
        case NoticeTypeKitchen:
            img = [Settings image:ImageForNoticesIconKitchen];
            break;
        case NoticeTypeBar:
            img = [Settings image:ImageForNoticesIconBar];
            break;
            
        default:
            break;
    }
    return img;
}
- (UIImage *)getStateImg
{
    UIImage *img = nil;
    switch (_noticeState) {
        case NoticeStateFulfilled:
            img = [Settings image:ImageForNoticesIconFulfilled];
            break;
        case NoticeStateUnfulfilled:
            img = [Settings image:ImageForNoticesIconUnfulfilled];
            break;
        default:
            break;
    }
    return img;
}

#pragma mark - Private methods
- (void)configSeparatorWithLeft:(CGFloat)left andRightOffset:(CGFloat)rightOffset
{
    if (self.separatorEnabled) {
        
        CGRect separatorFrame = self.separator.frame;
        separatorFrame.origin.x = left;// 15.f;
        separatorFrame.origin.y = self.frame.size.height - separatorFrame.size.height;
        separatorFrame.size.width = self.frame.size.width - separatorFrame.origin.x - rightOffset;// 10.f;
        //separatorFrame.size.width -= 5.f;
        self.separator.frame = separatorFrame;
    }
}
- (void)setupSeparator
{
    self.separator = [[UIImageView alloc] initWithImage:[Settings image:ImageForNoticesTableSeparator]];
    [self.contentView addSubview:self.separator];
}
- (void)setCornerRadiusWhenRectCorner:(UIRectCorner)rectCorner
{
    CGFloat cornerRadius = [Settings floatValue:FloatValueForNoticesCornerRadius];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.clipsToBounds = YES;
}

@end
