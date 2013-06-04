//
//  ColorPalettView.m
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/04.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import "ColorPalettView.h"
/********************************
 *カラーセルクラス
 ********************************/

@implementation ColorCellView

@synthesize delegate;
@synthesize selected;

- (id)initWithFrame:(CGRect)frame Color:(UIColor *)color
{
    self = [super init];
    if (self) {
        _cellLayer = [[CALayer alloc] init];
        _cellLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.layer addSublayer:_cellLayer];
        
        _cellLayer.borderWidth = 2;
        _cellLayer.masksToBounds = YES;
        _cellLayer.cornerRadius = 12;
        
        [self setColor:color];
        
        self.selected = NO;
    }
    return self;
}

- (UIColor *)color
{
    return [UIColor colorWithCGColor:_cellLayer.backgroundColor];
}

- (void)setColor:(UIColor *)color
{
    _cellLayer.backgroundColor = color.CGColor;
}

- (void)selected:(BOOL)sel
{
    selected = sel;
    if (selected) {
        _cellLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    }else{
        _cellLayer.bounds = CGRectMake(0, 0, self.frame.size.width*0.75, self.frame.size.height*0.75);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    if ([self pointInside:pt withEvent:event]) {
        _isInBounds = NO;
        self.selected = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isInBounds && [delegate respondsToSelector:@selector(colorPalettColorSelected:Color:)]) {
        [delegate ColorPalettColorSelected:self Color:[self color]];
    }
    _isInBounds = NO;
}
@end


/********************************
 *カラーパレットクラス
 ********************************/
#import "ColorPalettView.h"
@implementation ColorPaletteView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int cols = 0;
        int w = frame.size.width/4;
        int h = frame.size.height/2;
        for (int y=0; y<2; y++) {
            for (int x=0; x<4; x++) {
            UIColor* color;
                switch (cols) {
                    case 0: color=[UIColor blackColor]; break;
                    case 1: color=[UIColor redColor]; break;
                    case 2: color=[UIColor greenColor]; break;
                    case 3: color=[UIColor blueColor]; break;
                    case 4: color=[UIColor blueColor]; break;
                    case 5: color=[UIColor yellowColor]; break;
                    case 6: color=[UIColor grayColor]; break;
                    default: color=[UIColor whiteColor]; break;
                }
                CGRect rect = CGRectMake(w*x, h*x, w, h);
                ColorCellView* colCell = [[ColorCellView alloc] initWithFrame:rect Color:color];
                colCell.delegate = self;
                [self addSubview:colCell];
                if (cols==0) {
                    _selectColorCell = colCell;
                    _selectColorCell.selected = YES;
                }
            cols++;
            }

        }
    }
    return self;
}

- (UIColor *)selectedColor
{
    return _selectColorCell.color;
}

- (void)colorPalettColorSelected:(id)collcell Color:(UIColor *)color
{
    if (_selectColorCell!=collcell) {
        _selectColorCell.selected = NO;
        _selectColorCell = collcell;
    }
    _selectColorCell.selected = YES;
    
    if ([delegate respondsToSelector:@selector(ColorPalettColorSelected:Color:)]) {
        [delegate ColorPalettColorSelected:self Color:color];
    }
}


@end

