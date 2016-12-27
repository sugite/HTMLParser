//
//  HTMLParser.m
//  Pods
//
//  Created by dengbo03 on 2016/12/27.
//
//

#import "HTMLParser.h"

@interface HTMLParser () {
    htmlDocPtr _docPtr;
}
@end

@implementation HTMLParser

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HTMLParser *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HTMLParser alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _docPtr = NULL;
    }
    return self;
}

- (NSAttributedString *)parseHTMLWithString:(NSString *)string error:(NSError **)error{
    if ([string length] > 0) {
        CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
        const char *enc = [(__bridge NSString*)cfencstr UTF8String];
        _docPtr = htmlReadDoc((xmlChar *)[string UTF8String], NULL, enc, HTML_PARSE_RECOVER | HTML_PARSE_NOERROR | HTML_PARSE_NOWARNING);
    } else {
        if (error) {
            *error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
        }
        return nil;
    }
    return [self parseNode:xmlDocGetRootElement(_docPtr) withAttribute:[NSMutableDictionary new]];
}

- (NSAttributedString *)parseNode:(xmlNode *)root withAttribute:(NSMutableDictionary *)attribute {
    NSMutableAttributedString *ret = [NSMutableAttributedString new];
    if (root) {
        if (strcmp((char *)root->name, "text") == 0) {
            [ret appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithUTF8String:(char *)root->content] attributes:attribute]];
        } else {
            [self transformNode:root toAttribute:attribute];
        }
        for (xmlNode *child = root->children; child; child = child->next) {
            [ret appendAttributedString:[self parseNode:child withAttribute:[attribute mutableCopy]]];
        }
    }
    return [ret copy];
}

- (void)transformNode:(xmlNode *)root toAttribute:(NSMutableDictionary *)attribute{
    if (strcmp((char *)root->name, "font") == 0) {
        for (xmlAttrPtr attr = root->properties; attr; attr = attr->next) {
            xmlChar *value = xmlNodeListGetString(root->doc, attr->children, 1);
            if (strcmp((char *)attr->name, "color") == 0) {
                attribute[NSForegroundColorAttributeName] = [self htmlColorToUIColor:value + 1];
            } else if (strcmp((char *)attr->name, "size") == 0) {
                attribute[NSFontAttributeName] = [UIFont systemFontOfSize:atof((char *)value)];
            } else if (strcmp((char *)attr->name, "bgcolor") == 0) {
                attribute[NSBackgroundColorAttributeName] = [self htmlColorToUIColor:value + 1];
            }
        }
    } else if (strcmp((char *)root->name, "strike") == 0) {
        attribute[NSStrikethroughStyleAttributeName] = @(NSUnderlineStyleSingle);
        attribute[NSStrikethroughColorAttributeName] = [UIColor blackColor];
    }
}

- (UIColor *)htmlColorToUIColor:(xmlChar *)htmlColorString {
    unsigned int colorInt = 0;
    [[NSScanner scannerWithString:[NSString stringWithFormat:@"0x%s", htmlColorString]] scanHexInt:&colorInt];
    return HEXCOLOR(colorInt);
}

@end
