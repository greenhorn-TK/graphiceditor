//
//  DrawingCanvasView.m
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/03.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import "DrawingCanvasView.h"

@interface DrawingCanvasView(){
    CGPoint _startPt;
}

@property (strong, nonatomic)DrawingCanvasView* overDrawView;

@end


@implementation DrawingCanvasView

@synthesize drawContext;
@synthesize lineWidth;
@synthesize drawType;
@synthesize drawColor;
@synthesize overDrawView;

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
    
    /*--------------------------------*/
    
    switch (drawType) {
        case 0:
        {
            
        }break;
            
        case 1:
        case 2:
        case 3:
        {
            [self.overDrawView clear];
            CGContextRef context = self.overDrawView.drawContext;
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0, self.frame.size.height);
            CGContextScaleCTM(context, 1, -1);
            CGContextBeginPath(context);
            
            if (drawType==1) {
                CGContextMoveToPoint(context, _startPt.x, _startPt.y);
                CGContextAddLineToPoint(context, pt.x, pt.y);
                CGContextStrokePath(context);
            } else if (drawType==2){
                float x = MIN(_startPt.x, pt.x);
                float y = MIN(_startPt.y, pt.y);
                int w = abs(_startPt.x-pt.x);
                int h = abs(_startPt.y-pt.y);
                
                CGRect rect = CGRectMake(x, y, w, h);
                CGContextAddRect(context, rect);
                CGContextFillPath(context);
            }
            CGContextRestoreGState(context);
            [self.overDrawView renderImage];
        }break;
        case 4:
        {
            
        }break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.overDrawView) {
        CGImageRef cgImage;
        cgImage = CGBitmapContextCreateImage(self.overDrawView.drawContext);
        
        CGContextDrawImage(drawContext, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), cgImage);
        [self renderImage];
        
        CGImageRelease(cgImage);
        [self.overDrawView removeFromSuperview];
        self.overDrawView = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//メニューを非表示
	UIMenuController*	menu = [UIMenuController sharedMenuController];
	if([menu isMenuVisible]){
		[menu setMenuVisible:NO animated:YES];
		return;
	}
    
    UITouch* touch = [touches anyObject];
    _startPt = [touch locationInView:self];
    
    switch (drawType) {
        case 1:
        case 2:
        case 3:
        {
            self.overDrawView = [[DrawingCanvasView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.overDrawView.userInteractionEnabled = NO;
            self.overDrawView.lineWidth = lineWidth;
            self.overDrawView.drawColor = drawColor;
            [self addSubview:overDrawView];
        }break;
    }
}

@end
