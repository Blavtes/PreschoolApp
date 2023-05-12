//
//  MasterViewController.m
//  gushichi
//
//  Created by yong yang on 2023/4/10.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SqlTool.h"
#import "ShichiItem.h"
#import "SectionHeadView.h"
#import "PreHots.h"
@interface MasterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *tableView;       //表格视图
@property (strong,nonatomic)NSMutableArray *chaodaiObjects; //朝代
@property (strong,nonatomic)NSMutableArray *authorObjects; //作者
@property (strong,nonatomic)NSMutableArray *gushiObjects; //朝代
@property (strong,nonatomic)NSMutableArray *openArr;
;//

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"古诗词";
    self.view.backgroundColor = COMMON_GREY_WHITE_COLOR;
    //创建UITableView
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    
    //创建数组
    self.authorObjects = [[SqlTool sharedSqlTool] getAllAuthor];
//    self.authorObjects = [sql getTitleForAuthor:<#(nonnull NSString *)#>]
    self.gushiObjects = [NSMutableArray array];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (ShichiItem *item in self.authorObjects) {
            [self.gushiObjects addObject: [[SqlTool sharedSqlTool] getTitleForAuthor:item.author]];

        }
        [[SqlTool sharedSqlTool].db close];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    });
    

   
    self.openArr = [@[] mutableCopy];
    [self checkoutSection:YES];
   //记录展开状态
    //设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
  
    // Do any additional setup after loading the view.
}

- (void)checkoutSection:(BOOL)first
{
    [self.openArr removeAllObjects];
    if (first) {
        [self.openArr addObject:@"1"];
    } else {
        [self.openArr addObject:@"0"];
    }
   
    for (int i = 1; i < self.authorObjects.count; i++) {
        
        [self.openArr addObject:@"0"];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.authorObjects.count;
}
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.openArr objectAtIndex: section] isEqualToString:@"1"]) {

        if (self.gushiObjects.count >= 1){
            return  ((NSArray*)[self.gushiObjects objectAtIndex:section]).count;
        }
    } else {
//        NSLog(@"---==>0000");
       
    }
    return 0;
}
//设置每一个单元格的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.根据reuseIdentifier，先到对象池中去找重用的单元格对象
    static NSString *reuseIdentifier = @"cellForRowAtIndexPath";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //2.如果没有找到，自己创建单元格对象
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    //3.设置单元格对象的内容
    ShichiItem *item = [[self.gushiObjects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"    %@ -- %@",item.title,item.author];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShichiItem *item = self.gushiObjects[indexPath.section][indexPath.row];
    NSLog(@"--- %@ %@ %@",item.shichiId,item.title,item.author);
    //获取详细控制器
    UINavigationController *detailNAV = [self.splitViewController.viewControllers lastObject];
    DetailViewController *detatilVC = (DetailViewController*)[detailNAV topViewController];
//    [detatilVC insertWorld:item];
    [detatilVC putSourceArr:self.gushiObjects  selectPath:indexPath.section rowPath:indexPath.row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//设置每行多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if ([[self.openArr objectAtIndex:indexPath.section]isEqual:@"0"]) {
       return 0;
   }else{
       return 45;
   }

}

//调整section头部的间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return 45;
}

// 自定义头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
   //重用头部视图
   static NSString *HeadViewIdentifier = @"HeadViewIdentifier";
   SectionHeadView *headView = [[SectionHeadView alloc]initWithReuseIdentifier:HeadViewIdentifier];
    ShichiItem *item = [self.authorObjects objectAtIndex:section];
   headView.titleLable.text = [NSString stringWithFormat:@"%@%@",item.chaodai,item.author];
//   headView.rightImageView.image = [UIImage imageNamed:@"catalogs_arrow@2x.png"];//给右边图片
   //使用block修饰
    if ([[self.openArr objectAtIndex:section]isEqual:@"0"]) {
        headView.rightImageView.transform = CGAffineTransformMakeRotation(M_PI *1.5);
    } else {
        headView.rightImageView.transform = CGAffineTransformMakeRotation(0);
    }
   __block SectionHeadView *weakHeadView = headView;
   headView.tapCallBack = ^(void){
   
   //NSLog(@"回调组的点击手势：%@",[shopNameArr objectAtIndex:section]);
       
       if ([[self.openArr objectAtIndex:section]isEqual:@"0"]) {
//           [self checkoutSection:NO];
           [self.openArr setObject:@"1" atIndexedSubscript:section];
           
//           [UIView animateWithDuration:0.4 animations:^{
//
//
//
//           } completion:^(BOOL finished) {
              //展开的时候为了防止右边尖头动画执行完毕再弹回来，我们这里刷新的是当前组下面的cell
//               NSMutableArray *arr = [@[] mutableCopy];
////               NSArray *brr = self.gushiObjects[section];
//               for (int i = 0; i < self.gushiObjects.count; i++) {
//
//                   [arr addObject:[NSIndexPath indexPathForRow:i inSection:section]];
//
//               }
//               [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
//               [self.tableView reloadData];
               //刷新特定的cell
               [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            
//           }];
          
       }else if ([[self.openArr objectAtIndex:section]isEqual:@"1"]){
//           [self checkoutSection:NO];
           [self.openArr setObject:@"0" atIndexedSubscript:section];
           
//           [UIView animateWithDuration:0.4 animations:^{
//
//
//
//           } completion:^(BOOL finished) {
//
//               //刷新某一组
               [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//           }];
//           [self.tableView reloadData];
       }
   
   };
   return headView;
}


@end
