//
//  Show.h
//  GabrielNopper
//
//  Created by Gabriel Nopper on 28/01/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Show : NSObject

@property NSString *showName;
@property UIImage *showImage;


-(id) initWithName:(NSString*) name andImage:(UIImage*) image;

@end
