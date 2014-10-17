//
//  ViewController.m
//  DroppyScrollView
//
//  Created by Cem Olcay on 16/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "ViewController.h"
#import "DroppyScrollView.h"

#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) DroppyScrollView *droppy;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:add];
    
    self.droppy = [[DroppyScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.droppy];

    self.index = 0;
}

- (void)addButtonPressed:(id)sender {
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 150)];
    [v setBackgroundColor:[self randomColor]];
    [v setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25]];
    [v setTextAlignment:NSTextAlignmentCenter];
    [v setText:[NSString stringWithFormat:@"item %lu", self.index++]];

    [self.droppy dropSubview:v atIndex:1];
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
