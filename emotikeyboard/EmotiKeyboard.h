//
//  EmotiKeyboard.h
//  emotikeyboard
//
//  Created by Vladimír Čalfa on 27/07/15.
//  Copyright (c) 2015 Vladimír Čalfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotiKeyboard : UIView <UITextViewDelegate>


@property (weak, nonatomic) UITextView *textView;
@property (nonatomic, strong) UIFont *emoticonFont;
@property (nonatomic, weak) UIFont *normalFont;

+ (instancetype)defaultInstance;

@end
