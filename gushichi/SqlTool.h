//
//  SqlTool.h
//  古诗词
//
//  Created by yong yang on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <FMDB/FMDB.h>
#import "ShichiItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SqlTool : NSObject
@property (nonatomic, strong)  FMDatabase *db;
+ (instancetype)sharedSqlTool;
- (NSArray *)getAllAuthor;
- (NSArray *)getTitleForAuthor:(NSString *)author;
- (NSArray *)getAuthor;
- (NSArray *)getGushi;
- (ShichiItem *)getContent:(NSString *)shiciId;

@end

NS_ASSUME_NONNULL_END
