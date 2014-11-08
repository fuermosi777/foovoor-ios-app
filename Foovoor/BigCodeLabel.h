//
//  BigCodeLabel.h
//  Foovoor
//
//  Created by Hao Liu on 10/19/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigCodeLabel : UILabel

@property (strong, nonatomic) NSString *code;

- (id) initWithCode: (NSString *)code;

@end
