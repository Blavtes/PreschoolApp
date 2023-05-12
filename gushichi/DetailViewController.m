//
//  DetailViewController.m
//  gushichi
//
//  Created by yong yang on 2023/4/10.
//

#import "DetailViewController.h"

#import <CoreGraphics/CoreGraphics.h>
#include <CoreGraphics/CGPDFContext.h>
#import "CustomCheckView.h"
#import "SqlTool.h"
#import "ShichiItem.h"
#import <AVFAudio/AVFAudio.h>
#import "PreHots.h"

#define M__RowCount 12 //12列
#define M__ColumCount 16 //一行16个
#define M__CheckViewSize 57 //方格大小
#define M__CheckViewSizeH 87 //方格大小

#define M_PAGE_WIDTH_PDF ((M__ColumCount * M__CheckViewSize) + 55)
#define M_PAGE_HEIGHT_PDF 842

#define M_PAGE_WIDTH 595
#define M_PAGE_HEIGHT ((M__RowCount * M__CheckViewSizeH) + 30)



typedef NS_ENUM(NSInteger, InsertWorldType) {
    InsertWorldTypeDefault  = 0, // 默认
    InsertWorldTypeRow      = 1, // 按行
    InsertWorldTypePage         = 2, // 按页
};



@interface DetailViewController ()<UITextFieldDelegate,AVAudioPlayerDelegate>
@property (nonatomic, assign) NSInteger pageCount;
// 页码视图数组
@property (nonatomic, strong) NSMutableArray *pageViewArray;
// 行视图数组
@property (nonatomic, strong) NSMutableArray *rowViewArray;
// pdf 导出数组
@property (nonatomic, strong) NSMutableArray *pdfPageViewArray;
@property (nonatomic, assign) InsertWorldType insertType;

@property (nonatomic, assign) NSInteger rowCount; // 行数
@property (nonatomic, assign) NSInteger columCount; // 列数
@property (nonatomic, assign) float boxViewSizeW; // 格子大小
@property (nonatomic, assign) float boxViewSizeH; // 格子大小
@property (nonatomic, assign) float pageSizeW; // page w
@property (nonatomic, assign) float pageSizeH; // page w
//@property (nonatomic, assign) float pageSizeH;//页面高度
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, weak)  UIScrollView *scrollView;
@property (nonatomic, weak)  UIView *cdView;
@property (nonatomic, strong)  ShichiItem *shichiItem;
@property (nonatomic, strong)  AVAudioPlayer *player;
@property (nonatomic, strong)  AVAudioPlayer *playerUrl;
@property (nonatomic, assign)  UIButton *playerBtn;

@property (nonatomic, assign)  UIView *statusView;

@property (nonatomic, assign) bool playerStatus;
@property (nonatomic, assign) int volumeValue;
@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, assign) int selectPath;
@property (nonatomic, assign) int rowPath;

@end

@implementation DetailViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        //横屏
        [self configerSeven];
    } else {
        [self configerFive];
    }
    [self updateFocusIfNeeded];
    [self.scrollView updateFocusIfNeeded];
    [self.cdView updateFocusIfNeeded];
}

- (void)configerSingle
{
    self.pageCount = 1;
    self.rowCount = 12;
    self.columCount = 8;
    self.boxViewSizeW = 57;
    self.boxViewSizeH = 87;
    self.pageSizeH = (self.boxViewSizeH + 10) * self.rowCount + 90;
    self.pageSizeW = self.boxViewSizeW * self.columCount + 55;;
    NSLog(@"=== H");
    
}

- (void)configerFive
{
    self.pageCount = 1;
    self.rowCount = 12;
    self.columCount = 12;
    self.boxViewSizeW = 57;
    self.boxViewSizeH = 87;
    self.pageSizeH = (self.boxViewSizeH + 10) * self.rowCount + 90;
    self.pageSizeW = self.boxViewSizeW * self.columCount + 55;;
    NSLog(@"=== H");
    
}

- (void)configerSeven
{
    NSLog(@"=== W");
    self.pageCount = 1;
    self.rowCount = 12;
    self.columCount = 16;
    self.boxViewSizeW = 57;
    self.boxViewSizeH = 87;
    self.pageSizeH = (self.boxViewSizeH + 10) * self.rowCount + 90;
    self.pageSizeW = self.boxViewSizeW * self.columCount + 55;;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.0];

//    [self configerW];
    _pageViewArray = [NSMutableArray array];
    _rowViewArray = [NSMutableArray array];
    _pdfPageViewArray = [NSMutableArray array];
    _insertType = InsertWorldTypePage;
    self.playerStatus = NO;
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 100, self.pageSizeW + 60, [UIScreen mainScreen].bounds.size.height - 120)];
    self.navigationController.navigationBar.backgroundColor = COMMON_GREY_WHITE_COLOR;
//    [scroll setHasVerticalScroller:YES];
//    [scroll setHasHorizontalScroller:YES];
//    [[scroll horizontalScroller] setAlphaValue:0];
//    [[scroll verticalScroller] setAlphaValue:0];

    [self.view addSubview:scroll];
    self.scrollView = scroll;
   
    self.volumeValue = 40;
    
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pageSizeW, self.pageSizeH  * self.pageCount  + 90)];
    self.view.backgroundColor = COMMON_GREY_WHITE_COLOR;
    [_scrollView addSubview:view];
    [_scrollView setShowsVerticalScrollIndicator:YES];
    [_scrollView setShowsHorizontalScrollIndicator:YES];
//    [_scrollView.documentView setFrame:CGRectMake(0, 0, 400, 1000)];
    self.cdView = view;
    // Do any additional setup after loading the view.
//    _inputView.backgroundColor = [UIColor grayColor];
//    _inputView.font = [UIFont systemFontOfSize:18];
   
//    [self checkoutPageView];
//    _inputView.delegate = self;
  
    [self addPlayerView];
    self.player.volume = self.volumeValue;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.cdView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self checkoutPageView];
}

- (void)checkoutPageView
{
    [self.rowViewArray removeAllObjects];
    [self.pageViewArray removeAllObjects];
    for (UIView *view in self.pdfPageViewArray) {
        [view removeFromSuperview];
    }
    [self.pdfPageViewArray removeAllObjects];
    
    self.scrollView.frame =CGRectMake(40, 100, self.pageSizeW + 60, [UIScreen mainScreen].bounds.size.height - 120);
    self.cdView.frame = CGRectMake(0, 0, self.pageSizeW, self.pageSizeH  * self.pageCount  + 90);
    for (NSInteger i = 0; i < self.pageCount ; i++) {
        [self addPageView:i row:self.rowCount column: self.columCount];
    }
}

- (void)addPlayerView
{
    CGFloat hY = 500;
    CGFloat h = 160;
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(self.cdView.frame.size.width + 20, hY - 20, 50, h)];
    
    [self.view addSubview:bg];
    self.statusView = bg;
   
    UIButton *last = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    [last setBackgroundImage:[UIImage imageNamed:@"last.png"] forState:UIControlStateNormal];
    
//    [next setBackgroundImage:[UIImage imageNamed:@"last.png"] forState:UIControlStateHighlighted];
    [last addTarget:self action:@selector(lastCheckout:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:last];
    
    
    UIButton *next = [[UIButton alloc] initWithFrame:CGRectMake(5, 60, 40, 40)];
    [next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextCheckout:) forControlEvents:UIControlEventTouchUpInside];
//    [show setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateHighlighted];

    [bg addSubview:next];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 120, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateHighlighted];

    [bg addSubview:btn];
    self.playerBtn = btn;
    [btn addTarget:self action:@selector(playStatus:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(5, 160, 40, 40)];
//    [btn5 setTitle:@"五" forState:UIControlStateNormal];
//    [btn5 addTarget:self action:@selector(checkoutFive) forControlEvents:UIControlEventTouchUpInside];
//    [bg addSubview:btn5];
//    UIButton *btn7 = [[UIButton alloc] initWithFrame:CGRectMake(5, 220, 40, 40)];
//    [btn7 setTitle:@"七" forState:UIControlStateNormal];
//    [btn7 addTarget:self action:@selector(checkoutSeven) forControlEvents:UIControlEventTouchUpInside];
//    [bg addSubview:btn7];
}

- (void)checkoutFive
{
    [self configerFive];
    [self checkoutPageView];
    self.statusView.frame = CGRectMake(self.cdView.frame.size.width + 20, 500 - 20, 50, 160);
    ShichiItem *item = ((NSArray *)(self.sourceArr[self.selectPath]))[self.rowPath];
    [self insertWorld:item];
}

- (void)checkoutSeven
{
    [self configerSeven];
    [self checkoutPageView];
    self.statusView.frame = CGRectMake(self.cdView.frame.size.width + 20, 500 - 20, 50, 160);
    ShichiItem *item = ((NSArray *)(self.sourceArr[self.selectPath]))[self.rowPath];
    [self insertWorld:item];
    
}
- (void)checkoutSigle
{
    [self configerSingle];
    [self checkoutPageView];
    self.statusView.frame = CGRectMake(self.cdView.frame.size.width + 20, 500 - 20, 50, 160);
    ShichiItem *item = ((NSArray *)(self.sourceArr[self.selectPath]))[self.rowPath];
    [self insertWorld:item];
    
}

- (void)lastCheckout:(id)btn {
    NSLog(@"==== %d %d",self.selectPath,self.rowPath);
    if (!self.sourceArr) return;
    NSArray *arr =self.sourceArr[self.selectPath];
    if (self.rowPath > 0) {
        self.rowPath -= 1;
    } else {
        if (self.selectPath > 0) {
            self.selectPath -= 1;
            NSArray *arr =self.sourceArr[self.selectPath];
            self.rowPath = arr.count - 1;
        } else {
            return;
        }
    }
    [self gotoSelectItem];
}

- (void)nextCheckout:(id)btn {

    if (!self.sourceArr) return;
    NSLog(@"==== %d %d",self.selectPath,self.rowPath);
    NSArray *arr =self.sourceArr[self.selectPath];
    if (self.rowPath == arr.count - 1) {
        self.rowPath = 0;
        if (self.selectPath == self.sourceArr.count - 1) {
            self.selectPath = 0;
        } else {
            self.selectPath += 1;
        }
    } else {
        self.rowPath += 1;
    }
    [self gotoSelectItem];
}

- (void)gotoSelectItem
{
    NSLog(@"====3 %d %d",self.selectPath,self.rowPath);

    ShichiItem *item = ((NSArray *)(self.sourceArr[self.selectPath]))[self.rowPath];
    item = [[SqlTool sharedSqlTool] getContent:item.shichiId];

    if ([item.content componentsSeparatedByString:@"。"][0].length == 11) {
        [self checkoutFive];
    } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
       
        [self checkoutSigle];
        
    } else {
        
        [self checkoutSeven];
    }
}

- (void)addVolume
{
    if (self.volumeValue < 60) {
        self.volumeValue += 3;
    }
    NSLog(@"--- %d",self.volumeValue);
    self.player.volume =  self.volumeValue;
}

- (void)slowVolume
{
    NSLog(@"--- %d",self.volumeValue);
    if (self.volumeValue > 5) {
        self.volumeValue -= 5;
    }
    self.player.volume =  self.volumeValue;
}

- (void)playStatus:(UIButton*)btn
{
    self.playerStatus = !self.playerStatus;
    NSLog(@"=== %d",self.playerStatus);
    if (!self.playerStatus) {
//        [btn setTitle:@"Play" forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];

        [self.player stop];
    } else {
//        [btn setTitle:@"Stop" forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];

        [self.player play];
    }
    
}

- (void)sliderChange:(UISlider*)slider
{
    
}

- (void)addPlayer:(ShichiItem *)item
{
    if (self.player) {
        self.player = nil;
    }
//    NSData *data = nil;
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:item.mp3Content error:&error];
    if (error) {
        NSLog(@"error %@",error);
        [self addPlayerUrl:item.mp3url];
        return;
    }
    self.player = player;
    self.player.delegate = self;
    [self.player prepareToPlay];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
}

- (void)addPlayerUrl:(NSString *)url
{
    if (self.player) {
        self.player = nil;
    }
//    NSData *data = nil;
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error];

    if (error) {
        NSLog(@"error %@",error);
    }
    self.player = player;
    self.player.delegate = self;
    [self.player prepareToPlay];
}

- (UIView *)addPageView:(NSInteger)page
{
    
    UIView *pdfView2 = [[UIView alloc] init];
    
//    NSLog(@"---- y %.f",y);
    pdfView2.frame = CGRectMake(0, self.pageSizeH  * page  , self.pageSizeW, self.pageSizeH);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, self.pageSizeH - 80, self.pageSizeW - 40, 2)];
    line.backgroundColor = [UIColor grayColor];
    [pdfView2 addSubview:line];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(self.pageSizeW - 120, self.pageSizeH - 80, 100, 30)];
    lable.textColor = [UIColor blackColor];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor clearColor];
//    lable.editable = NO;
//    lable.bordered = NO;
    
    [lable setText:[NSString stringWithFormat:@"页码：%ld",page + 1]];
    [pdfView2 addSubview:lable];
    [self.cdView addSubview:pdfView2];
    pdfView2.backgroundColor = [UIColor redColor];
    return  pdfView2;
}

- (void)addPageView:(NSInteger)page row:(NSInteger)row column:(NSInteger)column
{
//    float width = self.boxViewSizeW;
    UIView *pageView = [self addPageView:page];
    pageView.backgroundColor = [UIColor clearColor];
    for (NSInteger j = 0; j < row; j++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i <column; i++) {
            CustomCheckView * view =  [self addCountView:CGRectMake(i * self.boxViewSizeW + 8, j * (self.boxViewSizeH + 10), self.boxViewSizeW, self.boxViewSizeH) page:page row:j column:i];
            [arr addObject:view];
            [pageView addSubview:view];
            [self.rowViewArray addObject:view];
        }
        [self.pageViewArray addObject:arr];
    }
    [self.pdfPageViewArray addObject:pageView];
    NSLog(@"%f %f",pageView.frame.size.width,pageView.frame.size.height);
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, self.pageSizeH * (page + 1))];
}

- (CustomCheckView *)addCountView:(CGRect)frame page:(NSInteger)page row:(NSInteger)row column:(NSInteger)column
{
    bool isRight = YES;
    if (column == 0) {
        isRight = NO;// 第一个右边不需要
    }
    CustomCheckView *view = [[CustomCheckView alloc] initWithFrame:frame rightDraw:isRight];
    view.tag = (page + 1) * 10000 + row * 100 + column;
//    NSLog(@"--- set tag %ld",view.tag);
    if (row == 0) {
        
    }
    return view;
}

- (IBAction)clickBtn:(id)sender {
//    [self addPdfView];
}

- (void)putSourceArr:(NSArray *)arr selectPath:(int)se rowPath:(int)row
{
    self.sourceArr  = arr;
    self.selectPath = se;
    self.rowPath = row;
    [self gotoSelectItem];
}

- (void)insertWorld:(ShichiItem*)shici {
//    NSString *world =  @"";
    
    self.shichiItem = [[SqlTool sharedSqlTool] getContent:shici.shichiId];
    if (self.shichiItem.mp3url.length > 0) {
        [self addPlayer:self.shichiItem];
//        [self addPlayerUrl:self.shichiItem.mp3url];
        [self.playerBtn setHidden:NO];
    } else {
        [self.playerBtn setHidden:YES];
    }
    [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    NSLog(@"mp3_url %@,\n %@",self.shichiItem.mp3url,self.shichiItem.content);
    
    NSMutableString *copyStr = [NSMutableString stringWithFormat:@"%@\n%@%@\n%@",shici.title,shici.chaodai,shici.author,self.shichiItem.content];
    NSMutableString *world = [copyStr mutableCopy];
    NSRange range = NSMakeRange(0, world.length);
    [world replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSCaseInsensitiveSearch range:range];
    if ([world containsString: @"("]) {
        NSArray *ar = [world componentsSeparatedByString:@"("];
//        NSArray *a2 = [ar[1] componentsSeparatedByString:@")"];
        NSMutableString *s3 = [NSMutableString stringWithFormat:@"%@",ar[0]];
        for (int i = 1; i< ar.count;i++) {
            NSArray *a2 = [ar[i] componentsSeparatedByString:@")"];
            if (a2.count == 2) {
//                [s3 appendString:a2[0]];
                [s3 appendString:a2[1]];
            } else {
                [s3 appendString:ar[i]];
            }
        }
       
        world = s3;
    }
    NSLog(@"content page %d %d",world.length / (self.rowCount * self.columCount) , self.pageCount);
    if (world.length / (self.rowCount * self.columCount) >= self.pageCount) {
        int page = world.length / (self.rowCount * self.columCount) + MIN((world.length % (self.rowCount * self.columCount)),1);
//        self.pageCount = world.length / (self.rowCount * self.columCount) + MIN((world.length % (self.rowCount * self.columCount)),0);
        NSLog(@"content page %d",page);
        for (int i = self.pageCount;i <= page;i++) {
            [self addPageView:i row:self.rowCount column:self.columCount];
        }
        [self.scrollView setContentSize:CGSizeMake(self.pageSizeW + 20, self.pageSizeH * page + page * 60)];
        self.pageCount = page;
    }
//    NSString *world =  self.shichiItem.content;
    NSLog(@"==== %@",world);
    if (world.length > 1)  {
        int index = 0;
        NSInteger count = self.pageViewArray.count;
        for (NSInteger i = 0,k = 0; i < count ; i++ ,k++) {
            NSArray *temp  = self.pageViewArray[k];
            bool step = NO;
            
            for (NSInteger j = 0; j < temp.count ; j++) {
                CustomCheckView *view = [temp objectAtIndex:j];
                [view changeText:@""];
            }
        }
                
        for (NSInteger i = 0,k = 0; i < count ; i++ ,k++) {
            NSArray *temp  = self.pageViewArray[k];
            bool step = NO;
            
            for (NSInteger j = 0; j < temp.count ; j++) {
                if (index >= self.columCount * self.rowCount * self.pageCount +1) break;
               
                NSString *s = [world substringWithRange:NSMakeRange(MIN(index, world.length - 1), 1)];
//                NSLog(@"-- %@ %d %d %d",s,index,j, world.length);
                CustomCheckView *view = [temp objectAtIndex:j];
//                [view changeText:@""];
//                NSLog(@"--s  %@ %d %d",s,index,world.length);
                if ([s isEqualToString:@"\n"]  ) {
                    step = YES;
                   
                }
                if ([s isEqualToString:@" "] ) {
                    index++;
                    j--;
                    continue;;
                }
                if ( step || index >world.length -1) {
                    
                    [view changeText:@""];
//                    if ( [s isEqualToString:@"。"]) {
//                        [view changeText:s];
//                    }
                } else {
                    index++;
                    [view changeText:s];
                }
                view.hidden = NO;
            }
            if (step) {
                index++;
//                i--;
            }
        }
    };
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    NSLog(@"=== end ==== %f",self.scrollView.contentSize.height);
}

- (IBAction)pageChange:(id)sender {
    
    UISlider *s = (UISlider *)sender;
    NSLog(@"分页 ：%d",s.value);
    self.pageCount = s.value;
//    [self.pageLabelView setTitleWithMnemonic:[NSString stringWithFormat:@"分页 ：%d",s.value]];
    self.cdView.frame =  CGRectMake(0, 0, self.pageSizeW, (self.pageSizeH + 30)  * self.pageCount  + 90);
//    self.cdView.frame =  CGRectMake(0, 40, self.pageSizeH,M_PAGE_HEIGHT);
}

- (IBAction)fontColorChange:(id)sender {
    UIColorWell *well = (UIColorWell *)sender;
    for (NSInteger i =  self.pageViewArray.count - 1; i>= 0 ;i--) {
        NSArray *arr = [self.pageViewArray objectAtIndex:i];
        for (CustomCheckView *view in arr) {
            [view changeLableColor:well.selectedColor];
        }
    }
}


- (IBAction)changeY:(id)sender {
    UISlider *s = (UISlider *)sender;
//    self.changeYLable.stringValue = [NSString stringWithFormat:@"偏移：%d",s.intValue];
    for (NSInteger i =  self.pageViewArray.count - 1; i>= 0 ;i--) {
        NSArray *arr = [self.pageViewArray objectAtIndex:i];
        for (CustomCheckView *view in arr) {
            [view changeLableY:s.value];
        }
    }
}

@end
