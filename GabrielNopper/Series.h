//
//  Series.h
//  GabrielNopper
//
//  Created by dev on 27/01/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Series : NSObject

@property (nonatomic,strong) UIImage *thumbnail;
@property (nonatomic,strong) UIImage *largeImage;
// Lookup info
@property(nonatomic) long long photoID;
@property(nonatomic) NSInteger farm;
@property(nonatomic) NSInteger server;
@property(nonatomic,strong) NSString *secret;
@property NSString *name;

@end
