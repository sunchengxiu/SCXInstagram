//
//  SCXBottomView.h
//  仿Instagram美图
//
//  Created by 孙承秀 on 2017/4/15.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCXBottomView : UIScrollView
/**
 初始化bottomView，通过block回传处理好的图片
 
 @param frame bottomFrame
 @param block 回调block
 @return scrollView
 */
-(instancetype)initWithFrame:(CGRect)frame clickBlock:(void (^)(UIImage *))block;
@end
