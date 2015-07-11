//
//  GImage.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

//Frameworks
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GImage : NSObject

/*
 Supplies the title of the image, which is usually the base filename (for example, monkey.png.)
*/
@property (nonatomic, readonly) NSString *imageTitle;

/*
 Supplies a brief snippet of information from the page associated with the image result.
 */
@property (nonatomic, readonly) NSString *content;

/*
 Unique ID
 */
@property (nonatomic, readonly) NSString *imageId;

/*
 Supplies the height and width, in pixels, of the image.
 */
@property (nonatomic, readonly) CGSize size;

/*
 Supplies the URL of a image.

 */
@property (nonatomic, readonly) NSURL* url;

/*
 Supplies the URL of a thumbnail image.
 */
@property (nonatomic, readonly) NSURL* thumbURL;

/*
 Supplies the height and width, in pixels, of the image thumbnail.
 */
@property (nonatomic, assign) CGSize thumbSize;

/*
 Turns a Google Image JSON dictionary into a Cocoa Touch Object
 @param dict a json dictionary
 @return a cocoa touch representation of a google image
 */
+(GImage*)gImageFromDict:(NSDictionary*)dict;

@end
