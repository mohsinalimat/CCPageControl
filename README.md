## CCPageControl

A nice, animated UIPageControl alternative. Written in Swift but ported to Objective-C.

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/601431/10017520/6563ec6e-612f-11e5-872f-0d75c3b31fd2.gif">
</p>
<h1 align="center">Page Control</h1>

[![](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Cokile/CCPageControl/blob/master/Licence)
[![](https://img.shields.io/github/release/Cokile/CCPageControl.svg)](https://github.com/Cokile/CCPageControl/releases)



## Installation

### Use Cocoapods

Simply add one line to your Podfile:

```
pod 'CCPageControl'
```

### Manually 

Add all the files in the CCPageControl folder to your project.



## Easy to use

### Add to user interface

#### Use Interface Builder

Drag a `UIView` to your `UIViewController` and set it's class to `CCPageControl` in the `Identity inspector`. Now you can simply set the public properties in the `Attributes inspector`.

Remember to add an outlet to your `UIViewController` for the `CCPageControl`.

#### Programmatically

```objective-c
#import "CCPageControl"

// property declaration
@property (nonatomic, strong) CCPageControl *pageControl;

- (void)viewDidLoad {
    // ...
    CGRect frame = //Your frame;
    self.pageControl = [[CCPageControl alloc] initWithFrame:frame];
    self.pageControl.pageIndicatorTintColor = <#UIColor#>; // The default value is UIControl's default tint color.
    self.pageControl.currentPageIndicatorTintColor = <#UIColor#>; // The default value is UIControl's default tint color.
    self.pageControl.numberOfPages = <#NSInteger#>;
    self.pageControl.hidesForSinglePage = YES; // The default value is NO.
    self.pageControl.defersCurrentPageDisplay = YES; // The default value is NO.
}
```

__Note:__ `currentPage`  starts from 0.

### Work with UIScrollView

```objective-c
- (void)viewDidLoad {
    // ...
    self.scrollView.delegate = self;
    
    [self.pageControl addTarget:self action:@selector(pageControlDidChangeCurrentPage:) forControlEvents:UIControlEventValueChanged];
}

- (void)pageControlDidChangeCurrentPage:(CCPageControl *)pageControl {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * (CGFloat)pageControl.currentPage, 0) animated: true];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.pageControl setCurrentPage:page];
}
```



## Acknowledgement

Thanks to original developer Kasper Lahti.

[https://github.com/kasper-lahti/PageControl](https://github.com/kasper-lahti/PageControl)
