//
//  UIView+AppViews.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AppViews)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat bottomY;
@property (nonatomic, assign) CGFloat endX;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;

@end
