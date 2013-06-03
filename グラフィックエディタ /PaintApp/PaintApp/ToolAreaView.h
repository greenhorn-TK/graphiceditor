//
//  ToolAreaView.h
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/03.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ToolAreaView : UIView


//デリゲートオブジェクト
@property (weak, nonatomic) id delegate;

//各種ボタン（フリー/直線/長方形/楕円/選択）
@property (weak, nonatomic) IBOutlet UIButton* freeLineButton;
@property (weak, nonatomic) IBOutlet UIButton* lineButton;
@property (weak, nonatomic) IBOutlet UIButton* rectDrawButton;
@property (weak, nonatomic) IBOutlet UIButton* ellpseDrawButton;
@property (weak, nonatomic) IBOutlet UIButton* areaSelectButton;

//画面消去
@property (weak, nonatomic) IBOutlet UIButton* clearButton;
- (IBAction)clearAction:(id)sender;

//読み込み
@property (weak, nonatomic) IBOutlet UIButton* loadButton;
- (IBAction)loadAction:(id)sender;

//保存
@property (weak, nonatomic) IBOutlet UIButton* saveButton;
- (IBAction)saveAction:(id)sender;

//パレット
@property (weak, nonatomic) IBOutlet UIButton* colorPaletBaseView;

//ペンサイズ
@property (weak, nonatomic) IBOutlet UISlider* penSizeSlider;
- (IBAction)penSizeSliderAction:(id)sender;

//ボタン画像生成
+ (UIImage *)createButtonImage:(CGSize)btSize
                        Radius:(float)radius
                      isShadow:(BOOL)shadow
                  BaseRGBColor:(UIColor *)color;
@end

/*
 *デリゲートメソッド
 */
 
@protocol ToolAreaViewDelegate<NSObject>

//ツール選択
- (void)toolAreaViewToolSelect:(ToolAreaView *)toolView Tool:(int)toolnum;

//消去
- (void)toolAreaViewClear:(ToolAreaView *)toolView;

//セーブ
- (void)toolAreaViewSave:(ToolAreaView *)toolView;

//ペンサイズ
- (void)toolAreaViewDrawColor:(ToolAreaView *)toolView PenSize:(float)penSize;

@end