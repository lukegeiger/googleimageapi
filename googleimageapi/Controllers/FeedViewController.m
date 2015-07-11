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
//API
#import "GImageAPI.h"
//Networking
#import "AFNetworking.h"
//Helpers
#import <SDWebImage/UIImageView+WebCache.h>

@interface FeedViewController () <UICollectionViewDataSource,UICollectionViewDelegate,HistoryViewControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) Search *lastSearch;
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
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:10];
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
    
    GImage *currentImage = [self.photos objectAtIndex:indexPath.row];

    CGSize size = CGSizeMake(MIN(collectionView.frame.size.width/3, currentImage.thumbSize.width), currentImage.thumbSize.height);
    
    return size;
}

#pragma mark - Collection View Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GImage *currentImage = [self.photos objectAtIndex:indexPath.row];

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:currentImage.imageTitle
                                                                             message:currentImage.content
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* view = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[UIApplication sharedApplication]openURL:currentImage.url];
    }];
    
    [alertController addAction:view];
    
    UIAlertAction*save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        ImageCollectionViewCell *cell = (ImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        UIImageWriteToSavedPhotosAlbum(cell.imageView.image, nil, nil, nil);
    }];
    
    [alertController addAction:save];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){}];
    
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Collection View Data Source

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    GImage *image = [self.photos objectAtIndex:indexPath.row];

    [cell.imageView sd_setImageWithURL:image.url
                      placeholderImage:nil];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photos.count;
}

- (NSInteger)numberOfSections{
    
    return 1;
}


#pragma mark - Actions

-(void)searchButtonWasPressed{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Google Image Search"
                                                                             message:@"What would you like to see pictures of?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.placeholder = @"e.g Kanye West";
        textField.textAlignment = NSTextAlignmentCenter;
    }];
    
    UIAlertAction* search = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        UITextField *textField = alertController.textFields.firstObject;
        
        if (textField.text.length > 0) {
            [self.view endEditing:YES];

            Search *search = [Search searchForQuery:textField.text inContext:self.managedObjectContext];
            [self.managedObjectContext save:nil];
            
            [self.photos removeAllObjects];
            [self.collectionView reloadData];
            
            [[GImageAPI sharedAPI]reset];
            
            [self search:search];
        }
    }];
    
    [alertController addAction:search];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){
        [self.view endEditing:YES];
    }];
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

-(void)search:(Search*)search{
    
    self.lastSearch = search;
    
    if (!self.photos.count) {
        self.navigationItem.title = @"Loading...";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[GImageAPI sharedAPI]fetchPhotosForQuery:search.query shouldPage:YES onCompletion:^(NSArray*gimages,NSError*error){
        
        if (!error) {
            [self.photos addObjectsFromArray:gimages];
        }
        
        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //Search untill the whole screen is populated
        if (self.collectionView.frame.size.height > self.collectionView.contentSize.height) {
            [self search:self.lastSearch];
        }
        
        self.navigationItem.title = search.query;
    
    }];
}

#pragma mark - History View Controller Delegate

-(void)historyViewController:(HistoryViewController *)histVC didRedoSearch:(Search *)search{
    
    [self.photos removeAllObjects];
    [self.collectionView reloadData];
    
    search.lastSearchDate = [NSDate date];
    
    [self.managedObjectContext save:nil];
    
    [[GImageAPI sharedAPI]reset];
    [self search:search];
}

#pragma mark Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        if (self.lastSearch) {
            [self search:self.lastSearch];            
        }
    }
}

@end
