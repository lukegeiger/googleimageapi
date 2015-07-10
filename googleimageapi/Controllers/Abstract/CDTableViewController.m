//
//  CDTableViewController.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import "CDTableViewController.h"

@interface CDTableViewController ()

@end

@implementation CDTableViewController

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext{
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

@end
