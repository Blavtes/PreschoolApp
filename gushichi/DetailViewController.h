//
//  DetailViewController.h
//  gushichi
//
//  Created by yong yang on 2023/4/10.
//

#import <UIKit/UIKit.h>
#import "ShichiItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
- (void)insertWorld:(ShichiItem*)item;
- (void)putSourceArr:(NSArray *)arr selectPath:(int )se rowPath:(int)row;
@end

NS_ASSUME_NONNULL_END
