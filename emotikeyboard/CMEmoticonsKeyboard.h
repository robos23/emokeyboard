//
//  EmotiKeyboard.h
//  emotikeyboard
//
//  Created by Vladimír Čalfa on 27/07/15.
//  Copyright (c) 2015 Vladimír Čalfa. All rights reserved.
//
//
//  How to use:
//
//  in - (void)viewDidLoad method
//
//  [CMEmoticonsKeyboard sharedInstance].textFont = [UIFont fontWithName:@"AmericanTypewriter" size:17];
//  [[CMEmoticonsKeyboard sharedInstance] setTextView: self.textViewEdit];
//
//
//  Sample keyboard button action
//
//    - (IBAction)emoAction:(UIButton *)sender {
//        
//        UITextView *textInput = self.textViewEdit;
//        
//        if (textInput.inputView == nil ) {
//            [[CMEmoticonsKeyboard sharedInstance] setTextView: textInput];
//            [textInput becomeFirstResponder];
//            [textInput reloadInputViews];
//        } else {
//            textInput.inputView = nil;
//            [textInput reloadInputViews];
//        }
//    }
//
//
#import <UIKit/UIKit.h>

@interface CMEmoticonsKeyboard : UIView <UITextViewDelegate>


@property (weak, nonatomic) UITextView *textView;
@property (nonatomic, strong) UIFont *emoticonFont;
@property (nonatomic, strong) UIFont *textFont;

+ (instancetype)defaultInstance;
+ (instancetype)sharedInstance;

@end
