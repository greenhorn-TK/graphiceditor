//
//  ViewController.m
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/03.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import "ViewController.h"
#import "ToolAreaView.h"

@class ToolAreaView;

@interface ViewController ()

@end

@implementation ViewController
@synthesize canvas;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = CGRectMake(0, 0, 320, 320);
    self.canvas = [[DrawingCanvasView alloc] initWithFrame:frame];
    [self.view addSubview:canvas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

/******************************
 *ToolAreaViewデリゲートメソッド実装
 ******************************/
 
//消去
- (void)toolAreaViewClear:(ToolAreaView *)toolView
{
    [canvas clear];
}

//ペンサイズ変更
- (void)toolAreaViewPenSize:(ToolAreaView *)toolView Pensize:(float)pensize
{
    canvas.lineWidth = pensize;
}

//描画色選択
- (void)toolAreaViewDrawColor:(ToolAreaView *)toolView DrawColor:(UIColor *)color
{
    canvas.drawColor = color;
}

- (void)toolAreaViewToolSelect:(ToolAreaView *)toolView Tool:(int)toolnum
{
    canvas.drawType = toolnum;
}

//ツール選択
- (void)toolAreaViewLoad:(ToolAreaView *)toolView
{
    //
    NSArray* path_tbl = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    NSString* docPath = [path_tbl objectAtIndex:0];
    NSString* savePath = [NSString stringWithFormat:@"%@/%@", docPath, @"canvas_image.png"];
    
    //
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:savePath];
    if (image) {
        
        //クリアする
        [canvas clear];
        //drawContext上に描画
        CGContextDrawImage(canvas.drawContext,
                           CGRectMake(0, 0, image.size.width, image.size.height),
                           image.CGImage);
        
        //グラフィックコンテキストのレンダリング
        [canvas renderImage];
    }
}

//保存
- (void)toolAreaViewSave:(ToolAreaView *)toolView
{
    //グラフィックコンテキストをpngデータに変換
    CGImageRef cgImage = CGBitmapContextCreateImage(canvas.drawContext);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    NSData *data = UIImagePNGRepresentation(image);
    
    //ディレクトリのパス
    NSArray *path_tbl = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    NSString *docPath = [path_tbl objectAtIndex:0];
    NSString *savePath = [NSString stringWithFormat:@"%@/%@",
                          docPath,
                          @"canvas_image.png"];
    
    //保存
    [data writeToFile:savePath atomically:YES];
}

@end
