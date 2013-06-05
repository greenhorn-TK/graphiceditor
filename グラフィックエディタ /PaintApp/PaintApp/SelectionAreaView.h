//
//  SelectionAreaView.h
//  PaintApp
//
//  Created by T.Kobayashi on 13/06/05.
//  Copyright (c) 2013年 小林拓真. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectionAreaView : UIView

@property (nonatomic, retain) UIBezierPath* selectionPath;

- (BOOL)containsPoint:(CGPoint)point;
- (void)selectionOffset:(CGPoint)offset;

@end
