//
//  FeedViewController.m
//  googleimageapi
//
//  Created by Luke Geiger on 7/10/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

//Models
#import "GImage.h"
//Views
#import "ImageCollectionViewCell.h"
#import "MBProgressHUD.h"
//Controllers
#import "FeedViewController.h"
//Networking
#import "AFNetworking.h"

@interface FeedViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *photos;
@end

@implementation FeedViewController

static NSString*cellIdentifier = @"cellIdentifier";

#pragma mark - Life Cycle

- (void)loadView {
    [super loadView];
    [self makeInterface];
}

#pragma mark - Appearance

-(void)makeInterface{
    
    self.navigationItem.title = @"Images";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonWasPressed)];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - Flow Layout Override

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    GImage *image = [_photos objectAtIndex:indexPath.row];
    return CGSizeZero;
}

#pragma mark - Collection View Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Collection View Data Source

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSections{
    return 1;
}

#pragma mark - GoogleImageAPI

-(void)fetchPhotosWithParams:(NSDictionary*)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    FeedViewController* __weak weakSelf = self;
    
    [manager GET:[self rootAPIString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
//        NSDictionary *responseDict = (NSDictionary*)responseObject;
//        NSDictionary *featuredDict = [responseDict objectForKey:@"response"];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    }];
}

-(NSString*)rootAPIString{
    return @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=fuzzy%20monkey";
}


#pragma mark - Actions

-(void)searchButtonWasPressed{
    
}

@end
