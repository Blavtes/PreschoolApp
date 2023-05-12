//
//  SqlTool.m
//  古诗词
//
//  Created by yong yang on 2023/4/10.
//

#import "SqlTool.h"
#import <FMDB/FMDB.h>
#import "ShichiItem.h"

@implementation SqlTool
+ (instancetype)sharedSqlTool {
    static SqlTool* sqlTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlTool = [[SqlTool alloc] init];
        NSString * path = [[NSBundle mainBundle] pathForResource:@"gushici" ofType:@"db"];
    //    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"./gushichi.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:path];
        
        if (![db open]) {
            // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
            db = nil;
        }
        sqlTool.db = db;
    });
    
    return sqlTool;
}

- (void)checkoutDB
{
    if (![[SqlTool sharedSqlTool].db open]) {
        // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
        [SqlTool sharedSqlTool].db = nil;
    }
}

- (NSArray *)getAllAuthor
{
    [[SqlTool sharedSqlTool] checkoutDB];
    FMResultSet *s = [[SqlTool sharedSqlTool].db executeQuery:@"SELECT * FROM shici GROUP BY author ORDER BY id"];
//    FMResultSet *s = [[SqlTool sharedSqlTool].db executeQuery:@"SELECT * FROM shici where id > 1"];
    NSMutableArray *arr = [NSMutableArray array];
    while ([s next]) {
        
        //retrieve values for each record
        ShichiItem * item = [[SqlTool sharedSqlTool] getItem:s];
        [arr addObject:item];
        
    }
    return  arr;
}

- (ShichiItem *)getItem:(FMResultSet *)s
{
    //retrieve values for each record
    NSString *chaodai = [s stringForColumn:@"caodai"];
    NSString *author = [s stringForColumn:@"author"];
//    int aid = [s intForColumn:@"id"];
//    NSString *paixu = [s stringForColumn:@"paixu"];
//    NSString *mp3Id = [s stringForColumn:@"mp3_id"];
    NSString *shichiId = [s stringForColumn:@"shiciid"];
    NSString *title = [s stringForColumn:@"title"];

//    NSLog(@"%@ %@",chaodai,author);
    ShichiItem *item = [[ShichiItem alloc] init];
//    item.aid = aid;
    item.author = author;
    item.chaodai = chaodai;
//    item.paixu = paixu;
//    item.mp3Id = mp3Id;
    item.shichiId = shichiId;
    item.title = title;
   
    return item;
}

- (NSArray *)getTitleForAuthor:(NSString *)author;
{
    [[SqlTool sharedSqlTool] checkoutDB];
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *s = [[SqlTool sharedSqlTool].db executeQuery:@"SELECT * FROM shici where author = ?" withArgumentsInArray:@[author]];
    while ([s next]) {
        //retrieve values for each record
        ShichiItem * item = [[SqlTool sharedSqlTool] getItem:s];
        [arr addObject:item];
//        NSLog(@"%@ %@ %@",item.chaodai,item.title,author);
    }
    
    return [NSArray arrayWithArray:arr];
}

- (NSArray *)getAuthor
{
    [[SqlTool sharedSqlTool] checkoutDB];
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *s = [[SqlTool sharedSqlTool].db executeQuery:@"SELECT * FROM shici GROUP BY author"];
    while ([s next]) {
        //retrieve values for each record
        NSString *chaodai = [s stringForColumn:@"caodai"];
//        NSLog(@"朝代 %@",chaodai);
        [arr addObject:chaodai];
    }
   
    return arr;
}

- (ShichiItem *)getContent:(NSString *)shiciId
{
    [[SqlTool sharedSqlTool] checkoutDB];
   
    FMResultSet *s = [[SqlTool sharedSqlTool].db executeQuery:@"SELECT * FROM play where shiciid = ?" withArgumentsInArray:@[shiciId]];
    while ([s next]) {
        ShichiItem * item = [[SqlTool sharedSqlTool] getContentItem:s];
        return item;
    }
    return nil;
}

- (ShichiItem *)getContentItem:(FMResultSet *)s
{
    //retrieve values for each record
//    NSString *chaodai = [s stringForColumn:@"caodai"];
//    NSString *author = [s stringForColumn:@"author"];
//    int aid = [s intForColumn:@"id"];
//    NSString *paixu = [s stringForColumn:@"paixu"];
    NSString *mp3url = [s stringForColumn:@"mp3_url"];
    NSString *shichiId = [s stringForColumn:@"shiciid"];
    NSString *content = [s stringForColumn:@"content"];
   

//    NSLog(@"%@ %@",chaodai,author);
    ShichiItem *item = [[ShichiItem alloc] init];
    if (![mp3url isEqualToString:@""]) {
        NSData *mp3_content = [s dataForColumn:@"mp3_content"];
        item.mp3Content = mp3_content;
    }
    item.mp3url = mp3url;
    item.shichiId = shichiId;
    item.content = content;
   
    return item;
}

@end
