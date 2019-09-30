//
//  CustomToolBarItem.h
//  CustomToolBar


#import <UIKit/UIKit.h>
@class CustomToolBarItem;
@protocol CustomToolBarItemDelegate <NSObject>
- (void) TouchToItem:(CustomToolBarItem*) item;
@end
@interface CustomToolBarItem : UIView
@property (nonatomic, retain) UIImageView* separatorLine;
@property (nonatomic, retain) UIImageView* bottomseparatorLine;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIButton* itemBtn;
@property (nonatomic) int itemId;
@property (nonatomic, assign) id<CustomToolBarItemDelegate> delegate;

- (id)initwithItemId:(int) itemId andTitle:(NSString* )title andDelegate:(id) delegate;

@end
