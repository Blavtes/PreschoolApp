//
//  CustomCheckView.m
//  字体生成
//
//  Created by yong yang on 2022/8/19.
//

#import "CustomCheckView.h"
#import "PreHots.h"
@interface CustomCheckView ()
@end

@implementation CustomCheckView

- (instancetype)initWithFrame:(CGRect)frameCGRect rightDraw:(BOOL)isDraw
{
    self=[self initWithFrame:frameCGRect];
    self.isRightDraw = isDraw;
    return self;
}


-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if(self){
        [self addLayer:frame];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width , frame.size.height - 30)];
        [self addSubview:lable];
       
        lable.font = [UIFont systemFontOfSize:42];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = [UIColor clearColor];
//        lable.textColor = COMMON_BLACK_COLOR;
        self.lable = lable;
        
        UILabel *ylable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , 30)];
        [self addSubview:ylable];
       
        ylable.font = [UIFont systemFontOfSize:28];
        ylable.textAlignment = NSTextAlignmentCenter;
        ylable.backgroundColor = [UIColor clearColor];
//        ylable.textColor = COMMON_BLACK_COLOR;
        ylable.adjustsFontSizeToFitWidth = YES;
        self.ylable = ylable;
        self.backgroundColor = COMMON_GREY_WHITE_COLOR;
       
    }
    return self;
}

- (void)changeLableY:(float)y
{
    self.lable.frame = CGRectMake(0, y, self.frame.size.width , self.frame.size.height);
}

- (void)changeFont:(NSInteger *)tag
{
    self.lable.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
//    self.lable.font = [UIFont fontWithName:@"" size:42];
}

- (void)changeLableFont:(UIFont *)font
{
    self.lable.font = font;
}

- (void)changeLableColor:(UIColor *)color
{
    self.lable.textColor = color;
}

- (void)changeText:(NSString *)str
{
    [self.lable setText:str];
    if ([str isEqualToString:@"，"]
        || [str isEqualToString:@"。"]
        || [str isEqualToString:@"！"]
        || [str isEqualToString:@"？"]
        || [str isEqualToString:@"〕"]
        || [str isEqualToString:@"《"]
        || [str isEqualToString:@"》"]
        || [str isEqualToString:@"；"]
        || [str isEqualToString:@"—"]
       
        || [str isEqualToString:@"〔"]) {
        [self.ylable setText:@""];
    } else {
        [self.ylable setText:[self transform:str]];
    }
}

- (NSString *)transform:(NSString *)chinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
//    NSLog(@"%@", pinyin);
    
    //去掉拼音的音标
//    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
//    NSLog(@"%@", pinyin);
    
    //返回最近结果
    return pinyin;
    
}

- (void)addLayer:(CGRect)frame{

    CGFloat offsetY = 30;
    myPath2 = [UIBezierPath bezierPath];
   
    
    [myPath2 setLineWidth:1.0]; //width of the lines
    
    CGPoint aline1 = CGPointMake(0,8);
    CGPoint aline2 = CGPointMake(0,16);
    CGPoint aline3 = CGPointMake(0,24);
    CGPoint aline11 = CGPointMake(frame.size.width,8);
    CGPoint aline21 = CGPointMake(frame.size.width,16);
    CGPoint aline31 = CGPointMake(frame.size.width,24);
    
    [myPath2 moveToPoint:aline1];
    [myPath2 addLineToPoint:aline11];
    [myPath2 moveToPoint:aline2];
    [myPath2 addLineToPoint:aline21];
    [myPath2 moveToPoint:aline3];
    [myPath2 addLineToPoint:aline31];
    
    CGPoint aPoint1 = CGPointMake(0,offsetY);
    
    
    [myPath2 moveToPoint:aPoint1];
    
    CGPoint aPoint2 = CGPointMake(frame.size.width , offsetY);
    [myPath2 addLineToPoint:aPoint2];
    [myPath2 moveToPoint:aPoint2];
    
//    [myPath lineToPoint:aPoint2]; //join the following point
    CGPoint aPoint3 = CGPointMake(frame.size.width , frame.size.height);
//        [myPath setLineWidth:.5];
    [myPath2 addLineToPoint:aPoint3];
    [myPath2 moveToPoint:aPoint3];//join the following point
    CGPoint aPoint4 = CGPointMake(0, frame.size.height);
//        [myPath setLineWidth:.5];
    
    [myPath2 addLineToPoint:aPoint4];
    [myPath2 moveToPoint:aPoint4];//join the following point
    if (self.isRightDraw) {
       // 右边跳过
        [myPath2 moveToPoint:aPoint1]; //join the following point

    } else {
        [myPath2 addLineToPoint:aPoint1]; //join the following point


    }
    
    [myPath2 moveToPoint:CGPointMake(0,offsetY)];
    [myPath2 setLineWidth:.5]; //width of the lines
    [myPath2 addLineToPoint:CGPointMake(frame.size.width , frame.size.height)];
    
    [myPath2 moveToPoint:CGPointMake(0,frame.size.height)];
    [myPath2 addLineToPoint:CGPointMake(frame.size.width , offsetY)];
    
    [myPath2 moveToPoint:CGPointMake(0,(frame.size.height - offsetY) / 2.0 + offsetY)];
    [myPath2 addLineToPoint:CGPointMake(frame.size.width , (frame.size.height - offsetY) / 2.0 + offsetY)];
    [myPath2 setLineWidth:.5];
    [myPath2 moveToPoint:CGPointMake(frame.size.width / 2.0, offsetY)];
    [myPath2 addLineToPoint:CGPointMake(frame.size.width / 2.0 , frame.size.height)];
    
    CGFloat dash[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
    [myPath2 setLineDash:dash count:6 phase:0];//!!!
    
    
//    [myPath stroke];
//    [myPath2 stroke];
    [myPath2 closePath];
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    
    chartLine.strokeColor   = [UIColor grayColor].CGColor;
    chartLine.lineWidth   = 0.25;
    
    [self.layer addSublayer:chartLine];
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
//    chartLine.strokeEnd = 2.0;
    chartLine.path = myPath2.CGPath;
    chartLine.backgroundColor = [UIColor clearColor].CGColor;
//    NSLog(@"=== layer ===");
}

@end
