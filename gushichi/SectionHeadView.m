//
//  SectionHeadView.m
//  gushichi
//
//  Created by yong yang on 2023/4/10.
//

#import "SectionHeadView.h"
#import "PreHots.h"
@implementation SectionHeadView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier: reuseIdentifier]) {
        UILabel *lable = [[UILabel alloc] init];
        self.backgroundColor = COMMON_GREY_WHITE_COLOR;
        [self addSubview:lable];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
        self.titleLable = lable;
        self.titleLable.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width, 45);
        self.titleLable.backgroundColor = COMMON_GREY_WHITE_COLOR;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
        imageView.frame = CGRectMake(300, 17, 35 * 0.5, 22 * 0.5);
        [self addSubview:imageView];
        self.rightImageView = imageView;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return self;
}

- (void)tap{
    if (self.tapCallBack) {
        self.tapCallBack();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
