//
//  UIFont+AppFonts.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AppFonts)

+ (UIFont*)appFontOfSize:(CGFloat)size;
+ (UIFont*)appLightFontOfSize:(CGFloat)size;
+ (UIFont*)appBoldFontOfSize:(CGFloat)size;

@end
