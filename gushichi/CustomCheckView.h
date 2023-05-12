//
//  CustomCheckView.h
//  字体生成
//
//  Created by yong yang on 2022/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface CustomCheckView : UIControl
{
    UIBezierPath *myPath;
    UIBezierPath *myPath2;
   
}

@property (nonatomic, assign) bool isRightDraw;

@property (nonatomic, weak)  UILabel *lable;
@property (nonatomic, weak)  UILabel *ylable;
- (instancetype)initWithFrame:(CGRect)frameRect rightDraw:(BOOL)isDraw;
- (void)changeLableColor:(UIColor *)color;
- (void)changeLableFont:(UIFont *)font;
- (void)changeLableY:(float )Y;
- (void)changeText:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
