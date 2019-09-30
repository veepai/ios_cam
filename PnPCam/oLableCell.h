//
//  oLableCell.h
//  P2PCamera

#import <UIKit/UIKit.h>

@interface oLableCell : UITableViewCell
{
    IBOutlet UILabel *keyLable;
    IBOutlet UILabel *DescriptionLable;
    //给Label 设置一个足够的宽度和高度：200x40，以保证字体不会被缩小
}

@property (retain, nonatomic) UILabel *keyLable;
@property (retain, nonatomic) UILabel *DescriptionLable;

@end
