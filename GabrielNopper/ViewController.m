//
//  ViewController.m
//  GabrielNopper
//
//  Created by dev on 27/01/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property NSMutableArray *itemList;

@end

@implementation ViewController

#pragma mark - VC basics

- (void)viewDidLoad {
    [super viewDidLoad];
    // Basic data setup
    _itemList = [[NSMutableArray alloc] init];
    
    // Collection view setup
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:@"CollectCell"];
    

    // Begin first search
    [self searchSeries];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Collection View Management

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_itemList count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CollectCell" forIndexPath:indexPath];
    
    if([_itemList count]){
        
        Show *show = (Show *) self.itemList [indexPath.row];
        cell.imageView.image = show.showImage;
        cell.label.text = show.showName;
    }
    
    return cell;
}


#pragma mark - Search engine

- (void)searchSeries
{
    
    NSString *searchURL = getTrendingKey;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSURL *URL = [NSURL URLWithString:searchURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"GET"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"2" forHTTPHeaderField:@"trakt-api-version"];
        [request setValue:tracktClientID forHTTPHeaderField:@"trakt-api-key"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          if (error) {
                                              
                                              UIAlertController* alertCtrl = [UIAlertController
                                                                              alertControllerWithTitle: @"Failure"
                                                                              message:@"The app could not reach it's online database. Please  try again later."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                                                                    handler:nil];
                                              [alertCtrl addAction:defaultAction];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^ {
                                                  [self presentViewController:alertCtrl animated:YES completion:nil];
                                              });

                                             
                                              return;
                                          }
                                          
                                          NSMutableArray *acquiredResults = [[NSMutableArray alloc] init];
                                          NSMutableArray *treatedResults = [[NSMutableArray alloc] init];
                                          acquiredResults = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                          
                                          
                                          for (NSDictionary *dict in acquiredResults) {
                                              
                                              NSURL *imageUrl = [NSURL URLWithString:[[[dict valueForKey:@"images"] valueForKey:@"poster"] valueForKey:@"thumb"]];
                                              UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                                              Show *show = [[Show alloc] initWithName:[dict valueForKey:@"title"] andImage:image];
                                              [treatedResults addObject:show];
                                              
                                          }
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              _itemList = treatedResults;
                                              [self.collectionView reloadData];
                                          });
                             
                                      }];
                [task resume];
            });
}


@end
