//
//  SceneDelegate.h
//  古诗词
//
//  Created by yong yang on 2023/4/10.
//

#import <UIKit/UIKit.h>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate,UISplitViewControllerDelegate>
@property (strong,nonatomic)UISplitViewController *splitViewController;
@property (strong, nonatomic) UIWindow * window;

@end

