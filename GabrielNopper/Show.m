//
//  Show.m
//  GabrielNopper
//
//  Created by Gabriel Nopper on 28/01/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "Show.h"

@implementation Show

-(id) initWithName:(NSString*) name andImage:(UIImage*) image{
    self = [super init];
    
    if(self){
        _showName = name;
        _showImage = image;
    }
    
    
    return self;
}

@end
