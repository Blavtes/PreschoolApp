//
//  GushiSplitViewController.m
//  gushichi
//
//  Created by yong yang on 2023/4/14.
//

#import "GushiSplitViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PreHots.h"

@interface GushiSplitViewController ()<UISplitViewControllerDelegate>
@property (strong,nonatomic)UISplitViewController *splitViewController;
@end

@implementation GushiSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkoutGushichi];
//    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
}
- (void)checkoutGushichi
{
    self.splitViewController = [[UISplitViewController alloc]init];
    
    //创建MasterVC
    MasterViewController *MasterVC = [[MasterViewController alloc]init];
    
    
    //创建DetailVC
    DetailViewController *DetailVC = [[DetailViewController alloc]init];

    
    //创建左侧导航控制器
    UINavigationController *MasterNavigationController = [[UINavigationController alloc]initWithRootViewController:MasterVC];
    
    //创建右侧导航栏控制器
    UINavigationController *DetailNavigationController = [[UINavigationController alloc]initWithRootViewController:DetailVC];

    
    // 设置 UISplitViewController 所管理的左、右两个 UIViewController
    self.splitViewController.viewControllers = @[MasterNavigationController,DetailNavigationController];
    
    //设置分割控制器分割模式
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
    
    //设置代理
    self.splitViewController.delegate = self;
    [self.view addSubview:self.splitViewController.view];
}
#pragma mark -<UISplitViewController>
//主控制器将要隐藏时触发的方法
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
//    barButtonItem.title = @"古诗词";
    //master将要隐藏时，给detail设置一个返回按钮
//    UINavigationController *Nav = [self.splitViewController.viewControllers lastObject];
//    DetailViewController *Detail = (DetailViewController *)[Nav topViewController];
//
//    Detail.navigationItem.leftBarButtonItem = barButtonItem;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
