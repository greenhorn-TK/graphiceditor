//
//  ViewController.h
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/03.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingCanvasView.h"
#import "ToolAreaView.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) DrawingCanvasView* canvas;
@property (strong, nonatomic) ToolAreaView*		toolView;

@end
