//
//  ViewController.m
//  古诗词
//
//  Created by yong yang on 2023/4/10.
//

#import "ViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PreHots.h"
#import "GushiSplitViewController.h"

@interface ViewController ()<UISplitViewControllerDelegate>
@property (strong,nonatomic)UISplitViewController *splitViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_GREY_WHITE_COLOR;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 80, 80)];
//    [btn setTitle:@"古诗词" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"gushi.png"] forState:UIControlStateNormal];
    [btn setTitleColor:COMMON_BLACK_COLOR forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(checkoutGushichi) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)checkoutGushichi
{
    GushiSplitViewController *vc = [[GushiSplitViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
