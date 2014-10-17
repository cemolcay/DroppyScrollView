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
#define Duration        0.5

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


#pragma mark Custom Animations

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self animate:^{
        [self setY:[self y] + yAmount];
    } duration:duration
     complication:complate];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    } duration:duration
     complication:complate];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self setAlpha:from];
    [UIView animateWithDuration:duration animations:^{
        [self setAlpha:to];
    } completion:complate];
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

- (void)animate:(void(^)())animations duration:(NSTimeInterval)duration complication:(void(^)(BOOL))complate {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:complate];
}

@end


#pragma mark - DroppyScrollView

@interface DroppyScrollView ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *itemsQueue;

@property (nonatomic, assign, getter=isAdding) BOOL adding;
@property (nonatomic, assign, getter=isRemoving) BOOL removing;

@end

@implementation DroppyScrollView


#pragma mark  Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        self.items = [[NSMutableArray alloc] init];
        self.itemsQueue = [[NSMutableArray alloc] init];
        
        self.removing = NO;
        self.adding = NO;
        
        self.itemPadding = 10;
        self.defaultDropLocation = DroppyScrollViewDefaultDropLocationBottom;
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
    
    if (self.isAdding || self.isRemoving) {
        [self addViewToQueue:view index:index];
        return;
    }
    
    [self setAdding:YES];
    [self addViewToQueue:view index:index];
    [self addSubview:view];
    
    //index fix
    if (index < [self top])
        index = [self top];
    else if (index > [self bottom])
        index = [self bottom];
    
    //shift down views under index
    for (NSInteger i = index; i < [self bottom]; i++) {
        UIView *item = (UIView *)[self.items objectAtIndex:i];
        CGFloat shiftAmount = [view h] + self.itemPadding;
        
        [item moveYBy:shiftAmount];
    }
    
    //add view animations
    [view setY:[self YForIndex:index]];
    [view setRotationY:45];
    [view setAlpha:0.5];
    [view animate:^{
        [view setRotationY:0];
        [view setAlpha:1];
    } duration:Duration complication:^(BOOL finished) {
        [self.itemsQueue removeObjectAtIndex:0];
        [self.items insertObject:view atIndex:index];
        
        [self updateContentSize];
        [self setAdding:NO];
    }];
}


- (void)removeSubviewAtIndex:(NSInteger)index {
    if (index < 0 || index >= [self bottom] || [self bottom] == 0 || self.isRemoving || self.isAdding) {
        return;
    }
    
    [self setRemoving:YES];
    
    UIView *removingView = (UIView *)[self.items objectAtIndex:index];
    
    //shift up views under index
    for (NSInteger i = index+1; i < [self bottom]; i++) {
        UIView *item = (UIView *)[self.items objectAtIndex:i];
        CGFloat shiftAmount = [removingView h] + self.itemPadding;
        
        [item moveYBy:shiftAmount*-1];
    }
    
    //remove view
    [removingView animate:^{
        [removingView setAlpha:0];
    } duration:Duration complication:^(BOOL finished) {
        
        if (finished) {
            //droppy management
            [removingView removeFromSuperview];
            [self.items removeObjectAtIndex:index];
            
            [self updateContentSize];
            [self setRemoving:NO];
        }
    }];
}


- (void)updateContentSize {
    CGFloat height = self.itemPadding;
    for (UIView *view in self.items) {
        height += [view h] + self.itemPadding;
    }
    
    [self setContentSize:CGSizeMake([self w], height)];
}

- (void)addViewToQueue:(UIView *)view index:(NSInteger)index {
    NSDictionary *obj = @{@"view":view, @"index":@(index)};
    if ([self.itemsQueue containsObject:obj]) {
        return;
    } else {
        [self.itemsQueue addObject:obj];
    }
}

- (void)setAdding:(BOOL)adding {
    _adding = adding;
    
    if (!adding) {
        if (self.itemsQueue.count > 0){
            [self dropSubview:[[self.itemsQueue firstObject] objectForKey:@"view"] atIndex:[[[self.itemsQueue firstObject] objectForKey:@"index"] integerValue]];
        }
    }
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

- (NSInteger)randomIndex {
    if ([self bottom] == 0)
        return 0;
    else return arc4random()%[self bottom];
}

@end
