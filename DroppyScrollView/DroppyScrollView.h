//
//  DroppyScrollView.h
//  DroppyScrollView
//
//  Created by Cem Olcay on 16/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DroppyScrollViewDefaultDropLocation) {
    DroppyScrollViewDefaultDropLocationTop,
    DroppyScrollViewDefaultDropLocationBottom,
};

@interface DroppyScrollView : UIScrollView

@property (nonatomic, strong) NSMutableArray *itemQueue;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) CGFloat contentHeight;

@property (assign) DroppyScrollViewDefaultDropLocation defaultDropLocation;


- (void)addSubview:(UIView *)view;
- (void)addSubview:(UIView *)view atIndex:(NSInteger)index;

- (instancetype)initWithFrame:(CGRect)frame;

@end
