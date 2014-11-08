//
//  DateScrollViewButton.h
//  Foovoor
//
//  Created by Hao Liu on 10/23/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateScrollViewButton : UIButton

@property BOOL isSelected;

- (void)selectButton;
- (void)resetButton;
@end
