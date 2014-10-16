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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.down = NO;
    
    self.box = [[UIView alloc] initWithFrame:CGRectMake(150, 40, 150, 150)];
    [self.box setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.box];
    
    [self setupDynamics];
}

- (void)setupDynamics {
    UIDynamicAnimator *dyn = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self moveBoxWithAnim];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
