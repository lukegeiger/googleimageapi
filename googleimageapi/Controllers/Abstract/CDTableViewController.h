//
//  CDTableViewController.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
