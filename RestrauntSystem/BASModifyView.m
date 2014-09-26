//
//  BASModifyView.m
//  RestrauntSystem
//
//  Created by Sergey on 31.07.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASModifyView.h"

@interface BASModifyView(){
    BOOL isModify;
}

@property (nonatomic,strong) NSArray* contentData;
@property (nonatomic,strong) NSArray* buttons;
@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UILabel* titleView;

@end

@implementation BASModifyView

- (void)setTitle:(NSString *)title{
    _title = title;
    [_titleView setText:_title];
}
- (id)initWithFrame:(CGRect)frame withContent:(NSArray*)contentData  withDelegate:(id<BASModifyViewDelegate>)obj
{
    self = [super initWithFrame:frame];
    if (self) {
        isModify = NO;
        self.delegate = obj;
        self.contentData = [NSArray arrayWithArray:contentData];

        
        UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
        [self addGestureRecognizer:swipeLeftRight];


        
        UIImage * image = [[UIImage imageNamed:@"cell_modifiers_new.png"]stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:image]];
        
  
        self.scrollView = [[UIScrollView alloc]init];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setFrame:CGRectMake(0, 3.f, self.frame.size.width, self.frame.size.height - 7.f)];
        [self addSubview:_scrollView];
        
        self.titleView = [[UILabel alloc]init];
        [_titleView setBackgroundColor:[UIColor clearColor]];
        _titleView.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
        _titleView.textColor = [UIColor whiteColor];
        _titleView.textAlignment = NSTextAlignmentCenter;
        [_titleView setFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 35.f)];
        [_scrollView addSubview:_titleView];
        
        CGFloat posY = 35.f;
        NSMutableArray* buttons = [NSMutableArray new];
        UIImage *image1 = [UIImage imageNamed:@"field.png"];
        
        for(int i = 0; i < _contentData.count; i++){
  
            NSDictionary* dict = (NSDictionary*)[_contentData objectAtIndex:i];
            UIImageView* imageView = [[UIImageView alloc]initWithImage:image1];
            [imageView setFrame:CGRectMake(20.f, posY, image1.size.width, image1.size.height)];
            [_scrollView addSubview:imageView];
            
            UILabel* label = [[UILabel alloc]init];
            [label setBackgroundColor:[UIColor clearColor]];
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            [label setFrame:CGRectMake(30.f, posY, image1.size.width, image1.size.height)];
            [label setText:(NSString*)[dict objectForKey:@"name_modificator"]];
            [_scrollView addSubview:label];
            
            image = [UIImage imageNamed:@"cross_act.png"];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"tick_act.png"] forState:UIControlStateSelected];
            [button setFrame:CGRectMake(image1.size.width + 25.f, posY - 3.f, image.size.width + 10.f, image.size.height + 10.f)];
            [button addTarget:self action:@selector(activeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttons addObject:button];
            NSNumber* state = (NSNumber*)[dict objectForKey:@"state"];
            if([state integerValue] == 1){
                [button setSelected:YES];
            }
            [_scrollView addSubview:button];
            
            
            posY += (image1.size.height + 10.f);
        }
        self.buttons = [NSArray arrayWithArray:buttons];
        
        [_scrollView setContentSize:CGSizeMake(self.frame.size.width, posY + 20.f)];
        

    }
    return self;
}
- (void)activeClicked:(id)sender{
    isModify = YES;
    UIButton* button = (UIButton*)sender;
    BOOL state = [button isSelected];
    
    for(int i = 0; i < _buttons.count; i++){
        UIButton* obj = [_buttons objectAtIndex:i];
        if(obj == button){
            state = !state;
            [button setSelected:state];
            
            NSMutableArray* temp = [[NSMutableArray alloc]initWithArray:_contentData];
            NSDictionary* dict = (NSDictionary*)[_contentData objectAtIndex:i];
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:dict];
            [newDict setObject:[NSNumber numberWithInteger:(NSInteger)state] forKey:@"state"];
            [temp replaceObjectAtIndex:i withObject:newDict];
            
            self.contentData = [NSArray arrayWithArray:temp];
            
            break;
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if([_delegate respondsToSelector:@selector(doneClicked:withContent:)]){
        if(isModify)
            [_delegate doneClicked:self withContent:_contentData];
        else
            [_delegate doneClicked:self withContent:nil];
    }
}

- (void)doSingleTap:(UITapGestureRecognizer *)recognizer{
    
}
@end
