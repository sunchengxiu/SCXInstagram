//
//  SCXBeautifulUtil.h
//  仿Instagram美图
//
//  Created by 孙承秀 on 2017/4/15.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCXBeautifulUtil : NSObject
/**
 传入图片和响应的颜色矩阵进行美图
 
 @param image 原始图片
 @param color 响应的颜色矩阵
 @return 美图后的图片
 */
+ (UIImage *)SCX_beautifulImageWithImage:(UIImage *)image colorMatrix:(const float *)color;
@end
