//
//  PreHots.h
//  gushichi
//
//  Created by yong yang on 2023/4/12.
//

#ifndef PreHots_h
#define PreHots_h
#define UIColorFromRGBHex(rgbValue)     [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define K_GREEN_COLOR UIColorFromRGBHex(0xC7EDCC)
#define COMMON_BLACK_COLOR RGBColor(94, 98, 99)

//  通用灰色 ok
#define COMMON_GREY_COLOR RGBColor(163, 163, 163)

//  浅灰色 ok
#define COMMON_LIGHT_GREY_COLOR RGBColor(206, 206, 206)

//  灰色（cell按下灰色）
#define COMMON_GREY_DOWN_COLOR RGBColor(217, 217, 217)

//  灰白色 (已经偏白) ok
#define COMMON_GREY_WHITE_COLOR RGBColor(241, 241, 241)
#endif /* PreHots_h */
