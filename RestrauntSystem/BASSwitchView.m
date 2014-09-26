//
//  BASSwitchView.m
//  RestrauntSystem
//
//  Created by Sergey on 12.06.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASSwitchView.h"

@interface BASSwitchView(){
    BOOL isNotify;
}

@property (nonatomic,strong)UIImageView* bgImageView;
@property (nonatomic,assign)SwitchType type;
@property (nonatomic,strong)UIButton* curButton;
@property (nonatomic,strong)UIButton* allbutton;

@end

@implementation BASSwitchView

- (void)setType:(SwitchType)type{
    _type = type;
    UIImage* image = nil;
    switch (_type) {
        case ALLSWITCH:{
            image = [UIImage imageNamed:@"all_orders_bg"];
            if(isNotify)
                image = [UIImage imageNamed:@"read_s"];
        }
            break;
        case CURRENTSWITCH:{
            image = [UIImage imageNamed:@"current_orders_bg"];
            if(isNotify)
                image = [UIImage imageNamed:@"unread_s"];
        }
            break;
            
        default:
            break;
    }
    self.bgImageView.image = image;
}
- (id)initWithFrame:(CGRect)frame withType:(SwitchType)type withViewType:(BOOL)_isNotify
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        isNotify = _isNotify;
        self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x + 10.f, frame.origin.y + 10.f, frame.size.width - 20.f, frame.size.height - 20.f)];
        
        [_bgImageView setBackgroundColor:[UIColor clearColor]];
        self.type = type;
        [self addSubview:_bgImageView];
        
        self.curButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_curButton setBackgroundColor:[UIColor clearColor]];
        [_curButton setFrame:CGRectMake(_bgImageView.frame.origin.x, _bgImageView.frame.origin.y - 10.f, _bgImageView.frame.size.width / 2, 30.f)];
        [_curButton addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_curButton];
        
        self.allbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allbutton setBackgroundColor:[UIColor clearColor]];
        [_allbutton setFrame:CGRectMake(_bgImageView.frame.origin.x +_bgImageView.frame.size.width / 2, _bgImageView.frame.origin.y - 10.f, _bgImageView.frame.size.width / 2, 30.f)];
        [_allbutton addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_allbutton];
    }
    return self;
}

#pragma mark - Private methods

- (void)onClicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    self.type = ALLSWITCH;
    if(button == _curButton){
        self.type = CURRENTSWITCH;
    }
    
    if([_delegate respondsToSelector:@selector(swithClicked:withType:)]){
        [_delegate swithClicked:self withType:_type];
        
    }
}

@end
