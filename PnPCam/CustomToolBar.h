//
//  CustomToolBar.h
//  CustomToolBar


#import <UIKit/UIKit.h>
#import "CustomToolBarItem.h"

@interface CustomToolBar : UIView
@property (nonatomic, retain) UIImageView* arrowIv;
@property (nonatomic, retain) UIView* toolBarBg;
@property (nonatomic, retain) NSArray* items;
@property (nonatomic) int rowItems;
@property (nonatomic) float rowHeight;
@property (nonatomic) float width;
@property (nonatomic, retain) UIView* parentView;
@property (nonatomic) BOOL show;
- (id) initFrom:(UIView* ) parentView andRowItems:(int ) rowItems  andItems:(NSArray* ) items andRowHeight:(float) rowHeight andWidth:(float) width;
- (void) computeViewFrame;
- (void) layoutItems;
- (void) showToolBar;
- (void) dismissToolBar;
@end
