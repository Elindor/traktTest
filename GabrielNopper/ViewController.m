//
//  ViewController.m
//  GabrielNopper
//
//  Created by dev on 27/01/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ViewController.h"
#import "Series.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchSeriesWithCompletionBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchTerm = self.searches[indexPath.section]; Series *photo =
    self.searchResults[searchTerm][indexPath.row];
    // 2
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    retval.height += 35; retval.width += 35; return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}



#pragma mark - Datasource
//// 1
//- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
//    NSString *searchTerm = self.searches[section];
//    return [self.searchResults[searchTerm] count];
//}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.searches count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SeriesCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    cell.imageView = self.searchResults[searchTerm]
    [indexPath.row];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/




- (void)searchSeriesWithCompletionBlock:(traktCompletionBlock) completionBlock
{
    
    NSString *searchURL = getTrendingKey;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSURL *URL = [NSURL URLWithString:@"https://api-v2launch.trakt.tv/shows/played/all"];
        
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
                                              UIAlertView *alert = [[UIAlertView alloc]
                                                                    initWithTitle:@"Failure"
                                                                    message:@"The app could not reach it's online database. Please  try again later."
                                                                    delegate:nil
                                                                    cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                                                    otherButtonTitles:nil];
                                              
                                                                    [alert show];
                                              return;
                                          }
                                          
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                              NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                          }
                                          
                                          NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"Response Body:\n%@\n", body);
                                          NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&error];

                                          Series *series = [[Series alloc] init];
                                            series.name = [body[@"farm"] intValue];
                                      }];
        [task resume];
        
//        NSError *error = nil;
//        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
//                                                                encoding:NSUTF8StringEncoding
//                                                                   error:&error];
//        if (error != nil) {
//            completionBlock(term,nil,error);
//        }
//        else
//        {
//            // Parse the JSON Response
//            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                              options:kNilOptions
//                                                                                error:&error];
//            if(error != nil)
//            {
//                completionBlock(term,nil,error);
//            }
//            else
//            {
//                NSString * status = searchResultsDict[@"stat"];
//                if ([status isEqualToString:@"fail"]) {
//                    NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
//                    completionBlock(term, nil, error);
//                } else {
//                    
//                    NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
//                    NSMutableArray *flickrPhotos = [@[] mutableCopy];
//                    for(NSMutableDictionary *objPhoto in objPhotos)
//                    {
//                        
//                        Series *photo = [[Series alloc] init];
//                        photo.farm = [objPhoto[@"farm"] intValue];
//                        photo.server = [objPhoto[@"server"] intValue];
//                        photo.secret = objPhoto[@"secret"];
//                        photo.photoID = [objPhoto[@"id"] longLongValue];
//                        photo.name = objPhoto[@"title"];
//                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
//                                                                  options:0
//                                                                    error:&error];
//                        UIImage *image = [UIImage imageWithData:imageData];
//                        photo.thumbnail = image;
//                        
//                        [flickrPhotos addObject:photo];
//                    }
//                    
//                    completionBlock(term,flickrPhotos,nil);
//                }
//            }
//        }
    });
}

+ (void)loadImageForPhoto:(Series *)series thumbnail:(BOOL)thumbnail completionBlock:(traktImageCompletionBlock) completionBlock
{
    
    NSString *size = thumbnail ? @"m" : @"b";
    
    NSString *searchURL = getTrendingKey;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        if(error)
        {
            completionBlock(nil,error);
        }
        else
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if([size isEqualToString:@"m"])
            {
                series.thumbnail = image;
            }
            else
            {
                series.largeImage = image;
            }
            completionBlock(image,nil);
        }
        
    });
}









@end
