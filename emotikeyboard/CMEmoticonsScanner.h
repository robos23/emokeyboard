//
//  CMEmoticonsScanner.h
//  emotikeyboard
//
//  Created by Vladimír Čalfa on 28/07/15.
//  Copyright (c) 2015 Vladimír Čalfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMEmoticonsScanner : NSObject

+ (NSString*)scannAtributedString:(NSAttributedString*)inputString;
+ (NSAttributedString*)attributedStringFromDataMessage:(NSString*)string stringAttributes:(NSDictionary*)attributes;

@end
