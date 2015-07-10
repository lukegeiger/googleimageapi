//
//  ImageCollectionViewCell.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import "ImageCollectionViewCell.h"


@implementation ImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
