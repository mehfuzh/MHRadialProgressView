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
    MHProgressStyleValue
} ;

@interface MHRadialProgressView : UIView

- (id)initWithFrame:(CGRect)frame points:(NSArray*)points;

// Default is MHProgressStylePercentage. Sets the progress style
- (void)setProgressStyle:(MHProgressStyle)style;

- (void)setLabelWithFormat:(NSString*)format;

- (void) moveNext:(NSNumber*)value;

- (void) moveNext;

@end
