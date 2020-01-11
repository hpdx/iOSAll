//
//  PhotoCell.m
//  01.OC-UICollectionView
//
//  Created by android_ls on 2020/1/11.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

+ (NSString *)ID {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
        _photoView.center = self.contentView.center;
        [self.contentView addSubview:_photoView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _photoView.image = image;
}

@end
