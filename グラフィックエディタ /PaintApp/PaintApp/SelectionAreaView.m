//
//  SelectionAreaView.m
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/05.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import "SelectionAreaView.h"

@implementation SelectionAreaView
@synthesize selectionPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (selectionPath) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        CGContextAddPath(context, selectionPath.CGPath);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4].CGColor);
        CGContextDrawPath(context, kCGPathEOFill);
    }
}

- (BOOL)containsPoint:(CGPoint)point
{
    return [selectionPath containsPoint:point];
}

- (void)selectionOffset:(CGPoint)offset
{
    CGRect bounds = selectionPath.bounds;
    float x = bounds.origin.x;
    float y = bounds.origin.y;
    float w = bounds.size.width;
    float h = bounds.size.height;
    
    CGRect rect = CGRectMake(x+offset.x, y+offset.y, w, h);
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:rect];
    self.selectionPath = path;
}

- (void)setSelectionPath:(UIBezierPath *)path
{
    selectionPath = path;
    [self setNeedsDisplay];
}

@end
