//
//  DroppyScrollView.h
//  DroppyScrollView
//
//  Created by Cem Olcay on 16/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Droppy)

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)w;
- (CGFloat)h;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setW:(CGFloat)w;
- (void)setH:(CGFloat)h;

- (void)moveYBy:(CGFloat)yAmount;
- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to;
- (void)alphaFrom:(CGFloat)from to:(CGFloat)to;

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate;
- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate;
- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate;

@end


typedef NS_ENUM(NSUInteger, DroppyScrollViewDefaultDropLocation) {
    DroppyScrollViewDefaultDropLocationTop,
    DroppyScrollViewDefaultDropLocationBottom,
};

@interface DroppyScrollView : UIScrollView

@property (nonatomic, assign) CGFloat itemPadding; //default 10
@property (assign) DroppyScrollViewDefaultDropLocation defaultDropLocation; //default top


- (instancetype)initWithFrame:(CGRect)frame;

- (void)dropSubview:(UIView *)view;
- (void)dropSubview:(UIView *)view atIndex:(NSInteger)index;

- (void)removeSubviewAtIndex:(NSInteger)index;

- (NSInteger)randomIndex;

@end
