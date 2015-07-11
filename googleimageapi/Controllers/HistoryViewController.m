//
//  HistoryViewController.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

//Frameworks
#include <CoreData/CoreData.h>
//Models
#import "Search.h"
//View Controllers
#import "HistoryViewController.h"
//Helpers
#import "UIFont+AppFonts.h"

@interface HistoryViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation HistoryViewController

static NSString *cellIdentifier = @"CellIdentifier";

#pragma mark - Fetched Results Controller

-(NSFetchedResultsController*)fetchedResultsController{
    
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Search"];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastSearchDate" ascending:NO]]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        [_fetchedResultsController setDelegate:self];
        
        NSError *error = nil;
        [_fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        
    }
    return _fetchedResultsController;
}

#pragma mark - Life Cycle

- (void)loadView {
    
    [super loadView];
    
    self.navigationItem.title = @"Search History";
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonWasPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearSearchHistoryWasPressed)];
}

#pragma mark - Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.fetchedResultsController.fetchedObjects.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Search *search = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = search.query;
    cell.textLabel.font = [UIFont appFontOfSize:15];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Search *search = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:search.query
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *redo = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        
        if ([self.delegate respondsToSelector:@selector(historyViewController:didRedoSearch:)]) {
            [self.delegate historyViewController:self didRedoSearch:search];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    [alertController addAction:redo];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Search" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action){
        
        [self.managedObjectContext deleteObject:search];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error");
        }
        
    }];
    
    [alertController addAction:delete];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){}];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
    
        Search *search = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        
        [self.managedObjectContext deleteObject:search];
        
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Error");
            
        }
    }
}

#pragma mark - NSFetchedResultsController Delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

#pragma mark - Actions

-(void)cancelButtonWasPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clearSearchHistoryWasPressed{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear History"
                                                                             message:@"Are you sure you want to clear your history?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *clear = [UIAlertAction actionWithTitle:@"Clear History" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action){
        
        for (Search *search in self.fetchedResultsController.fetchedObjects) {
            [self.managedObjectContext deleteObject:search];
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Error");
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(historyViewController:didRedoSearch:)]) {
            [self.delegate historyViewControllerDidClearHistory:self];
        }
        
    }];
    
    [alertController addAction:clear];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){}];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
