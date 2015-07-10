//
//  FeedViewController.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

//Models
#import "GImage.h"
#import "Search.h"
//Views
#import "ImageCollectionViewCell.h"
#import "MBProgressHUD.h"
//Controllers
#import "FeedViewController.h"
#import "HistoryViewController.h"
#import "LGSemiModalNavViewController.h"
//Networking
#import "AFNetworking.h"
//Helpers
#import <SDWebImage/UIImageView+WebCache.h>

@interface FeedViewController () <UICollectionViewDataSource,UICollectionViewDelegate,HistoryViewControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation FeedViewController

static NSString*cellIdentifier = @"cellIdentifier";

#pragma mark - Life Cycle

- (void)loadView {
    [super loadView];
    
    self.photos = [NSMutableArray new];
    [self makeInterface];

}

#pragma mark - Appearance

-(void)makeInterface{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Images";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonWasPressed)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(historyButtonWasPressed)];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - Flow Layout Override

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    GImage *image = [_photos objectAtIndex:indexPath.row];
    return image.thumbSize;
}

#pragma mark - Collection View Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Collection View Data Source

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    GImage *image = [_photos objectAtIndex:indexPath.row];

    [cell.imageView sd_setImageWithURL:image.url
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (NSInteger)numberOfSections{
    return 1;
}

#pragma mark - GoogleImageAPI

-(void)fetchPhotosWithParams:(NSDictionary*)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    FeedViewController* __weak weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager GET:[self rootAPIString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        NSDictionary *fullResponse = (NSDictionary*)responseObject;
        NSDictionary *responseData = [fullResponse objectForKey:@"responseData"];
        
        NSDictionary *cursor = [responseData objectForKey:@"cursor"];
        NSString *moreResultsString = [cursor objectForKey:@"moreResultsUrl"];
        
        NSDictionary *pageResults = [responseData objectForKey:@"results"];

        NSLog(@"cursor %@",cursor);
        NSLog(@"page results %@",pageResults);
        
        for (NSDictionary *dict in pageResults) {
            GImage *gimage = [GImage gImageFromDict:dict];
            [self.photos addObject:gimage];
        }
        
        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (moreResultsString) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self fetchPhotosWithParams:p];
            });
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    }];
}


-(NSString*)rootAPIString{
    return @"https://ajax.googleapis.com/ajax/services/search/images";
}


-(NSDictionary*)paramDictForSearchTerm:(NSString*)searchTerm{
    NSDictionary *params = @{@"q":searchTerm,
                             @"v":@"1.0"};
    return params;
}

#pragma mark - Actions

-(void)searchButtonWasPressed{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Google Image Search"
                                                                             message:@"What would you like to search for?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    }];
    
    UIAlertAction* search = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        UITextField *textField = alertController.textFields.firstObject;
        
        Search *search = [NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:self.managedObjectContext];
        search.query = textField.text;
        search.lastSearchDate = [NSDate date];
        
        [self.managedObjectContext save:nil];
        
        [self fetchPhotosWithParams:[self paramDictForSearchTerm:search.query]];
        
    }];
    [alertController addAction:search];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){}];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)historyButtonWasPressed{
    HistoryViewController *historyVC = [[HistoryViewController alloc]initWithManagedObjectContext:self.managedObjectContext];
    historyVC.delegate = self;
    
    //This is a cococa pod that I created myself :D
    LGSemiModalNavViewController *semiModal = [[LGSemiModalNavViewController alloc]initWithRootViewController:historyVC];
    semiModal.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 400);
    semiModal.backgroundShadeColor = [UIColor blackColor];
    semiModal.animationSpeed = 0.35f;
    semiModal.tapDismissEnabled = YES;
    semiModal.backgroundShadeAlpha = 0.4;
    semiModal.scaleTransform = CGAffineTransformMakeScale(.94, .94);
    
    [self presentViewController:semiModal animated:YES completion:nil];
}


#pragma mark - History View Controller Delegate

-(void)historyViewController:(HistoryViewController *)histVC didRedoSearch:(Search *)search{
    [self.photos removeAllObjects];
    search.lastSearchDate = [NSDate date];
    [self.managedObjectContext save:nil];
    [self fetchPhotosWithParams:[self paramDictForSearchTerm:search.query]];
}

@end
