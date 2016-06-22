
#import "CCPageControl.h"

@interface CCPageControl () {
    CGFloat _currentPage;
    NSTimeInterval currentPageChangeAnimationDuration;
    
    UIView *currentPageIndicatorContainerView;
    UIView *currentPageIndicatorView;
    UIView *pageIndicatorMaskingView;
    UIView *pageIndicatorContainerView;
    
    CGFloat pageIndicatorSize;
    CGFloat pageIndicatorSpacing;
    CGFloat defaultControlHeight;
    
    UIPageControl *accessibilityPageControl;
}

@end

@implementation CCPageControl

#pragma mark - accessory methods
- (void)setCurrentPage:(NSInteger)currentPage {
    [self setCurrentPage:(CGFloat)currentPage animated:YES];
}

- (NSInteger)currentPage {
    return (NSInteger)_currentPage;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    NSInteger oldValue = _numberOfPages;
    _numberOfPages = numberOfPages;
    
    self.hidden = _hidesForSinglePage && _numberOfPages <= 1;
    if (_numberOfPages != oldValue) {
        [self clearPageIndicators];
        [self generatePageIndicators];
        [self updateMaskSubviews];
        [self invalidateIntrinsicContentSize];
    }
    if (_numberOfPages > oldValue) {
        [self updateCornerRadius];
        [self updateColors];
    }
    
    [self setCurrentPage:_currentPage animated:NO];
    [self updateAccessibility];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    
    self.hidden = _hidesForSinglePage && _numberOfPages <= 1;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    self.tintAdjustmentMode = enabled?UIViewTintAdjustmentModeNormal:UIViewTintAdjustmentModeDimmed;
}

#pragma mark - initialization methods
- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initialize];
    }
    
    [self didInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    [self didInit];
    
    return self;
}

#pragma mark - public methods
-(void)setCurrentPage:(CGFloat)currentPage animated:(BOOL)animated {
    CGFloat newPage = MAX(0, MIN(currentPage, (CGFloat)self.numberOfPages));
    _currentPage = newPage;
    [self updateCurrentPageDisplayWithAnimation:animated];
    [self updateAccessibility];
}

- (void)updateCurrentPageDisplay {
    [self updateCurrentPageDisplayWithAnimation:YES];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    CGFloat width = pageIndicatorSize * (CGFloat)pageCount + pageIndicatorSpacing * (CGFloat)MAX(0, pageCount - 1);
    
    return CGSizeMake(MAX(7, width), defaultControlHeight);
}

#pragma mark - overrided public methods
- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    [self updateColors];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    pageIndicatorContainerView.frame = self.bounds;
    pageIndicatorMaskingView.frame = self.bounds;
    currentPageIndicatorContainerView.frame = self.bounds;
    
    [self updateCurrentPageDisplayWithAnimation:NO];
    
    for (UIView *view in pageIndicatorContainerView.subviews) {
        view.frame = [self frameForPageIndicator:(CGFloat)[pageIndicatorContainerView.subviews indexOfObject:view] numberOfPages:self.numberOfPages];
    }
    
    for (UIView *view in pageIndicatorMaskingView.subviews) {
        view.frame = [self frameForPageIndicator:(CGFloat)[pageIndicatorMaskingView.subviews indexOfObject:view] numberOfPages:self.numberOfPages];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (self.numberOfPages == 0 || (self.hidesForSinglePage && self.numberOfPages == 1)) {
        return CGSizeZero;
    } else if (self.superview != nil) {
        return CGSizeMake(self.superview.bounds.size.width, defaultControlHeight);
    } else {
        return [self sizeForNumberOfPages:self.numberOfPages];
    }
}

- (CGSize)intrinsicContentSize {
    if (self.numberOfPages == 0 || (self.hidesForSinglePage && self.numberOfPages == 1)) {
        return CGSizeZero;
    } else {
        return [self sizeForNumberOfPages:self.numberOfPages];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    if (touch!=nil && self.enabled) {
        if ([touch locationInView:self].x < self.bounds.size.width/2) {
            if (_currentPage-floor(_currentPage) > 0.01) {
                _currentPage = floor(_currentPage);
            } else {
                _currentPage = MAX(0, floor(_currentPage)-1);
            }
        } else {
            _currentPage = MIN(round(_currentPage+1), (CGFloat)(self.numberOfPages-1));
        }
        
        if (!self.defersCurrentPageDisplay) {
            [self updateCurrentPageDisplayWithAnimation:YES];
            [self updateAccessibility];
        }
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - private methods
- (void)initialize {
    self.numberOfPages = 0;
    self.hidesForSinglePage = NO;
    self.defersCurrentPageDisplay = NO;
    self.pageIndicatorTintColor = self.tintColor;
    self.currentPageIndicatorTintColor = self.tintColor;
    
    _currentPage = 0;
    currentPageChangeAnimationDuration = 0.3;
    
    currentPageIndicatorContainerView = [UIView new];
    currentPageIndicatorView = [UIView new];
    pageIndicatorMaskingView = [UIView new];
    pageIndicatorContainerView = [UIView new];
    
    pageIndicatorSize = 7;
    pageIndicatorSpacing = 9;
    defaultControlHeight = 37;
    
    accessibilityPageControl = [UIPageControl new];
}

- (void)didInit {
    [currentPageIndicatorContainerView addSubview:currentPageIndicatorView];
    currentPageIndicatorContainerView.layer.mask = pageIndicatorMaskingView.layer;
    [self addSubview:currentPageIndicatorContainerView];
    
    [self addSubview:pageIndicatorContainerView];
    
    [self generatePageIndicators];
    [self updateMaskSubviews];
    
    [self updateCornerRadius];
    [self updateColors];
    
    [self updateCurrentPageDisplayWithAnimation:NO];
    [self updateAccessibility];
}

- (void)updateCurrentPageDisplayWithAnimation:(BOOL)animated {
    CGRect frame = [self frameForPageIndicator:_currentPage numberOfPages:self.numberOfPages];
    if (animated && currentPageChangeAnimationDuration > 0.0) {
        [UIView animateWithDuration:currentPageChangeAnimationDuration animations:^{
            currentPageIndicatorView.frame = frame;
        }];
    } else {
        currentPageIndicatorView.frame = frame;
    }
}

- (void)updateAccessibility {
    accessibilityPageControl.currentPage = self.currentPage;
    accessibilityPageControl.numberOfPages = self.numberOfPages;
    
    self.isAccessibilityElement = accessibilityPageControl.isAccessibilityElement;
    self.accessibilityLabel = accessibilityPageControl.accessibilityLabel;
    self.accessibilityHint = accessibilityPageControl.accessibilityHint;
    self.accessibilityTraits = accessibilityPageControl.accessibilityTraits;
    self.accessibilityValue = accessibilityPageControl.accessibilityValue;
}

- (void)clearPageIndicators {
    for (UIView *view in pageIndicatorContainerView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)generatePageIndicators {
    for (int i = 0; i<self.numberOfPages; i++) {
        UIView *view = [UIView new];
        [pageIndicatorContainerView addSubview:view];
    }
}

- (void)updateMaskSubviews {
    for (UIView *dotView in pageIndicatorMaskingView.subviews) {
        [dotView removeFromSuperview];
    }
    
    for (int i = 0; i<self.numberOfPages; i++) {
        UIView *view = [UIView new];
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [pageIndicatorMaskingView addSubview:view];
    }
}

- (void)updateCornerRadius {
    currentPageIndicatorView.layer.cornerRadius = pageIndicatorSize/2.0;
    for (UIView *view in pageIndicatorContainerView.subviews) {
        view.layer.cornerRadius = pageIndicatorSize/2.0;
    }
    
    for (UIView *view in pageIndicatorMaskingView.subviews) {
        view.layer.cornerRadius = pageIndicatorSize/2.0;
    }
}

- (void)updateColors {
    currentPageIndicatorView.backgroundColor = self.currentPageIndicatorTintColor?self.currentPageIndicatorTintColor:self.tintColor;
    
    for (UIView *view in pageIndicatorContainerView.subviews) {
        view.layer.borderColor = self.pageIndicatorTintColor.CGColor?self.pageIndicatorTintColor.CGColor:self.tintColor.CGColor;
        view.layer.borderWidth = 0.5;
    }
}

- (CGRect)frameForPageIndicator:(CGFloat)page numberOfPages:(NSInteger)numberOfPages {
    CGFloat clampedHorizontalIndex = MAX(0, MIN(page, (CGFloat)self.numberOfPages-1));
    CGSize size = [self sizeForNumberOfPages:numberOfPages];
    CGFloat horizontalCenter = self.bounds.size.width/2.0;
    CGFloat verticalCenter = self.bounds.size.height/2.0-pageIndicatorSize/2.0;
    CGFloat horizontalOffset = (pageIndicatorSize+pageIndicatorSpacing)*clampedHorizontalIndex;
    return CGRectMake(horizontalOffset-size.width/2.0+horizontalCenter, verticalCenter, pageIndicatorSize, pageIndicatorSize);
}

@end
