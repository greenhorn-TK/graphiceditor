//
//  DrawingCanvasView.h
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/03.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DrawingCanvasView : UIView

@property (nonatomic) CGContextRef drawContext;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor* drawColor;
@property (nonatomic) int drawType;

- (void)clear;
- (void)renderImage;

@end
