//
//  DroppyScrollView.m
//  DroppyScrollView
//
//  Created by Cem Olcay on 16/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "DroppyScrollView.h"

#define SpringDamping   0.5
#define SpringVelocity  0.1
#define Duration        1

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


#pragma mark - DroppyView

@implementation UIView (Droppy)

#pragma mark Getters

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


#pragma mark Setters

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
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, DEGREES_TO_RADIANS(y), 1.0f, 0.0f, 0.0f);
    
    self.layer.transform = rotationAndPerspectiveTransform;
}


#pragma mark Custom Duration Animations

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration {
    [self animate:^{
        [self setY:[self y] + yAmount];
    } duration:duration];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    } duration:duration];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration {
    [self setAlpha:from];
    [UIView animateWithDuration:duration animations:^{
        [self setAlpha:to];
    }];
}

#pragma mark Makro Duration Animations

- (void)moveYBy:(CGFloat)yAmount {
    [self animate:^{
        [self setY:[self y] + yAmount];
    }];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    }];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to {
    [self setAlpha:from];
    [UIView animateWithDuration:Duration animations:^{
        [self setAlpha:to];
    }];
}


#pragma mark Animation Utils

- (void)animate:(void(^)())animations {
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:nil];
}

- (void)animate:(void(^)())animations duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:nil];
}

@end


#pragma mark - DroppyScrollView

@implementation DroppyScrollView


#pragma mark  Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        self.contentHeight = 0;
        self.itemPadding = 10;
        self.defaultDropLocation = DroppyScrollViewDefaultDropLocationTop;
        
        self.itemQueue = [[NSMutableArray alloc] init];
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark  Droppy Functions

- (void)dropSubview:(UIView *)view {
    if (self.defaultDropLocation == DroppyScrollViewDefaultDropLocationTop) {
        [self dropSubview:view atIndex:[self top]];
    } else if (self.defaultDropLocation == DroppyScrollViewDefaultDropLocationBottom) {
        [self dropSubview:view atIndex:[self bottom]];
    }
}

- (void)dropSubview:(UIView *)view atIndex:(NSInteger)index {
    [self addSubview:view];
    
    //index fix
    if (index <= 0)
        index = [self top];
    else if (index > [self bottom])
        index = [self bottom];
    
    //shift views under index
    for (NSInteger i = index; i < [self bottom]; i++) {
        UIView *item = (UIView *)[self.items objectAtIndex:i];
        CGFloat shiftAmount = [view h] + self.itemPadding;
        [item moveYBy:shiftAmount];
    }
    
    [view setY:[self YForIndex:index]];
    [view alphaFrom:0.2 to:1];
    
    [self.items insertObject:view atIndex:index];
    
    self.contentHeight += [view h] + self.itemPadding*2;
    [self setContentSize:CGSizeMake([self w], self.contentHeight)];
}


#pragma mark  Utils

- (NSInteger)top {
    return 0;
}

- (NSInteger)bottom {
    return self.items.count;
}


- (CGFloat)moveSizeByView:(UIView *)view {
    return [view h] + self.itemPadding;
}

- (CGFloat)YForIndex:(NSInteger)index {
    CGFloat y = self.itemPadding;
    for (NSInteger i = 0; i < index; i++) {
        y += [(UIView *)[self.items objectAtIndex:i] h] + self.itemPadding;
    }
    return y;
}

@end
