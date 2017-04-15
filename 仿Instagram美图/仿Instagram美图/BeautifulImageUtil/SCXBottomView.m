//
//  SCXBottomView.m
//  仿Instagram美图
//
//  Created by 孙承秀 on 2017/4/15.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "SCXBottomView.h"
#import "SCXColorMatrix.h"
#import "SCXBeautifulUtil.h"
#import <objc/runtime.h>

@implementation SCXBottomView

/**
 初始化bottomView，通过block回传处理好的图片

 @param frame bottomFrame
 @param block 回调block
 @return scrollview
 */
-(instancetype)initWithFrame:(CGRect)frame clickBlock:(void (^)(UIImage *))block{

    if (self = [super initWithFrame:frame]) {
        [self _configView];
        objc_setAssociatedObject(self, @"blockKey", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return self;

}
- (void)_configView{
   
    for (NSInteger i = 0; i < 13; i ++) {
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(5 * (i + 1) + 100 * (i ), 0, 100, 128);
            imageView.tag = 100 + i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            imageView;
        });
        UIImage * image = [UIImage imageNamed:@"WechatIMG1 1"];
        UIButton *label = ({
            UIButton *label = [[UIButton alloc]init];
            label.tag = 1000 + i;
            CGRect rect = imageView.frame;
            rect.origin.y = CGRectGetMaxY(rect) + 5;
            rect.size.height = self.bounds.size.height - rect.size.height - 5;
            label.frame = rect;
            [label.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            label;
        });
        switch (i) {
            case 0:
            {
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_lomo];
                [label setTitle:@"经典" forState:UIControlStateNormal];
                
            }
                break;
            case 1:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_heibai];
                [label setTitle:@"黑白" forState:UIControlStateNormal];

            }
                break;
            case 2:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_fugu];
                [label setTitle:@"复古" forState:UIControlStateNormal];

            }
                break;
            case 3:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_gete];
                [label setTitle:@"哥特" forState:UIControlStateNormal];

            }
                break;
            case 4:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_ruihua];
                [label setTitle:@"锐化" forState:UIControlStateNormal];

            }
                break;
            case 5:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_danya];
                [label setTitle:@"淡雅" forState:UIControlStateNormal];

            }
                break;
            case 6:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_jiuhong];
                [label setTitle:@"酒红" forState:UIControlStateNormal];

            }
                break;
            case 7:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_qingning];
                [label setTitle:@"清宁" forState:UIControlStateNormal];

            }
                break;
            case 8:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_langman];
                [label setTitle:@"浪漫" forState:UIControlStateNormal];

            }
                break;
            case 9:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_guangyun];
                [label setTitle:@"光晕" forState:UIControlStateNormal];

            }
                break;
            case 10:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_landiao];
                [label setTitle:@"蓝调" forState:UIControlStateNormal];

            }
                break;
            case 11:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_menghuan];
                [label setTitle:@"梦幻" forState:UIControlStateNormal];

            }
                break;
            case 12:{
                image = [SCXBeautifulUtil SCX_beautifulImageWithImage:image colorMatrix:colormatrix_yese];
                [label setTitle:@"夜色" forState:UIControlStateNormal];

            }
                break;
                
                
            default:
                break;
        }
        
        imageView.image = image;
        imageView.backgroundColor = [UIColor blueColor];
        [self addSubview:label];
        [self addSubview:imageView];
    }
}
- (void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger tag = imageView.tag - 100 + 1000;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            if (view.tag == tag) {
                btn.selected = YES;
                if (btn.selected) {
                    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    [self handleBlock:imageView.image];
                }
                else{
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                }
            }
            
            
        }
    }
}
- (void)handleBlock:(UIImage *)image{
    void (^block) (UIImage *) = objc_getAssociatedObject(self, @"blockKey");
    
    if (block) {
        block(image);
    }
}

@end
