//
//  ToolAreaView.m
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/03.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import "ToolAreaView.h"
#import "ViewController.h"

@class ViewController;

@interface ToolAreaView()
{
    UIButton* _selectToolButton;
}
@end

@implementation ToolAreaView

@synthesize delegate;
@synthesize freeLineButton;
@synthesize lineButton;
@synthesize rectDrawButton;
@synthesize ellpseDrawButton;
@synthesize areaSelectButton;
@synthesize clearButton;
@synthesize loadButton;
@synthesize saveButton;
@synthesize colorPaletBaseView;
@synthesize penSizeSlider;

//nibファイル読込み時
- (void)awakeFromNib
{
    //背景色設定
    //グラデーションレイヤー
    CAGradientLayer* graLayer = [CAGradientLayer layer];
    graLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    graLayer.startPoint = CGPointMake(0.5, 0.0);
    graLayer.startPoint = CGPointMake(0.5, 1.0);
    graLayer.locations = [NSArray arrayWithObjects:
                          (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0].CGColor,
                          (id)[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0].CGColor,
                          nil];
    
    //ボタン同時押し禁止
    freeLineButton.exclusiveTouch = YES;
    lineButton.exclusiveTouch = YES;
    rectDrawButton.exclusiveTouch = YES;
    ellpseDrawButton.exclusiveTouch = YES;
    areaSelectButton.exclusiveTouch = YES;
    clearButton.exclusiveTouch = YES;
    loadButton.exclusiveTouch = YES;
    saveButton.exclusiveTouch = YES;
    
    //消去ボタン
    UIImage* image;
    image = [ToolAreaView createButtonImage:clearButton.frame.size
                                              Radius:10
                                            isShadow:YES
                                        BaseRGBColor:[UIColor redColor]];
    
    //読み込みボタン
    image = [ToolAreaView createButtonImage:loadButton.frame.size
                                     Radius:10
                                   isShadow:YES
                               BaseRGBColor:[UIColor whiteColor]];
    [loadButton setBackgroundImage:image forState:UIControlStateNormal];
    
    //保存ボタン
    image = [ToolAreaView createButtonImage:saveButton.frame.size
                                     Radius:10
                                   isShadow:YES
                               BaseRGBColor:[UIColor whiteColor]];
    [loadButton setBackgroundImage:image forState:UIControlStateNormal];
    
    //デフォルトでフリーラインを選択
    [self toolSelectAction:freeLineButton];
}

//ツールを選択
- (IBAction)toolSelectAction:(UIButton *)sender{
    
    //現在の選択ボタンを非選択にする
    [_selectToolButton setSelected:NO];
    
    //選択ボタンの変更
    _selectToolButton = sender;
    
    //選択ボタンの変更
    [_selectToolButton setSelected:YES];
    
    //ツールの変更をデリゲートに通知
    int tag = sender.tag;
    if ([delegate respondsToSelector:@selector(toolAreaViewToolSelect:Tool:)]) {
        [delegate ToolAreaViewToolSelect:self Tool:tag];
    }
}

//消去
- (IBAction)clearAction:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(toolAreaViewClear:)]) {
        [delegate toolAreaViewLoad:self];
    }
}

//読み込み
- (IBAction)loadAction:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(toolAreaViewSave:)]) {
        [delegate toolAreaViewLoad:self];
    }
}

//ペンサイズ
- (IBAction)penSizeSliderAction:(UISlider *)sender
{
    float value = sender.value;
    if ([delegate respondsToSelector:@selector(toolAreaViewPenSize:PenSize:)]) {
        [delegate toolAreaViewPenSize:self PenSize:value];
    }
}

/**************************
 * クラスメソッドによるボタン生成
 * テキストp175〜
 **************************/

+ (UIImage *)createButtonImage:(CGSize)btSize
                        Radius:(float)radius
                      isShadow:(BOOL)shadow
                  BaseRGBColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(btSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //角丸四角
    float btW = btSize.width;
    float btH = btSize.height;
    CGRect rect = CGRectMake(4, 4, btW-8 ,btH-8);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    
    //影の描写
    if (shadow) {
        CGContextSaveGState(context);
        CGContextSetShadow(context, CGSizeMake(0, 3), 2);
        [path fill];
        CGContextRestoreGState(context);
    }
    
    //カラーの分解
    float r,g,b,a;
    if (![color getRed:&r green:&g blue:&b alpha:&a]) {
        if ([color getWhite:&r alpha:&a]) {
            g = r;
            b = r;
        }
    }
    
    //描画領域のクリップ
    [path addClip];
    
    //グラフィックステータス保存
    CGContextSaveGState(context);
    {
        CGGradientRef gradient;
        CGColorSpaceRef colorSpace;
        CGFloat locations[4] = {0.0, 0.5, 0.5, 1.0};
        CGFloat componts[16] = {
            r*0.65, g*0.65, b*0.65, a*1.0,
            r*0.85, g*0.85, b*0.85, a*1.0,
            r*0.95, g*0.95, b*0.95, a*1.0,
            r*1.00, g*1.00, b*1.00, a*1.00,
        };
        colorSpace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents(colorSpace, componts, locations, 4);
        CGPoint startPoint = CGPointMake(btSize.width/2, btSize.height);
        CGPoint endPoint = CGPointMake(btSize.width/2, 0.0);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
    
    //グラフィックステータス復元
    CGContextRestoreGState(context);
    
    //
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, (__bridge CGColorRef)([UIColor colorWithRed:r*0.3
                                                              green:g*0.3
                                                               blue:b*0.3
                                                              alpha:1.0]));
    CGContextSetLineWidth(context, 1.0);
    [path stroke];
    
    //
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end