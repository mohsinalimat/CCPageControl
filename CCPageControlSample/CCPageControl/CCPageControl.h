
#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CCPageControl : UIControl

/**
 *  The current page, displayed as a filled circle.
 *
 *  The default value is 0.
 */
@property (nonatomic) IBInspectable NSInteger currentPage;

/**
 *  The number of page indicators to display.
 *
 *  The default value is 0.
 */
@property (nonatomic) IBInspectable NSInteger numberOfPages;

/**
 *  Hides the page control when there is only one page.
 *
 *  The default value is NO.
 */
@property (nonatomic) IBInspectable BOOL hidesForSinglePage;

/**
 *  Controls when the current page will update.
 *
 *  The default value is NO.
 */
@property (nonatomic) IBInspectable BOOL defersCurrentPageDisplay;

/**
 *  When set this property overrides the page indicator border color.
 *
 *  The default is the control's tintColor.
 */
@property (nonatomic, strong) IBInspectable UIColor *pageIndicatorTintColor;

/**
 *  When set this property overrides the current page indicator's fill color.
 *
 *  The default is the control's tintColor.
 */
@property (nonatomic, strong) IBInspectable UIColor *currentPageIndicatorTintColor;



/**
 *  The current page, diplayed as a filled or partially filled circle.
 *
 *  @param currentPage The current page indicator is filaled if the value is .0, and about half filled if ±.25.
 *  @param animated    YES to animate the transition to the new page, NO to make the transition immediate.
 */
- (void)setCurrentPage:(CGFloat)currentPage animated:(BOOL)animated;

/**
 *  Updates the current page indicator to the current page.
 */
- (void)updateCurrentPageDisplay;

/**
 *  Use to size the control to fit a certain number of pages.
 *
 *  @param pageCount A number of pages to calculate size from.
 *
 *  @return Minimum size required to display all page indicators.
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end
