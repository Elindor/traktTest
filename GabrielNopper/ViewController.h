//
//  ViewController.h
//  GabrielNopper
//
//  Created by dev on 27/01/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"


#define tracktClientID @"0420bb09c458ec8a5373ab177597b082eb392dd906cc1eb00db7eef1fd62f4b1"
#define tracktClientSecret @"ed0d8cbbde46916fe5c17894939d749c599a9d5fa10447dfa7a085aad300f2d0"
#define tracktPinURL @"https://trakt.tv/pin/8030"

#define getTrendingKey @"https://api-v2launch.trakt.tv/shows/watched/all"

typedef void (^traktCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^traktImageCompletionBlock)(UIImage *photoImage, NSError *error);


@interface ViewController : UIViewController
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) NSMutableDictionary *searchResults;



@end

