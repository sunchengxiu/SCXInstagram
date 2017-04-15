//
//  SCXBeautifulUtil.m
//  仿Instagram美图
//
//  Created by 孙承秀 on 2017/4/15.
//  Copyright © 2017年 孙承秀. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SCXBeautifulUtil.h"

//#import "SCXColorMatrix.h"
@implementation SCXBeautifulUtil

/**
 传入图片和响应的颜色矩阵进行美图

 @param image 原始图片
 @param color 响应的颜色矩阵
 @return 美图后的图片
 */
+ (UIImage *)SCX_beautifulImageWithImage:(UIImage *)image colorMatrix:(const float *)color{

    // 用const 修饰颜色矩阵，防止修改颜色矩阵
    
    // 返回图片的像素数组
    unsigned char *imagePixelArray = SCX_imagePixelArray(image);
    
    // 获取图片的宽高
    CGImageRef imageRef = [image CGImage];
    size_t imageWidth = CGImageGetWidth(imageRef);
    size_t imageHeight = CGImageGetHeight(imageRef);
    
    // 循环数组修改图片的每一个像素点来进行美图效果
    // 因为像素数组中的每四个元素相当于原来图片的一个元素，所以需要定义变量来定位到指定的位置
    // 横向位置
    int wPoint = 0;
    // 竖向位置
    int hPoint = 0;
    
    for (size_t i = 0; i < imageHeight; i ++) {
        
        //hPoint = wPoint;
        for (size_t j = 0 ; j < imageWidth; j ++) {
            // 原始图片的每一个位置，在像素点数组中的对应位置
            int R = (unsigned char)imagePixelArray[hPoint];
            int G = (unsigned char)imagePixelArray[hPoint + 1];
            int B = (unsigned char)imagePixelArray[hPoint + 2];
            int A = (unsigned char)imagePixelArray[hPoint + 3];
            
            // 根据传进来的颜色矩阵进行美图
            SCX_beginBeautiful(&R, &G, &B, &A, color);
            
            // 替换原来的像素点数组
            imagePixelArray[hPoint] = R;
            imagePixelArray[hPoint + 1] = G;
            imagePixelArray[hPoint + 2] = B;
            imagePixelArray[hPoint + 3] = A;
            
            // 数组的索引要向后移动四个位置，因为像素数组的四个像素点相当于原图片数组的一个像素
            hPoint += 4;
        }
        //横向位置的宽度*4就是像素矩阵中的一行，那么每次+宽度*4就是向下走了几行，来便利原来图片的整个矩阵
        //wPoint += imageWidth * 4;
    }
    
    // 图片的大小,四个通道
    NSUInteger imageLength = imageWidth * imageHeight * 4;
    // 创建图像输出参数
    CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL, imagePixelArray, imageLength, NULL);
    
    // 每一个像素点的位数
    size_t piexlEveryBits = 8;
    
    // 每一个像素的大小，一个像素最多是四通道，ARGB= 4 * 8 = 32
    size_t piexlBits = 4 * 8;
    
    // 每一行的大小,因为每个像素最多四个字节
    size_t widthBits = 4 * imageWidth;
    
    // 获取颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // 获取图片
    CGImageRef resultRef = CGImageCreate(imageWidth, imageHeight, piexlEveryBits, piexlBits, widthBits, colorSpaceRef, bitInfo, providerRef, NULL, NO, renderingIntent);
    UIImage *resultImage = [UIImage imageWithCGImage:resultRef];
    
    // 释放内存,在C语言中，有create就要有release
    CFRelease(resultRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(providerRef);
    
    return resultImage;
}

/**
 返回一个指针，这个指针指向像素数组的首地址，数组里面存放的每四个字节，就是图像上面的一个像素点ARGB,有多少个四个字节，这张图片就是由多少像素组成
 之所以用无符号的原因是，像素点的ARGB取值范围都是0-255，刚好无符号的取值范围是0-255，二有符号数的取值范围是-128-127

 @param image 图片
 @return 像素数组
 */
static unsigned char *SCX_imagePixelArray(UIImage *image){
    
    CGImageRef imageRef = [image CGImage];
    // 获取图片上下文
    CGContextRef contextRef = SCX_createContextRef(imageRef);
    
    CGRect rect = {{0 , 0} , {image.size.width , image.size.height}};
    // 将图片画到上下文
    CGContextDrawImage(contextRef, rect, imageRef);
    
    // 获取像素字节数据
    unsigned char *bitArr = CGBitmapContextGetData(contextRef);
    
    // 释放上下文
    CGContextRelease(contextRef);
    return bitArr;
}

/**
 返回一个上下文

 @param imageRef 图片
 @return 上下文
 */
static CGContextRef SCX_createContextRef(CGImageRef imageRef){
    
    // 图片原始宽高
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // 每一个通道分量的字节大小
    size_t bitsPerComponent = 8;
    
    // 每一行总像素点占得总大小,四个通道
    size_t bytesPerRow = 4 * width;
    
    // 颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    // 需要分配的内存大小
    void * _Nullable data = malloc(bytesPerRow * height) ;

    // 创建上下文
    /**
     1:需要分配的内存空间大小
     2：图片宽
     3：图片高
     4：每一个像素点的位数
     5：每一行占用的总位数
     6：颜色空间
     */
    CGContextRef ref = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpaceRef, kCGImageAlphaPremultipliedLast);
    
    // 释放内存
    CGColorSpaceRelease(colorSpaceRef);
    
    return  ref;
}

/**
 修改RGB的值，达到美图效果

 @param r R
 @param g G
 @param b B
 @param a A
 @param colorMatrix 矩阵数组
 */
static void SCX_beginBeautiful(int *r , int *g , int *b, int *a , const float *colorMatrix){

    int red = *r;
    int green = *g;
    int blue = *b;
    int alpha = *a;
    
    // 原理是，用相应的矩阵数组的每一行分量来承当前的像素分量获得的值
    *r = colorMatrix[0] * red + colorMatrix[1] * green + colorMatrix[2] * blue + colorMatrix[3] * alpha + colorMatrix[4];
    *g = colorMatrix[0 + 5] * red + colorMatrix[1 + 5] * green + colorMatrix[2 + 5] * blue + colorMatrix[3 + 5] * alpha + colorMatrix[4 + 5] ;
    *b = colorMatrix[0 + 5 * 2] * red + colorMatrix[1 + 5 * 2] * green + colorMatrix[2 + 5 * 2] * blue + colorMatrix[3 + 5 * 2] * alpha + colorMatrix[4 + 5 * 2] ;
    *a = colorMatrix[0 + 5 * 3 ] * red + colorMatrix[1 + 5 * 3] * green + colorMatrix[2 + 5 * 3] * blue + colorMatrix[3 + 5 * 3 ] * alpha + colorMatrix[4 + 5 * 3] ;
    
    // 容错处理
    if (*r > 255) {
        *r = 255;
    }
    if (*r < 0) {
        *r = 0;
    }
    
    if (*g > 255) {
        *g = 255;
    }
    if (*g < 0) {
        *g = 0;
    }
    
    if (*b > 255) {
        *b = 255;
    }
    if (*b < 0) {
        *b = 0;
    }
    
    if (*a > 255) {
        *a = 255;
    }
    if (*a < 0) {
        *a = 0;
    }

}
@end
