//
//  ViewController.m
//  CCPageControlSample
//
//  Created by Kelvin on 6/22/16.
//  Copyright © 2016 Cokile. All rights reserved.
//

#import "ViewController.h"
#import "CCPageControl.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CCPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*4, self.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    for (int i = 0; i<self.scrollView.contentSize.width/self.view.frame.size.width; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width+10, 120, 100, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"Page %d", i+1];
        [self.scrollView addSubview:label];
    }
    [self.view addSubview:self.scrollView];
    
    self.pageControl.numberOfPages = self.scrollView.contentSize.width/self.view.frame.size.width;
    [self.pageControl addTarget:self action:@selector(pageControlDidChangeCurrentPage:) forControlEvents:UIControlEventValueChanged];
}

- (void)pageControlDidChangeCurrentPage:(CCPageControl *)pageControl {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * (CGFloat)pageControl.currentPage, 0) animated: true];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.pageControl setCurrentPage:page];
}

@end
