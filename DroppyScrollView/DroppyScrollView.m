//
//  DroppyScrollView.m
//  DroppyScrollView
//
//  Created by Cem Olcay on 16/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "DroppyScrollView.h"

#define SpringDamping   0.3
#define SpringVelocity  0.6
#define Duration        0.3


@interface UIView (Droppy)

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)w;
- (CGFloat)h;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setW:(CGFloat)w;
- (void)setH:(CGFloat)h;

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration;
- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration;
- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration;

@end

@implementation UIView (Droppy)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)w {
    return self.frame.size.width;
}

- (CGFloat)h {
    return self.frame.size.height;
}


- (void)setX:(CGFloat)x {
    [self setFrame:(CGRect){{x, [self y]}, {[self w], [self h]}}];
}

- (void)setY:(CGFloat)y {
    [self setFrame:(CGRect){{[self x], y}, {[self w], [self h]}}];
}

- (void)setW:(CGFloat)w {
    [self setFrame:(CGRect){{[self x], [self y]}, {w, [self h]}}];
}

- (void)setH:(CGFloat)h {
    [self setFrame:(CGRect){{[self x], [self y]}, {[self w], h}}];
}


- (void)setRotationY:(CGFloat)y {
    
}

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration {
    [self animate:^{
        [self setY:[self y] + yAmount];
    }];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    }];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration {
    [self setAlpha:from];
    [self animate:^{
        [self setAlpha:to];
    }];
}


- (void)animate:(void(^)())animations {
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:nil];
}

@end

@implementation DroppyScrollView


@end
