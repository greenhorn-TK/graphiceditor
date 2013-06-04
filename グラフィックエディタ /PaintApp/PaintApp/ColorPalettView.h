//
//  ColorPalettView.h
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/04.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/***************
 *カラーセルクラス
 ***************/
@interface ColorCellView : UIView
{
    CALayer* _cellLayer;
    BOOL _isInBounds;
}

@property (weak, nonatomic) id delegate;
@property (nonatomic) BOOL selected;

- (id)initWithFrame:(CGRect)frame Color:(UIColor *)color;
- (UIColor *)color;
- (void)setColor:(UIColor *)color;
@end

/****************
 *カラーパレットクラス
 ****************/
@interface ColorPaletteView : UIView
{
    ColorCellView* _selectColorCell;
}

@property (weak, nonatomic)id delegate;
- (UIColor *)selectedColor;

@end

/********************************
 *デリゲートメソッドをプロトコルとして定義
 ********************************/
@protocol ColorPaletteProtocol <NSObject>
- (void)ColorPalettColorSelected:(id)sender Color:(UIColor *)color;
@end
