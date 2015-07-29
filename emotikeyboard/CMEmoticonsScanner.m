//
//  CMEmoticonsScanner.m
//  emotikeyboard
//
//  Created by Vladimír Čalfa on 28/07/15.
//  Copyright (c) 2015 Vladimír Čalfa. All rights reserved.
//

#import "CMEmoticonsScanner.h"
#include <UIKit/UIKit.h>

static NSDictionary *emoticonsSequence = nil;
static NSCharacterSet *emotiCharacterSet = nil;
static UIFont *emoticonFont = nil;
static NSArray *keys = nil;

@implementation CMEmoticonsScanner

+(void) initialize
{
    if (! emoticonsSequence) {
        emoticonsSequence = @{
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
                              
                              @(0xe615): @">:(",
                              @(0xe616): @"D:(",
                              @(0xe617): @":'(",
                              @(0xe614): @":("
        
                              };
    }
    
    if (!keys) {
        keys = @[@(0xe600),
                 @(0xe601),
                 @(0xe602),
                 @(0xe603),
                 @(0xe604),
                 @(0xe605),
                 
                 @(0xe606),
                 @(0xe607),
                 @(0xe608),
                 @(0xe609),
                 @(0xe60a),
                 @(0xe60b),
                 
                 @(0xe60c),
                 @(0xe60d),
                 @(0xe60e),
                 @(0xe60f),
                 @(0xe610),
                 @(0xe611),
                 
                 @(0xe612),
                 @(0xe613),
                 
                 @(0xe615),
                 @(0xe616),
                 @(0xe617),
                 @(0xe614)];
    }

    if (!emotiCharacterSet) {
        emotiCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\ue600\ue601\ue602\ue603\ue604\ue605\ue606\ue607\ue608\ue609\ue60a\ue60b\ue60c\ue60d\ue60e\ue60f\ue610\ue611\ue612\ue613\ue615\ue616\ue617\ue614"];
    }
    
    if (!emoticonFont) {
        emoticonFont = [UIFont fontWithName:@"cm-emoticons" size:19];
    }
    
}

+ (NSString*)scannAtributedString:(NSAttributedString*)inputString {
    
    
    NSMutableString *s = [[NSMutableString alloc] initWithString:[inputString string]];
    
    NSRange r = [s rangeOfCharacterFromSet:emotiCharacterSet];
    
    while (r.location != NSNotFound) {
        
        NSString *substring = [s substringWithRange:r];
        NSString *replacement = [emoticonsSequence objectForKey:@([substring characterAtIndex:0])];
        [s replaceCharactersInRange:r withString:replacement];
        
        r = [s rangeOfCharacterFromSet:emotiCharacterSet];
    }
    
    return [NSString stringWithString:s];
}


+ (NSAttributedString*)attributedStringFromDataMessage:(NSString*)string stringAttributes:(NSDictionary*)attributes {
    
    NSMutableAttributedString *convertTo = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *emoAtributes = @{NSFontAttributeName: emoticonFont};
    
    [keys enumerateObjectsUsingBlock:^(NSNumber *key, NSUInteger idx, BOOL *stop) {
        NSString *obj = [emoticonsSequence objectForKey:key];
        
        NSRange r = [convertTo.mutableString rangeOfString:obj];
        
        while (r.location != NSNotFound) {
            
            NSAttributedString *replace = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%C", (unichar)key.longValue]  attributes: emoAtributes];
            
            [convertTo replaceCharactersInRange:r withAttributedString:replace];
            
            r = [convertTo.mutableString rangeOfString:obj];
        }
    }];
    
//    [emoticonsSequence enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL *stop) {
//        NSRange r = [convertTo.mutableString rangeOfString:obj];
//        
//        while (r.location != NSNotFound) {
//            
//            NSAttributedString *replace = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%C", (unichar)key.longValue]  attributes: emoAtributes];
//            
//            [convertTo replaceCharactersInRange:r withAttributedString:replace];
//            
//            r = [convertTo.mutableString rangeOfString:obj];
//        }
//    }];
    
    return convertTo;
}



@end
