//
//  EmotiKeyboard.m
//  emotikeyboard
//
//  Created by Vladimír Čalfa on 27/07/15.
//  Copyright (c) 2015 Vladimír Čalfa. All rights reserved.
//

#import "CMEmoticonsKeyboard.h"
#import "CMEmoticonsScanner.h"

@interface CMEmoticonsKeyboard () 

@property (nonatomic, weak) id<UITextViewDelegate> oldTextViewDelegate;

@end

@implementation CMEmoticonsKeyboard

- (id)init {

    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGRect frame;
    
    if(UIDeviceOrientationIsLandscape(orientation))
        frame = CGRectMake(0, 0, 480, 162);
    else
        frame = CGRectMake(0, 0, 320, 216);
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];

    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [self defaultInstance];
    });
    
    return _sharedObject;
}


+ (instancetype)defaultInstance {
    
    CMEmoticonsKeyboard *defaultInst = [[self alloc] init];
    
    defaultInst.emoticonFont = [UIFont fontWithName:@"cm-emoticons" size:19];
    defaultInst.textFont = [UIFont systemFontOfSize:17.0];
    
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
    
    [textView setInputView:self];
    self.oldTextViewDelegate = textView.delegate != self ? textView.delegate :nil;
    textView.delegate = self;
    
    _textView = textView;
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
    
    [self textView: self.textView shouldChangeTextInRange:NSMakeRange(idx-1, 1) replacementText:@""];
}

- (void)switchKeyboard:(UIButton*)sender {
    
    [self.textView setInputView:nil];
    [self.textView reloadInputViews];
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


#pragma mark - UITextViewDelegate 

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return self.oldTextViewDelegate != nil ? [self.oldTextViewDelegate textViewShouldBeginEditing:textView] : YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return self.oldTextViewDelegate != nil ? [self.oldTextViewDelegate textViewShouldEndEditing:textView] : YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.oldTextViewDelegate textViewDidBeginEditing:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.oldTextViewDelegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        return YES;
    }
    
    if (range.location == -1) {
        return NO;
    }
    
    if (text.length > 0) {
        NSAttributedString *s = [[NSAttributedString alloc] initWithString: text attributes:@{NSFontAttributeName: self.textFont}];
        
        NSMutableAttributedString *ms =[[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        
        UITextRange *selectedRange = [textView selectedTextRange];
        UITextPosition *startPos = selectedRange.start;
        NSInteger idx = [textView offsetFromPosition:textView.beginningOfDocument toPosition:startPos];
        NSInteger idx2 = [textView offsetFromPosition:textView.beginningOfDocument toPosition:textView.endOfDocument];
        UITextPosition *newPosition;
        
        if (range.length == 0 && range.location == idx2) {
            
            [ms appendAttributedString: s];
            
            textView.attributedText = ms;
        }
        else {
            [ms insertAttributedString:s atIndex:idx];
            newPosition = [textView positionFromPosition:selectedRange.start offset:1];
            UITextRange *newRange = [textView textRangeFromPosition:newPosition toPosition:newPosition];
            
            textView.attributedText = ms;
            [textView setSelectedTextRange:newRange];
            
        }
    } else {
        NSMutableAttributedString *ms =[[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [ms replaceCharactersInRange:range withString:text];
        
        UITextRange *selectedRange = [textView selectedTextRange];
        
        UITextPosition *newPosition = [textView positionFromPosition:selectedRange.start offset:-1];
        UITextRange *newRange = [textView textRangeFromPosition:newPosition toPosition:newPosition];
        
        textView.attributedText = ms;
        [textView setSelectedTextRange:newRange];
    }
    
    //NSAttributedString *as = [CMEmoticonsScanner attributedStringFromDataMessage:[textField.attributedText string] stringAttributes:@{}];
    //textField.attributedText = as;
    
    [self.oldTextViewDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.oldTextViewDelegate textViewDidChange:textView];
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self.oldTextViewDelegate textViewDidChangeSelection:textView];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return [self.oldTextViewDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    return [self.oldTextViewDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
}

@end
