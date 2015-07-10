//
//  GImage.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GImage : NSObject

@property (nonatomic, readonly) NSString *imageTitle;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSString *imageId;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) NSURL* url;
@property (nonatomic, readonly) NSURL* thumbURL;

@property (nonatomic, assign) CGSize thumbSize;

+(GImage*)gImageFromDict:(NSDictionary*)dict;

@end
