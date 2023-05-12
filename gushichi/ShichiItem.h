//
//  ShichiItem.h
//  gushichi
//
//  Created by yong yang on 2023/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShichiItem : NSObject
@property (nonatomic, assign) int aid;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *chaodai;
@property (nonatomic, strong) NSString *shichiId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *paixu;
@property (nonatomic, strong) NSString *mp3Id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *mp3url;
@property (nonatomic, strong) NSData *mp3Content;


@end

NS_ASSUME_NONNULL_END
