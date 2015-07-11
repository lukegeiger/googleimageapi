//
//  HistoryViewController.h
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

#import "CDViewController.h"
#import "CDTableViewController.h"

@protocol HistoryViewControllerDelegate;

@interface HistoryViewController : CDTableViewController

@property (nonatomic,weak) NSObject<HistoryViewControllerDelegate>* delegate;

@end

@protocol HistoryViewControllerDelegate <NSObject>
@optional
-(void)historyViewController:(HistoryViewController*)histVC didRedoSearch:(Search*)search;
@end