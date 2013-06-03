//
//  DrawingCanvasView.m
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/03.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import "DrawingCanvasView.h"

@implementation DrawingCanvasView
@synthesize drawContext;
@synthesize lineWidth;
@synthesize drawType;
@synthesize drawColor;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        self.drawContext = CGBitmapContextCreate(nil,
                                                 frame.size.width,
                                                 frame.size.height,
                                                 8,
                                                 4*frame.size.width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
        CGContextSetLineCap(drawContext, kCGLineCapRound);
        CGContextSetLineJoin(drawContext, kCGLineJoinRound);
        CGColorSpaceRelease(colorSpace);
        
        //ラインサイズ
        self.lineWidth = 6;
        //描画色
        self.drawColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return self;
}

- (void)dealloc
{
    //グラフィックコンテキスト
    CGContextRelease(drawContext);
}

- (void)setLineWidth:(CGFloat)width
{
    lineWidth = width;
    CGContextSetLineWidth(drawContext, lineWidth);
}

- (void)setDrawColor:(UIColor *)color
{
    drawColor = color;
    CGContextSetStrokeColorWithColor(drawContext, drawColor.CGColor);
    CGContextSetFillColorWithColor(drawContext, drawColor.CGColor);
}

- (void)clear
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextClearRect(drawContext, rect);
    [self renderImage];
}

- (void)renderImage
{
    //グラフィックコンテキストからCGImageRef作成
    //CGlayerコンテンツとして設定
    CGImageRef cgImage = CGBitmapContextCreateImage(drawContext);
    self.layer.contents = (__bridge_transfer id)cgImage;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //指の位置取得
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    CGPoint prvPt = [touch previousLocationInView:self];
    //グラフィックコンテキスト
    CGContextSaveGState(drawContext);
    //上下反転
    CGContextTranslateCTM(drawContext, 0, self.frame.size.height);
    CGContextScaleCTM(drawContext, 1, -1);
    //描画
    CGContextBeginPath(drawContext);
    CGContextMoveToPoint(drawContext, prvPt.x, prvPt.y);
    CGContextAddLineToPoint(drawContext, pt.x, pt.y);
    CGContextStrokePath(drawContext);
    //グラフィックコンテキスト復元
    CGContextRestoreGState(drawContext);
    //グラフィックコンテキストのレンダリング
    [self renderImage];
}




@end
