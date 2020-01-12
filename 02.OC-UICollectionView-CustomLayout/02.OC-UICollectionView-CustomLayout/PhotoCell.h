//
//  PhotoCell.h
//  02.OC-UICollectionView-CustomLayout
//
//  Created by android_ls on 2020/1/12.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCell : UICollectionViewCell
{
    UIImageView *_photoView;
}

@property (nonatomic, strong) UIImage *image;

+ (NSString *)ID;

@end

NS_ASSUME_NONNULL_END
