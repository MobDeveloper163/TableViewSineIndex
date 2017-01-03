//
//  SinView.m
//  04-正弦函数
//
//  Created by 袁统 on 2016/11/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

// 简谐运动满足的公式 ： x = Asin(wt + Φ) 其中 w、Φ、A都是常量
// 最大振幅是 30     单摆在x轴的最大距离
// 振动周期是 30S     往复一次，也就是振动一个周期的时间 T
// 振动频率是 1 / 30    每秒振动的周期数称为频率 f = 1 / T
// w = 1 / 30 * 2π
// 初相位 π / 2
// x = 30 * sin(π * t + π / 2)


#import "SinView.h"

#define RandomColor [UIColor colorWithRed: (50 + arc4random_uniform(150)) / 256.0 green:(50 + arc4random_uniform(150)) / 256.0 blue:(50 + arc4random_uniform(150)) / 256.0 alpha:1]

#define BasicFontSize 16

@interface SinView ()

@property(nonatomic, copy) NSArray<UIButton *> *allBtns;
@property(nonatomic, assign) NSInteger currentSelectedTag;
@property(nonatomic, assign) BOOL firstTime;
@end


@implementation SinView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        [self allBtns];
    }
    return self;
}


-(NSArray<UIButton *> *)allBtns{
    if(!_allBtns){
        self.firstTime = YES;
        NSMutableArray *allBtns = [NSMutableArray arrayWithCapacity:26];
        for(int i = 0; i < 26; i++){
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [btn setTitleColor:RandomColor forState:UIControlStateNormal];
            btn.tag = i;
            btn.userInteractionEnabled = NO;
            [self addSubview:btn];
            [allBtns addObject:btn];
        }
        _allBtns = allBtns;
    }
    return _allBtns;
}

// 加载所有的标签
-(void)awakeFromNib{
    [super awakeFromNib];
    [self allBtns];
}



// 设置所有标签的位置和大小
-(void)layoutSubviews{
    // 是否是第一次加载
    if(self.firstTime){
        [self resetBtnsPosition];
        self.firstTime = NO;
    }
}



/**
 设置所有标签的出初始位置或者还原标签的原始位置
 */
-(void)resetBtnsPosition{
    
    NSArray<UIButton *> *subviews = self.allBtns;
    CGFloat height = self.frame.size.height / 26;
    CGFloat width = height;
    CGFloat x = self.frame.size.width - 10 - width;
    CGFloat y = 0;
    
    UIButton *btn = nil;
    for(int i = 0; i < subviews.count; i++){
        btn = subviews[i];
        y = i * height;
        btn.transform = CGAffineTransformMakeScale(1, 1);
        btn.frame = CGRectMake(x, y, width, height);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setButton:btn withFontSize:BasicFontSize];
    }

}


/**
 设置标签文字的样式
 */
-(void)setButton:(UIButton *)btn withFontSize:(CGFloat)fontSize{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                            NSForegroundColorAttributeName : RandomColor
                            };
    NSAttributedString *atrString = [[NSAttributedString alloc] initWithString:[btn titleForState:UIControlStateNormal] attributes:attrs];
    [btn setAttributedTitle:atrString forState:UIControlStateNormal];
}


/**
    确定当前选中的标签
 */
-(void)touches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.allBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(CGRectContainsPoint(obj.frame, point)){
            [self resetPositionAccordingSelectedTag:obj.tag];
            *stop = YES;
        }
    }];
}


/**
 根据选中的标签设置其他标签的位置

 @param selectedTag 选中的标签的Tag
 */
-(void)resetPositionAccordingSelectedTag:(NSInteger) selectedTag{
    
    // 假如选中的是同一个标签，返回
    if(self.currentSelectedTag == selectedTag){
        return;
    }

    // 选中标签的最大
    CGFloat maxX = self.frame.size.height / 26 * 2.5;
    
    // 重置所有标签的位置
    [self resetBtnsPosition];
    
    // 重置选中的标签
    self.currentSelectedTag = selectedTag;
    
    // 设置选中标签的位置和大小
    CGRect frame = self.allBtns[selectedTag].frame;
    frame.origin.x = frame.origin.x - maxX * sin(M_PI_2) ;
    frame.size.width = self.frame.size.width - 10 - frame.origin.x + 50;
    UIButton *selectedBtn = self.allBtns[selectedTag];
    selectedBtn.frame = frame;
    selectedBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [self setButton:selectedBtn withFontSize:BasicFontSize * 2];
    
    UIButton *btn = nil;
    CGFloat scale = 1;
    // 设置选中标签的前6个和后6个标签的位置和大小
    for(int i = 1; i < 7; i++){
        
        // 设置选中标签前6个标签的位置和大小
        if(self.currentSelectedTag - i > -1){
            btn = self.allBtns[self.currentSelectedTag - i];
            CGRect previousFrame = btn.frame;
            previousFrame.origin.x = previousFrame.origin.x - maxX * sin(M_PI_2 - M_PI / 12 * i);
            previousFrame.size.width = self.frame.size.width - 10 - previousFrame.origin.x;
            btn.frame = previousFrame;
            scale = 1 + sin(M_PI_2 - M_PI / 12 * i) / 3;
            [self setButton:btn withFontSize:BasicFontSize * scale];
            btn.transform = CGAffineTransformMakeScale(scale, scale);
        }
        
        // 设置选中标签后6个标签的位置和大小
        if(self.currentSelectedTag + i < self.allBtns.count){
            btn = self.allBtns[self.currentSelectedTag + i];
            CGRect previousFrame = btn.frame;
            previousFrame.origin.x = previousFrame.origin.x - maxX * sin(M_PI_2 + M_PI / 12 * i);
            previousFrame.size.width = self.frame.size.width - 10 - previousFrame.origin.x;
            btn.frame = previousFrame;
            scale = 1 + sin(M_PI_2 + M_PI / 12 * i) / 3;
            [self setButton:btn withFontSize:BasicFontSize * scale];
            btn.transform = CGAffineTransformMakeScale(scale, scale);
        }
        
        
    }
}

// 触摸的时候判断当前触摸到的标签
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touches:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touches:touches withEvent:event];
}

// 取消触摸时，还原所有标签原来的位置
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resetBtnsPosition];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resetBtnsPosition];
}



/**
    正弦函数回执弧线
 */
-(void)drawRect:(CGRect)rect{
  
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGFloat x = 0;
//
//    for(float t = 0; t < 145; t += 12){
//    
//        x = -100 * sin(M_PI / 144 * t) + 300;
//        
//        NSLog(@"point = %@", NSStringFromCGPoint(CGPointMake(x, t)));
//        
//        if(t == 0){
//            CGContextMoveToPoint(context, x, t);
//        }else{
//            CGContextAddLineToPoint(context, x, t);
//        }
//    }
//
//    CGContextSetFillColorWithColor(context, RandomColor.CGColor);
//
//    CGContextDrawPath(context, kCGPathStroke);
//    
//    CGContextFillPath(context);
}


@end
