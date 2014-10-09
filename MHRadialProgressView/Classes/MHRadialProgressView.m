//
//  MHRadialProgressView.m
//  MHRadialProgressView
//
//  Created by Mehfuz Hossain on 3/24/14.
//  Copyright (c) 2014 Mehuz Hossain. All rights reserved.
//

#import "MHRadialProgressView.h"

CGFloat kAnimationDuration = 0.5;
CGFloat kMHStorkeWidthRatio = 0.07;

@interface MHRadialProgressSegment : NSObject

@property (nonatomic, strong) NSNumber *value;
@property int index;
@property BOOL completed;

@end

@interface MHRadialProgressView()

@property (nonatomic, strong) NSNumber *totalValue;
@property (nonatomic, strong) NSNumber *maxValue;

@property (nonatomic, strong) NSString *format;
@property NSInteger progressIndex;
@property CGFloat startAngle;
@property double curentValue;
@property double initialValue;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) NSMutableArray *segments;

@property MHProgressStyle style;
@property NSNumber *fontHeight;
@property UIFont *font;

@property NSTimer* timer;

@end

@implementation MHRadialProgressView

- (id)initWithFrame:(CGRect)frame points:(NSArray *)points
{
    self = [super initWithFrame:frame];
    if (self) {
        _startAngle = -M_PI / 2;
        _style = MHProgressStylePercentage;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setProgressColor:[UIColor colorWithRed:112/255. green:198/255. blue:149/255. alpha:1.0]];
        
        self.segments = [[NSMutableArray alloc] initWithCapacity:[points count]];
        
        for (int index = 0; index <[points count];index++){
            
            NSNumber *point = [points objectAtIndex:index];
            
            MHRadialProgressSegment *segement = [[MHRadialProgressSegment alloc] init];
            
            [segement setIndex:index];
            [segement setValue:point];
            
            [self.segments addObject:segement];
            
            self.totalValue = @([self.totalValue doubleValue] + [segement.value doubleValue]);
            self.maxValue = [NSNumber numberWithDouble:MAX([segement.value doubleValue], [self.maxValue doubleValue])];
        }
        
        _format = @"%@";
        _curentValue = 0;
        
        _font = [UIFont systemFontOfSize:0.17 * MIN(self.bounds.size.width, self.bounds.size.height)];
        
        _textLabel = [[UILabel alloc]init];
        
        [_textLabel setAutoresizesSubviews:YES];
        
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setFont:_font];
        
        [_textLabel setFrame:self.bounds];
        
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        
        _fontHeight = [NSNumber numberWithFloat:(_textLabel.font.pointSize / 2) - 1];
        
        [self addSubview:_textLabel];
        
        _initialValue = 0.0;
        
        [self setNumber:@(0.0)];
        
    }
    
    return self;
}

- (void)setLabelWithFormat:(NSString*)format
{
    _format = format;
}


- (void)setNumber:(NSNumber*)number
{
    if (_style == MHProgressStylePercentage){
        double percentage = round(([number doubleValue] / [_totalValue doubleValue]) * 100);
        number = [NSNumber numberWithDouble:percentage];
        
        _format = @"%@%%";
    }
    
    NSAttributedString *attributedString = [self attributedTextWithFormat:_format value:number];
    
    [_textLabel setAttributedText:attributedString];
}

- (NSAttributedString*)attributedTextWithFormat:(NSString*)format value:(NSNumber*)value
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:_format, value]];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:0.37 * MIN(self.bounds.size.width, self.bounds.size.height)] range:NSMakeRange(0, attributedString.length)];
    
    NSCharacterSet *charecterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSRange alphaRange = [[attributedString string] rangeOfCharacterFromSet:charecterSet options:NSCaseInsensitiveSearch];
    
    [attributedString addAttributes:@{NSFontAttributeName:_font, NSBaselineOffsetAttributeName:_fontHeight} range:alphaRange];
    
    return attributedString;
}


- (void)setProgressStyle:(MHProgressStyle)style
{
    _style = style;
    
    switch (_style) {
        case MHProgressStyleNone:
            [self.textLabel removeFromSuperview];
            break;
            
        case MHProgressStyleValue:
            _format = @"%@";
            break;
            
        default:
            _format = @"%@%%";
            break;
    }
}

- (void)moveNext
{
    if (self.progressIndex < [self.segments count]){
        [self completeStep:[self.segments objectAtIndex:self.progressIndex]];
    }
}

- (void)moveNext:(NSNumber*)value
{
    MHRadialProgressSegment *segment = [[MHRadialProgressSegment alloc]init];
    
    [segment setValue:value];
    
    [self completeStep:segment];
}

- (void)completeStep:(MHRadialProgressSegment*)fragment
{
    double progressValue =  _curentValue + [fragment.value doubleValue];
    
    if (progressValue > [_totalValue doubleValue])
        return;
    
    CGRect rect = self.bounds;
    
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
	CGFloat diameter = MIN(rect.size.width, rect.size.height) - 10;
    
    float radius = diameter / 2.0;
    
    [self setCurentValue:progressValue];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGFloat endAngle = ([fragment.value doubleValue]/ [self.totalValue doubleValue]) * 2 * M_PI + _startAngle;
    
    [bezierPath addArcWithCenter:center radius:radius startAngle:_startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    
    [progressLayer setPath: bezierPath.CGPath];
    
    [progressLayer setStrokeColor:self.progressColor.CGColor];
    [progressLayer setFillColor:[UIColor clearColor].CGColor];
    [progressLayer setLineWidth:kMHStorkeWidthRatio * self.bounds.size.width];
    
    [progressLayer setStrokeStart:0.0];
    [progressLayer setStrokeEnd:1.0];
    
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animateStrokeEnd.duration  = kAnimationDuration * ([fragment.value doubleValue] / [self.maxValue doubleValue]);
    animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
    animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
    [progressLayer addAnimation:animateStrokeEnd forKey:nil];
    
    _startAngle = endAngle;
    
    self.timer= [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(increaseValue) userInfo:nil repeats:YES];
    
    self.progressIndex++;
    
    [fragment setCompleted:YES];
    
}

- (void)drawRect:(CGRect)rect
{
	CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
	CGFloat diameter = MIN(rect.size.width, rect.size.height) - 10;
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    float startAngle = 0.0;
	float radius = diameter / 2.0;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    startAngle = 0;
    float endAngle = 2 * M_PI;
    
    [bezierPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    // Set the display for the path, and stroke it
    [bezierPath setLineWidth:kMHStorkeWidthRatio * self.bounds.size.width];
    [[UIColor colorWithRed:69/255. green:71/255. blue:61/255. alpha:1.0] setStroke];
    [bezierPath stroke];
}

- (void)increaseValue{
    
   if (_initialValue >= _curentValue){
        [self.timer invalidate];
        return;
    }
    
    [self setNumber:[NSNumber numberWithInt:++_initialValue]];
}

@end

@implementation MHRadialProgressSegment

@end

