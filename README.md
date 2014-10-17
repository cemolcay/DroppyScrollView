DroppyScrollView
================

Vertical scroll view with abilty to inserting and removing subviews top or any index with stylish dropping animations.<br>
Just use `dropSubview:atIndex:` or `dropSubview:` instead of `addSubview:`.

Demo
----

![alt tag](https://raw.githubusercontent.com/cemolcay/DroppyScrollView/master/demo.gif)

Usage
-----

Copy & paste the DroppyScrollView.h/m to your project. <br>
Implement it just like any UIScrollView

    DroppyScrollView droppy = [[DroppyScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:droppy];


For dropping subview
    //create your subview
    UIView *v = ...
    ...
    
    [droppy dropSubview:v];


Droppy automagically sets its `contentSize` when you add or remove subviews.
<br>
You can add or remove a view at any index.

    - (void)dropSubview:(UIView *)view atIndex:(NSInteger)index;
    
    - (void)removeSubviewAtIndex:(NSInteger)index;

Optional Values
---------------

    @property (nonatomic, assign) CGFloat itemPadding;
  
  Padding between the views.
  Default is 10.


    typedef NS_ENUM(NSUInteger, DroppyScrollViewDefaultDropLocation) {
        DroppyScrollViewDefaultDropLocationTop,
        DroppyScrollViewDefaultDropLocationBottom,
    };
    
    @property (assign) DroppyScrollViewDefaultDropLocation defaultDropLocation;
  
  Default drop location used in `dropSubview:` function.
  DroppyScrollViewDefaultDropLocationBottom is the default value.
  
  




