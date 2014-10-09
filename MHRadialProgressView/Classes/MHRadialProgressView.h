//
//  MHRadialProgressView.h
//  MHRadialProgressView
//
//  Created by Mehfuz Hossain on 3/24/14.
//  Copyright (c) 2014 Mehuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHProgressStyle){
    MHProgressStylePercentage,
    MHProgressStyleValue,
    MHProgressStyleNone
} ;

@interface MHRadialProgressView : UIView

extern CGFloat kMHStorkeWidthRatio;
extern CGFloat kAnimationDuration;

@property (nonatomic, strong) UIColor *progressColor;

- (id)initWithFrame:(CGRect)frame points:(NSArray*)points;

// Creates the attributed text on based on format. Override it in order to customize the label.
- (NSAttributedString*)attributedTextWithFormat:(NSString*)format value:(NSNumber*)value;

// Default is MHProgressStylePercentage. Sets the progress style
- (void)setProgressStyle:(MHProgressStyle)style;

- (void)setLabelWithFormat:(NSString*)format;

- (void) moveNext:(NSNumber*)value;

- (void) moveNext;

@end
