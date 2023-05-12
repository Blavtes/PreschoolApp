//
//  SceneDelegate.m
//  古诗词
//
//  Created by yong yang on 2023/4/10.
//

#import "SceneDelegate.h"
#import "ViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    //创建分割控制器
//        self.splitViewController = [[UISplitViewController alloc]init];
//
//        //创建MasterVC
//        MasterViewController *MasterVC = [[MasterViewController alloc]init];
//
//
//        //创建DetailVC
//        DetailViewController *DetailVC = [[DetailViewController alloc]init];
//
//
//        //创建左侧导航控制器
//        UINavigationController *MasterNavigationController = [[UINavigationController alloc]initWithRootViewController:MasterVC];
//
//        //创建右侧导航栏控制器
//        UINavigationController *DetailNavigationController = [[UINavigationController alloc]initWithRootViewController:DetailVC];
//
//
//        // 设置 UISplitViewController 所管理的左、右两个 UIViewController
//        self.splitViewController.viewControllers = @[MasterNavigationController,DetailNavigationController];
        
        //设置分割控制器分割模式
//        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
//
//        //设置代理
//        self.splitViewController.delegate = self;
//
        //设置window的根控制器
//        self.window.rootViewController = self.splitViewController;
    ViewController *view = [[ViewController alloc] init];
    UINavigationController *DetailNavigationController = [[UINavigationController alloc]initWithRootViewController:view];
    self.window.rootViewController = DetailNavigationController;
        
}
#pragma mark -<UISplitViewController>
//主控制器将要隐藏时触发的方法
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"古诗词";
    //master将要隐藏时，给detail设置一个返回按钮
    UINavigationController *Nav = [self.splitViewController.viewControllers lastObject];
    DetailViewController *Detail = (DetailViewController *)[Nav topViewController];
    
    Detail.navigationItem.leftBarButtonItem = barButtonItem;
}

//开始时取消二级控制器,只显示详细控制器
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return NO;
}


//主控制器将要显示时触发的方法
-(void)splitViewController:(UISplitViewController *)sender willShowViewController:(UIViewController *)master invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
//master将要显示时,取消detail的返回按钮
    UINavigationController *Nav = [self.splitViewController.viewControllers lastObject];
    DetailViewController *Detail = (DetailViewController *)[Nav topViewController];
    
    Detail.navigationItem.leftBarButtonItem = nil;
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
