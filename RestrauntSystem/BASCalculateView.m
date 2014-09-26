//
//  BASCalculateView.m
//  RestrauntSystem
//
//  Created by Sergey on 17.07.14.
//  Copyright (c) 2014 BestAppStudio. All rights reserved.
//

#import "BASCalculateView.h"

@interface BASCalculateView()

@property (nonatomic,strong)UIImageView* priceView;
@property (nonatomic,strong)UIImageView* persentView;
@property (nonatomic,strong)UIImageView* resultView;
@property (nonatomic,strong)UIButton* discountBt;
@property (nonatomic,strong)UIButton* doneBt;
@property (nonatomic,strong)UILabel* field1;
@property (nonatomic,strong)UILabel* field2;
@property (nonatomic,strong)UILabel* field3;
@property (nonatomic,strong)UILabel* nameView;

@end

@implementation BASCalculateView

- (void)setPrice:(NSString *)price{
    _price = price;
    _field1.text = price;
    _field3.text = _field1.text;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = [[UIScreen mainScreen]bounds];
        UIImage* image = [UIImage imageNamed:@"lbl_amount_calc.png"];
        self.priceView = [[UIImageView alloc]initWithImage:image];
        [_priceView setFrame:CGRectMake(rect.size.width / 2 - image.size.width / 2, 20.0f, image.size.width, image.size.height)];
        [self addSubview:_priceView];
        
        
        image = [UIImage imageNamed:@"btn_discount.png"];
        self.discountBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_discountBt setBackgroundImage:image forState:UIControlStateNormal];
        [_discountBt setFrame:CGRectMake(rect.size.width / 2 - image.size.width / 2, _priceView.frame.origin.y + _priceView.frame.size.height + 20.f, image.size.width, image.size.height)];
        [self addSubview:_discountBt];

        
        image = [UIImage imageNamed:@"lbl_discount.png"];
        self.persentView = [[UIImageView alloc]initWithImage:image];
        [_persentView setFrame:CGRectMake(_discountBt.frame.origin.x, _discountBt.frame.origin.y + _discountBt.frame.size.height + 20.f, image.size.width, image.size.height)];
        [self addSubview:_persentView];

        self.resultView = [[UIImageView alloc]initWithImage:image];
        [_resultView setFrame:CGRectMake(_discountBt.frame.origin.x + _discountBt.frame.size.width - image.size.width, _discountBt.frame.origin.y + _discountBt.frame.size.height + 20.f, image.size.width, image.size.height)];
        [self addSubview:_resultView];
        
        
        
        
        image = [UIImage imageNamed:@"btn_confirm.png"];
        self.doneBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBt setBackgroundImage:image forState:UIControlStateNormal];
        [_doneBt setFrame:CGRectMake(rect.size.width / 2 - image.size.width / 2, rect.size.height - image.size.height - 150.f, image.size.width, image.size.height)];
        [_doneBt addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneBt];
        
        self.field1 = [[UILabel alloc]init];
        [_field1 setBackgroundColor:[UIColor clearColor]];
        _field1.font = [UIFont fontWithName:@"Helvetica-Light" size:34.f];
        _field1.textColor = [UIColor blackColor];
        _field1.shadowColor = [UIColor grayColor];
        _field1.shadowOffset = CGSizeMake(0.0, 1.0);
        _field1.textAlignment = NSTextAlignmentCenter;
        [_field1 setFrame:_priceView.frame];
        [self addSubview:_field1];
        
        
        self.field2 = [[UILabel alloc]init];
        [_field2 setBackgroundColor:[UIColor clearColor]];
        _field2.font = [UIFont fontWithName:@"Helvetica-Light" size:26.f];
        _field2.textColor = [UIColor blackColor];
        _field2.shadowColor = [UIColor grayColor];
        _field2.shadowOffset = CGSizeMake(0.0, 1.0);
        _field2.textAlignment = NSTextAlignmentCenter;
        [_field2 setFrame:_persentView.frame];
        NSInteger persent = 0;
        _field2.text = [NSString stringWithFormat:@"%d %%",persent];
        [self addSubview:_field2];
        
        
        self.field3 = [[UILabel alloc]init];
        [_field3 setBackgroundColor:[UIColor clearColor]];
        _field3.font = [UIFont fontWithName:@"Helvetica-Light" size:26.f];
        _field3.textColor = [UIColor blackColor];
        _field3.shadowColor = [UIColor grayColor];
        _field3.shadowOffset = CGSizeMake(0.0, 1.0);
        _field3.textAlignment = NSTextAlignmentCenter;
        [_field3 setFrame:_resultView.frame];
        [self addSubview:_field3];
        
        self.nameView = [[UILabel alloc]init];
        [_nameView setBackgroundColor:[UIColor clearColor]];
        _nameView.font = [UIFont fontWithName:@"Helvetica-Light" size:32.f];
        _nameView.textColor = [UIColor whiteColor];
        _nameView.shadowColor = [UIColor blackColor];
        _nameView.shadowOffset = CGSizeMake(0.0, 1.0);
        _nameView.textAlignment = NSTextAlignmentCenter;
        _nameView.text  = @"Гость";
        [_nameView setFrame:CGRectMake(0, _resultView.frame.origin.y + _resultView.frame.size.height + 10.f, rect.size.width, 50.f)];
        [self addSubview:_nameView];

        
    }
    return self;
}

- (void)buttonClicked{
    if([_delegate respondsToSelector:@selector(doneClicked:)]){
        [_delegate doneClicked:self];
    }
}

@end
