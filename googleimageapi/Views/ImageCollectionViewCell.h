//
//  ImageCollectionViewCell.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

/*
 An ImageView that dynamically resiszes itself to however big the cell is.
 */
@property (nonatomic, strong) UIImageView *imageView;

@end
