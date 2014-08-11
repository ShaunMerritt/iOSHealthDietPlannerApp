//
//  ImageLabelView.m
//  Elu
//
//  Created by Shaun Merritt on 6/30/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "ImageLabelView.h"

@interface ImageLabelView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ImageLabelView

#pragma mark - Object Lifecycle

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        [self constructImageView:image];
        [self constructLabel:text];
    }
    return self;
}

#pragma mark - Internal Methods

// Where imageview is laid out
- (void)constructImageView:(UIImage *)image {
    CGFloat topPadding = 10.f;
    CGRect frame = CGRectMake(floorf((CGRectGetWidth(self.bounds) - image.size.width)),
                              topPadding,
                              image.size.width,
                              image.size.height);
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.imageView.image = image;
    [self addSubview:self.imageView];
}

- (void)constructLabel:(NSString *)text {
    CGFloat height = 18.f;
    CGRect frame = CGRectMake(0,
                              CGRectGetMaxY(self.imageView.frame),
                              CGRectGetWidth(self.bounds),
                              height);
    self.label = [[UILabel alloc] initWithFrame:frame];
    self.label.text = text;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}

@end
