//
//  HTMLParser.h
//  Pods
//
//  Created by dengbo03 on 2016/12/27.
//
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import <libxml/HTMLparser.h>
#define HEXCOLOR(hexValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]

@interface HTMLParser : NSObject

+ (instancetype)sharedInstance;

- (NSAttributedString *)parseHTMLWithString:(NSString *)string error:(NSError **)error;
//- (NSAttributedString *)parseHTMLWithData:(NSData *)data error:(NSError **)error;
//- (NSAttributedString *)parseHTMLWithContentsOfURL:(NSURL *)url error:(NSError **)error;

@end
