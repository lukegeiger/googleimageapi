//
//  GImage.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import "GImage.h"

@interface GImage()
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) NSURL* thumbURL;
@property (nonatomic, strong) NSString *imageTitle;
@property (nonatomic, strong) NSString *imageId;
@end

@implementation GImage

+(GImage*)gImageFromDict:(NSDictionary*)dict{
    
    GImage *gimage = [GImage new];
    
    NSNumber *width = [dict objectForKey:@"width"];
    NSNumber *height = [dict objectForKey:@"height"];

    gimage.size = CGSizeMake(width.floatValue, height.floatValue);
    
    NSNumber *tbWidth = [dict objectForKey:@"tbWidth"];
    NSNumber *tbHeight = [dict objectForKey:@"tbHeight"];
    
    gimage.thumbSize = CGSizeMake(tbWidth.floatValue, tbHeight.floatValue);
    
    gimage.url = [NSURL URLWithString:[dict objectForKey:@"url"]];
    gimage.thumbURL = [NSURL URLWithString:[dict objectForKey:@"tbUrl"]];

    gimage.imageTitle = [dict objectForKey:@"titleNoFormatting"];
    gimage.content = [dict objectForKey:@"contentNoFormatting"];
    
    gimage.imageId = [dict objectForKey:@"imageId"];

    return gimage;
}

@end
