//
//  IGViewController.m
//  InstaGallery
//
//  Created by Vincent Tourraine on 1/6/13.
//  Copyright (c) 2013 Vincent Tourraine. All rights reserved.
//

#import "IGViewController.h"
#import "AFNetworking.h"

@implementation IGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.URLs = [NSMutableArray array];
    
    // Utilisez le client id Twitter pour votre application (https://dev.twitter.com)
    NSString *clientId = nil;
    if (!clientId)
        NSLog(@"[!] Vous devez utiliser un client id pour vous connecter à l’API Twitter");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/popular?client_id=%@", clientId]]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSON) {
        
        for (NSDictionary *data in JSON[@"data"]) {
            NSString *URL = data[@"images"][@"standard_resolution"][@"url"];
            [self.URLs addObject:URL];
        }
        [self.collectionView reloadData];
    } failure:nil];
    [operation start];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.URLs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    UIImageView *imageView;
    for (UIView *subview in cell.contentView.subviews)
    {
        if ([subview isMemberOfClass:[UIImageView class]])
        {
            imageView = (UIImageView *)subview;
            break;
        }
    }
    
    if (!imageView)
    {
        imageView= [[UIImageView alloc] initWithFrame:cell.bounds];
        [cell.contentView addSubview:imageView];
    }

    [imageView setImageWithURL:[NSURL URLWithString:self.URLs[indexPath.row]] placeholderImage:nil];
    
    return cell;
}

@end
