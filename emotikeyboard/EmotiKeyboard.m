//
//  EmotiKeyboard.m
//  emotikeyboard
//
//  Created by Vladimír Čalfa on 27/07/15.
//  Copyright (c) 2015 Vladimír Čalfa. All rights reserved.
//

#import "EmotiKeyboard.h"
#import <QuartzCore/QuartzCore.h>
#import "CMEmoticonsScanner.h"

@interface EmotiKeyboard () 




@end

@implementation EmotiKeyboard

- (id)init {

    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGRect frame;
    
    if(UIDeviceOrientationIsLandscape(orientation))
        frame = CGRectMake(0, 0, 480, 162);
    else
        frame = CGRectMake(0, 0, 320, 216);
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];

    NSDictionary *d = @{
      
      @(0xe600): @":-)",
      @(0xe601): @":-D",
      @(0xe602): @"^^",
      @(0xe603): @"^D",
      @(0xe604): @":*",
      @(0xe605): @":P",
      
      @(0xe606): @";)",
      @(0xe607): @";D",
      @(0xe608): @":rofl:",
      @(0xe609): @":\">",
      @(0xe60a): @"8-)",
      @(0xe60b): @"8|",
      
      @(0xe60c): @">(",
      @(0xe60d): @"°-|",
      @(0xe60e): @"D-:",
      @(0xe60f): @":o",
      @(0xe610): @"X-|",
      @(0xe611): @":x",
      
      @(0xe612): @":|",
      @(0xe613): @":s",
      @(0xe614): @":(",
      @(0xe615): @">:(",
      @(0xe616): @"D:(",
      @(0xe617): @":'("
      
      };
    
    NSDictionary *d2 = @{
                        
                        @":-)"  : @(0xe600),
                        @":-D"  : @(0xe601),
                        @"^^"   : @(0xe602),
                        @"^D"   : @(0xe603),
                        @":*"   : @(0xe604),
                        @":P"   : @(0xe605),
                        
                        @";)"   : @(0xe606),
                        @";D"   : @(0xe607),
                        @":rofl:": @(0xe608),
                        @":\">" : @(0xe609),
                        @"8-)"  : @(0xe60a),
                        @"8|"   : @(0xe60b),
                        
                        @">("   : @(0xe60c),
                        @"°-|"  : @(0xe60d),
                        @"D-:"  : @(0xe60e),
                        @":o"   : @(0xe60f),
                        @"X-|"  : @(0xe610),
                        @":x"   : @(0xe611),
                        
                        @":|"   : @(0xe612),
                        @":s"   : @(0xe613),
                        @":("   : @(0xe614),
                        @">:("  : @(0xe615),
                        @"D:("  : @(0xe616),
                        @":'("  : @(0xe617)
                        
                        };
    return self;
}

+ (instancetype)defaultInstance {
    
    EmotiKeyboard *defaultInst = [[self alloc] init];
    
    defaultInst.emoticonFont = [UIFont fontWithName:@"cm-emoticons" size:19];
    
    NSArray *buttonTitles1 = @[ @"\ue600", @"\ue601", @"\ue602", @"\ue603", @"\ue604", @"\ue605"];
    NSArray *buttonTitles2 = @[ @"\ue606", @"\ue607", @"\ue608", @"\ue609", @"\ue60a", @"\ue60b"];
    NSArray *buttonTitles3 = @[ @"\ue60c", @"\ue60d", @"\ue60e", @"\ue60f", @"\ue610", @"\ue611"];
    NSArray *buttonTitles4 = @[ @"\ue612", @"\ue613", @"\ue614", @"\ue615", @"\ue616", @"\ue617"];
    
    UIView *row1 = [defaultInst createRowOfButtons:buttonTitles1];
    UIView *row2 = [defaultInst createRowOfButtons:buttonTitles2];
    UIView *row3 = [defaultInst createRowOfButtons:buttonTitles3];
    UIView *row4 = [defaultInst createRowOfButtons:buttonTitles4];
    UIView *row5 = [defaultInst createSystemButtons];
    
    
    [defaultInst addSubview:row1];
    [defaultInst addSubview:row2];
    [defaultInst addSubview:row3];
    [defaultInst addSubview:row4];
    [defaultInst addSubview:row5];
    
    
    [defaultInst addConstraintsToInputView:defaultInst rowViews:@[row1, row2, row3, row4, row5]];
    
    return defaultInst;
}

- (void)setTextView:(UITextView *)textView {
    
    [(UITextView *)textView setInputView:self];

    _textView = textView;
}

- (BOOL)textView:(UITextView *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {

    
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    
    if (range.location == -1) {
        return NO;
    }
    
    if (string.length > 0) {
         NSAttributedString *s = [[NSAttributedString alloc] initWithString: string attributes:@{NSFontAttributeName: self.normalFont}];
        
        NSMutableAttributedString *ms =[[NSMutableAttributedString alloc] initWithAttributedString:textField.attributedText];
        
        UITextRange *selectedRange = [textField selectedTextRange];
        UITextPosition *startPos = selectedRange.start;
        NSInteger idx = [textField offsetFromPosition:textField.beginningOfDocument toPosition:startPos];
        NSInteger idx2 = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument];
        UITextPosition *newPosition;
        
        if (range.length == 0 && range.location == idx2) {
        
            [ms appendAttributedString: s];

            textField.attributedText = ms;
        }
        else {
            [ms insertAttributedString:s atIndex:idx];
            newPosition = [textField positionFromPosition:selectedRange.start offset:1];
            UITextRange *newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
            
            textField.attributedText = ms;
            [textField setSelectedTextRange:newRange];

        }
        
    } else {
        NSMutableAttributedString *ms =[[NSMutableAttributedString alloc] initWithAttributedString:textField.attributedText];
        [ms replaceCharactersInRange:range withString:string];
        
        UITextRange *selectedRange = [textField selectedTextRange];
      
        UITextPosition *newPosition = [textField positionFromPosition:selectedRange.start offset:-1];
        UITextRange *newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
        
        textField.attributedText = ms;
        [textField setSelectedTextRange:newRange];
    }
    
    //NSAttributedString *as = [CMEmoticonsScanner attributedStringFromDataMessage:[textField.attributedText string] stringAttributes:@{}];
    //textField.attributedText = as;
    
    return NO;
}

- (IBAction)keyPressed:(UIButton *)sender {
    
    NSString *character = [sender titleForState:UIControlStateNormal];
    

    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    NSAttributedString *s = [[NSAttributedString alloc] initWithString: character attributes:@{NSFontAttributeName: self.emoticonFont}];
    
    UITextRange *selectedRange = [self.textView selectedTextRange];
    
    UITextPosition *startPos = selectedRange.start;
    NSInteger idx = [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:startPos];
    //UITextPosition *newPosition;
    
    if (idx == ms.length) {
        
        [ms appendAttributedString: s];
        self.textView.attributedText = ms;
    } else {
        
        UITextPosition *startPos = selectedRange.start;
        NSInteger idx = [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:startPos];
        
        [ms insertAttributedString:s atIndex: idx];
        
        UITextPosition *newPosition = [self.textView positionFromPosition:selectedRange.start offset:1];
        UITextRange *newRange = [self.textView textRangeFromPosition:newPosition toPosition:newPosition];
        
        self.textView.attributedText = ms;
        [self.textView setSelectedTextRange:newRange];
    }
}

- (void)backspace:(UIButton*)sender {
    
    UITextRange *selectedRange = [self.textView selectedTextRange];
    UITextPosition *startPos = selectedRange.start;
    NSInteger idx = [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:startPos];
    
   // [self textField: (UITextField*)self.textView shouldChangeCharactersInRange:NSMakeRange(idx-1, 1) replacementString:@""];
    
    [self textView: (UITextView*)self.textView shouldChangeTextInRange:NSMakeRange(idx-1, 1) replacementText:@""];
}

- (void)switchKeyboard:(UIButton*)sender {
    
    [(UITextField *)self.textView setInputView:nil];
    [(UITextField *)self.textView reloadInputViews];
}

#pragma mark - Methods that create custom keyboard UI

- (UIButton*)createButtonWithTitle:(NSString*)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 4.0;
    
    
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    button.titleLabel.font = self.emoticonFont;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView*)createRowOfButtons:(NSArray*)buttonTitles {
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    UIView *keyboardRowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    keyboardRowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (NSString *buttonTitle in buttonTitles) {
        
        UIButton *button = [self createButtonWithTitle:buttonTitle];
        [buttons addObject:button];
        [keyboardRowView addSubview:button];
    }
    
    [self addIndividualButtonConstraints:buttons mainView:keyboardRowView];
    
    return keyboardRowView;
}

- (UIView*)createSystemButtons {
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    UIView *keyboardRowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    keyboardRowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // switch keyboard button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 4.0;
    [button setTitle: @"ABC" forState:UIControlStateNormal];
    [button sizeToFit];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(switchKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    [keyboardRowView addSubview:button];
    
    // backspace button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 4.0;
    [button setTitle: @"<" forState:UIControlStateNormal];
    [button sizeToFit];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(backspace:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    [keyboardRowView addSubview:button];
    
    [self systemButtonConstraints:buttons mainView:keyboardRowView];
    
    return keyboardRowView;
}

#pragma mark - Layout constraints methods

- (void)addIndividualButtonConstraints:(NSArray*)buttons mainView:(UIView*)mainView {
    
    NSInteger index = 0;
    for (UIButton *button in buttons) {
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTop multiplier:1.0 constant:1];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-1];
        NSLayoutConstraint *rightConstraint;
        
        if (index == buttons.count - 1) {
            rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-1];
        } else {
            UIButton *nextButton = [buttons objectAtIndex:index+1];
            rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:nextButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-1];
        }
        
        NSLayoutConstraint *leftConstraint;
        
        
        if (index == 0) {
            
            leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:1];
        } else {
            
            UIButton *prevtButton = [buttons objectAtIndex:index-1];
            leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:prevtButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:1];
            
            UIButton *firstButton = [buttons objectAtIndex:0];
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
            
            [mainView addConstraint:widthConstraint];
            
        }
        
        [mainView addConstraints:@[topConstraint,bottomConstraint,rightConstraint,leftConstraint]];
        index++;
    }
}

- (void)addConstraintsToInputView:(UIView*)inputView rowViews:(NSArray*)rowViews {
    
    NSInteger index = 0;
    for (UIView *rowView in rowViews) {
        
        NSLayoutConstraint *rightSideConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:inputView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15];
        
        
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:inputView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
        
        [inputView addConstraints:@[leftConstraint, rightSideConstraint]];
        
        NSLayoutConstraint *topConstraint;
        
        if (index == 0) {
            topConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:inputView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15];
        } else {
            
            UIView *prevRow = [rowViews objectAtIndex:index - 1];
            
            topConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:prevRow attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            
            UIView *firstRow = [rowViews objectAtIndex:0];
            
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:firstRow attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rowView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
            
            [inputView addConstraint:heightConstraint];
        }
        [inputView addConstraint:topConstraint];
        
        
        
        NSLayoutConstraint *bottomConstraint;
        
        if (index == rowViews.count - 1) {
            bottomConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:inputView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        } else {
            
            UIView *nextRow = [rowViews objectAtIndex:index+1];
            
            bottomConstraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:nextRow attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        }
        
        [inputView addConstraint:bottomConstraint];
        
        
        index++;
    }
}

- (void)systemButtonConstraints:(NSArray*)buttons mainView:(UIView*)mainView {
    
    NSAssert(buttons.count == 2, @"");
    
    NSInteger index = 0;
    for (UIButton *button in buttons) {
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTop multiplier:1.0 constant:1];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-1];
        
        NSLayoutConstraint *sideConstraint;
        
        if (index == 0) {
            
            sideConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:1];
        } else if (index == 1) {
            sideConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-1];
        }
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem: button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1.0 constant:80];
        
        
        [mainView addConstraints:@[topConstraint,bottomConstraint,sideConstraint,widthConstraint]];
        index++;
    }
}




@end
