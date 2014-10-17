//
//  ViewController.m
//  DroppyScrollView
//
//  Created by Cem Olcay on 16/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "ViewController.h"
#import "DroppyScrollView.h"

@interface ViewController ()
@property (nonatomic, strong) DroppyScrollView *droppy;
@property (nonatomic, strong) UIView *box;
@property (nonatomic, assign) BOOL down;
@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.down = NO;
    
    self.box = [[UIView alloc] initWithFrame:CGRectMake(150, 40, 150, 150)];
    [self.box setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.box];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self droppyViewTestRotate];
    self.down = !self.down;
}


- (void)moveBoxWithSpringAnim {
    CGPoint movePoint = CGPointMake(self.box.frame.origin.x, self.down?40:340);
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:kNilOptions animations:^{
        [self.box setFrame:(CGRect){movePoint, self.box.frame.size}];
    } completion:^(BOOL finished) {
        self.down = !self.down;
    }];
}

- (void)moveBoxWithAnim {
    CGPoint movePoint = CGPointMake(self.box.frame.origin.x, self.down?40:340);

    [UIView animateWithDuration:0.3 animations:^{
        [self.box setFrame:(CGRect){movePoint, self.box.frame.size}];
    } completion:^(BOOL finished) {
        self.down = !self.down;
    }];
}


- (void)droppyViewTestMove {
    CGFloat by = self.down?-100:100;
    [self.box moveYBy:by];
}

- (void)droppyViewTestRotate {
    CGFloat from = self.down?45:0;
    CGFloat to = self.down?0:45;
    [self.box rotateYFrom:from to:to];
    [self.box alphaFrom:0.2 to:1 duration:1.3];
}

- (void)droppyViewTestCombine {
    
}


@end
