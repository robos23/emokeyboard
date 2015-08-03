//
//  ViewController.m
//  emotikeyboard
//
//  Created by Vladimír Čalfa on 27/07/15.
//  Copyright (c) 2015 Vladimír Čalfa. All rights reserved.
//

#import "ViewController.h"
#import "CMEmoticonsKeyboard.h"
#import "CMEmoticonsScanner.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *emoButton;
@property (weak, nonatomic) IBOutlet UITextView *textViewEdit;
@property (weak, nonatomic) IBOutlet UITextView *textViewEdit2;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.keyboard = [EmotiKeyboard sharedInstance];
    [CMEmoticonsKeyboard sharedInstance].textFont = [UIFont fontWithName:@"AmericanTypewriter" size:17];
    [[CMEmoticonsKeyboard sharedInstance] setTextView: self.textViewEdit];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    gr.numberOfTapsRequired = 1;
    gr.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:gr];
}

- (void)tap:(UIGestureRecognizer*)recognizer {

    NSString *s = [CMEmoticonsScanner scannAtributedString:self.textViewEdit.attributedText];

    self.textView.text = s;
    
    self.textViewEdit2.attributedText = [CMEmoticonsScanner attributedStringFromDataMessage:s stringAttributes:@{}];
    
    NSLog(@"Convert: %@", s);
    
    //[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emoAction:(UIButton *)sender {
    
    UITextView *textInput = self.textViewEdit;
    
    if (textInput.inputView == nil ) {
        [[CMEmoticonsKeyboard sharedInstance] setTextView: textInput];
        [textInput becomeFirstResponder];
        [textInput reloadInputViews];
    } else {
        textInput.inputView = nil;
        [textInput reloadInputViews];
    }
}





@end
