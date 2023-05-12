//
//  SectionHeadView.h
//  gushichi
//
//  Created by yong yang on 2023/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapCallBack)(void);

@interface SectionHeadView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *titleLable;
@property (copy) TapCallBack tapCallBack;

@end

NS_ASSUME_NONNULL_END
