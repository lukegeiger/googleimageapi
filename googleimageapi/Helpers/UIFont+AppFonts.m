//
//  UIFont+AppFonts.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import "UIFont+AppFonts.h"

@implementation UIFont (AppFonts)

+ (UIFont*)appFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}
+ (UIFont*)appLightFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}
+ (UIFont*)appBoldFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

@end
