//
//  NewsTickerView.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/21/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsTickerView;

@protocol NewsTickerViewDataSource <NSObject>

@required
- (UIColor *)backgroundColorForTickerView:(NewsTickerView *)tickerView;
- (int)numberOfItemsForTickerView:(NewsTickerView *)tickerView;

- (NSString *)tickerView:(NewsTickerView *)tickerView titleForItemAtIndex:(NSUInteger)index;
- (NSString *)tickerView:(NewsTickerView *)tickerView valueForItemAtIndex:(NSUInteger)index;
- (UIImage *)tickerView:(NewsTickerView *)tickerView imageForItemAtIndex:(NSUInteger)index;

@end

@interface NewsTickerView : UIScrollView

@property (strong, nonatomic) IBOutlet id<NewsTickerViewDataSource> dataSource;

- (void)reloadData;
- (void)startAnimation;

@end

@interface NewsTickerItemView : UIView

- (CGFloat)width;
- (void)setTitle:(NSString *)title value:(NSString *)value image:(UIImage *)image;

@end