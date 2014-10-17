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

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


#pragma mark - DroppyView

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
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, DEGREES_TO_RADIANS(y), 0.0f, 1.0f, 0.0f);
    
    self.layer.transform = rotationAndPerspectiveTransform;
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


#pragma mark - DroppyScrollView

@implementation DroppyScrollView


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        self.contentHeight = 0;
        self.defaultDropLocation = DroppyScrollViewDefaultDropLocationTop;
        
        self.itemQueue = [[NSMutableArray alloc] init];
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - Droppy Functions

- (void)addSubview:(UIView *)view {
    if (self.defaultDropLocation == DroppyScrollViewDefaultDropLocationTop) {
        [self addSubview:view atIndex:[self top]];
    } else if (self.defaultDropLocation == DroppyScrollViewDefaultDropLocationBottom) {
        [self addSubview:view atIndex:[self bottom]];
    }
}

- (void)addSubview:(UIView *)view atIndex:(NSInteger)index {
    [super addSubview:view];
    
    //index fix
    if (index < 0)
        index = [self top];
    else if (index >= [self bottom])
        index = [self bottom];

    
    
}


#pragma mark - Utils

- (NSInteger)top {
    return 0;
}

- (NSInteger)bottom {
    return self.items.count - 1;
}

@end
