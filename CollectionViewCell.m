//
//  CollectionViewCell.m
//  GabrielNopper
//
//  Created by dev on 27/01/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) setImage:(UIImage *)image {
    
    if(_imageView.image != image) {
        _imageView.image = image;
    }
    self.imageView.image = image;
}
@end
