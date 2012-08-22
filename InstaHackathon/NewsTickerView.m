//
//  NewsTickerView.m
//  InstaHackathon
//
//  Created by Omar Khan on 8/21/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "NewsTickerView.h"

#define kButtonBaseTag 10000
#define kLabelPadding 10
#define kItemPadding 30
#define kMaxWidth 200
#define kSpacer 100
#define kPixelsPerSecond 100.0f


#pragma mark - News Ticker View Class
@implementation NewsTickerView

#pragma mark - News Ticker View Properties
@synthesize dataSource = _dataSource;

- (void)awakeFromNib
{
    //  Setting up the initial properties for the scroll view
    self.bounces = YES;
    self.scrollEnabled = YES;
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)reloadData
{
    //  Checking to see how many items need to be displayed and setting background color
    int itemCount = [self.dataSource numberOfItemsForTickerView:self];
    self.backgroundColor = [self.dataSource backgroundColorForTickerView:self];
    
    int xPos = 0;
    for(int i = 0; i < itemCount; i++) {
        //  For each item create a new UIView and set the appropriate values for title value and image
        NewsTickerItemView *tickerItemView = [[NewsTickerItemView alloc] init];
        [tickerItemView setTitle:[self.dataSource tickerView:self titleForItemAtIndex:i]
                           value:[self.dataSource tickerView:self valueForItemAtIndex:i]
                           image:[self.dataSource tickerView:self imageForItemAtIndex:i]];
        
        //  Position the item and then add it to the view
        tickerItemView.frame = CGRectMake(xPos, 0, [tickerItemView width], self.frame.size.height);
        xPos += ([tickerItemView width] + kItemPadding);
        [self addSubview:tickerItemView];
    }
    
    //  Create an offset with the next item in the list
    self.contentSize = CGSizeMake(xPos + self.frame.size.width + kSpacer, self.frame.size.height);
    self.contentOffset = CGPointMake(- self.frame.size.width / 2, 0);

    //  Create the padded view and populate it with information and have it follow the previous one
    xPos += kSpacer;
    CGFloat breakWidth = 0;
    for(int theCounter = 0; breakWidth < self.frame.size.width; theCounter++) {
        int i = theCounter % itemCount;
        NewsTickerItemView *tickerItemView = [[NewsTickerItemView alloc] init];
        [tickerItemView setTitle:[self.dataSource tickerView:self titleForItemAtIndex:i]
                           value:[self.dataSource tickerView:self valueForItemAtIndex:i]
                           image:[self.dataSource tickerView:self imageForItemAtIndex:i]];
        tickerItemView.frame = CGRectMake(xPos, 0, [tickerItemView width], self.frame.size.height);
        xPos += ([tickerItemView width] + kItemPadding);
        breakWidth += ([tickerItemView width] + kItemPadding);
        [self addSubview:tickerItemView];
    }

    [self startAnimation];
}

- (void)startAnimation
{
    //  Setting up animation properties
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone
                           forView:self
                             cache:YES];
    //  Determine the speed and length of animation
    NSTimeInterval animationDuration = self.contentSize.width / kPixelsPerSecond;
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationDelegate:self];
    
    //  Restart the animation when it is done
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.contentOffset = CGPointMake(self.contentSize.width - self.frame.size.width, 0);
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.contentOffset = CGPointMake(0, 0);
    [self startAnimation];
    
}

@end

#pragma mark - News Ticker Item View Class
@interface NewsTickerItemView()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) UIImage *image;

@end

@implementation NewsTickerItemView

#pragma mark - News Ticker Item View Properties
@synthesize title = _title;
@synthesize value = _value;
@synthesize image = _image;

static UIFont *titleFont = nil;
static UIFont *valueFont = nil;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 10, 26);
        self.opaque = YES;
        self.contentMode = UIViewContentModeCenter;
        
    }
    return self;
}

+ (void)initialize
{
    titleFont = [UIFont boldSystemFontOfSize:15];
    valueFont = [UIFont systemFontOfSize:15];
}

#pragma mark - Width calculations
- (CGFloat)titleWidth
{
    return [self.title sizeWithFont:titleFont
                  constrainedToSize:CGSizeMake(kMaxWidth, self.frame.size.height)
                      lineBreakMode:UILineBreakModeClip].width;
}

- (CGFloat)valueWidth
{
    return [self.value sizeWithFont:valueFont
                  constrainedToSize:CGSizeMake(kMaxWidth, self.frame.size.height)
                      lineBreakMode:UILineBreakModeClip].width;
    
}

- (CGFloat)width
{
    return 18 + [self titleWidth] + [self valueWidth] + kLabelPadding;
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title value:(NSString *)value image:(UIImage *)image
{
    if(_title != title) {
        _title = title;
    }
    
    if(_value != value) {
        _value = value;
    }
    
    if(_image != image) {
        _image = image;
    }
    
    self.frame = CGRectMake(0, 0, [self width], 26);
    
    //[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //  Setting up graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor greenColor].CGColor);
    
    //  Drawing the images, titles and values for the ticker that will be
    //  displayed inside of the scroll view
    [self.image drawInRect:CGRectMake(0, 9, 12, 7)];
    [self.title drawInRect:CGRectMake(18, 2, [self titleWidth], 26) withFont:titleFont];
    [self.value drawInRect:CGRectMake(18 + [self titleWidth] + kLabelPadding, 2, [self valueWidth], 26) withFont:valueFont];
    
    [super drawRect:rect];
}

@end

