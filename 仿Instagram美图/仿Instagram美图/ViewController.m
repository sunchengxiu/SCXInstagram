//
//  ViewController.m
//  仿Instagram美图
//
//  Created by 孙承秀 on 2017/4/15.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "ViewController.h"
#import "SCXBottomView.h"
@interface ViewController ()


/*************  imageVIew ***************/
@property ( nonatomic , strong )UIImageView *imageView;

/*************  scrollView ***************/
@property ( nonatomic , strong )SCXBottomView *scrollView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
   
}
-(UIImageView *)imageView{

    if (!_imageView) {
        // 1000 1280 1.28 *3
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2, 20, 300, 384)];
        _imageView.image = [UIImage imageNamed:@"WechatIMG1 1"];
    }
    return _imageView;
}
-(SCXBottomView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[SCXBottomView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 178, [UIScreen mainScreen].bounds.size.width, 178) clickBlock:^(UIImage *image) {
            self.imageView.image = image;
        }];
        _scrollView.contentSize = CGSizeMake(110 * 13, 178);
        //_scrollView.backgroundColor = [UIColor redColor];
    }
    return  _scrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
