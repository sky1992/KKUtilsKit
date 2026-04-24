#import "KKToolUtils.h"

@implementation KKToolUtils

#pragma mark - Bank Card Formatting

+ (NSString *)format_card:(NSString *)num {
    NSString *cleaned = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (cleaned.length == 0) return @"";
    
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < cleaned.length; i++) {
        if (i > 0 && i % 4 == 0) {
            [result appendString:@" "];
        }
        [result appendFormat:@"%C", [cleaned characterAtIndex:i]];
    }
    return result;
}

#pragma mark - Indian Amount Formatting

+ (NSString *)format_amount:(NSString *)amount {
    double doubleValue = [amount doubleValue];
    NSInteger intValue = (NSInteger)doubleValue;
    
    if (intValue == 0) return @"0";
    
    NSString *numberString = [NSString stringWithFormat:@"%ld", (long)ABS(intValue)];
    NSInteger length = numberString.length;
    
    if (length <= 3) {
        return [NSString stringWithFormat:@"%ld", (long)intValue];
    }
    
    NSMutableString *result = [NSMutableString string];
    NSInteger index = length - 1;
    NSInteger groupCount = 0;
    
    while (index >= 0) {
        [result insertString:[NSString stringWithFormat:@"%C", [numberString characterAtIndex:index]] atIndex:0];
        groupCount++;
        
        if (index > 0) {
            if (groupCount == 3) {
                [result insertString:@"," atIndex:0];
                groupCount = 0;
            } else if (groupCount == 2 && index > 1) {
                [result insertString:@"," atIndex:0];
                groupCount = 0;
            }
        }
        index--;
    }
    
    if (intValue < 0) {
        [result insertString:@"-" atIndex:0];
    }
    return result;
}

#pragma mark - Hex Color Parsing

+ (UIColor *)color_from_hex:(NSString *)hexString {
    NSString *hex = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hex = [hex uppercaseString];
    
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    CGFloat alpha = 1.0;
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    
    NSUInteger length = hex.length;
    
    if (length == 3) {
        NSString *r = [NSString stringWithFormat:@"%C%C", [hex characterAtIndex:0], [hex characterAtIndex:0]];
        NSString *g = [NSString stringWithFormat:@"%C%C", [hex characterAtIndex:1], [hex characterAtIndex:1]];
        NSString *b = [NSString stringWithFormat:@"%C%C", [hex characterAtIndex:2], [hex characterAtIndex:2]];
        red = (CGFloat)strtol([r UTF8String], NULL, 16) / 255.0;
        green = (CGFloat)strtol([g UTF8String], NULL, 16) / 255.0;
        blue = (CGFloat)strtol([b UTF8String], NULL, 16) / 255.0;
    } else if (length == 6) {
        NSString *r = [hex substringWithRange:NSMakeRange(0, 2)];
        NSString *g = [hex substringWithRange:NSMakeRange(2, 2)];
        NSString *b = [hex substringWithRange:NSMakeRange(4, 2)];
        red = (CGFloat)strtol([r UTF8String], NULL, 16) / 255.0;
        green = (CGFloat)strtol([g UTF8String], NULL, 16) / 255.0;
        blue = (CGFloat)strtol([b UTF8String], NULL, 16) / 255.0;
    } else if (length == 8) {
        NSString *a = [hex substringWithRange:NSMakeRange(0, 2)];
        NSString *r = [hex substringWithRange:NSMakeRange(2, 2)];
        NSString *g = [hex substringWithRange:NSMakeRange(4, 2)];
        NSString *b = [hex substringWithRange:NSMakeRange(6, 2)];
        alpha = (CGFloat)strtol([a UTF8String], NULL, 16) / 255.0;
        red = (CGFloat)strtol([r UTF8String], NULL, 16) / 255.0;
        green = (CGFloat)strtol([g UTF8String], NULL, 16) / 255.0;
        blue = (CGFloat)strtol([b UTF8String], NULL, 16) / 255.0;
    } else {
        return [UIColor clearColor];
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - Ubuntu Font Library

+ (UIFont *)ubuntu_font_with_size:(CGFloat)size weight:(UIFontWeight)weight {
    NSString *weightString;
    if (weight == UIFontWeightBold) {
        weightString = @"Bold";
    } else if (weight == UIFontWeightLight) {
        weightString = @"Light";
    } else if (weight == UIFontWeightMedium) {
        weightString = @"Medium";
    } else {
        weightString = @"Regular";
    }
    
    NSString *fontName = [NSString stringWithFormat:@"Ubuntu-%@", weightString];
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font) {
        return font;
    }
    
    return [UIFont systemFontOfSize:size weight:weight];
}

+ (UIFont *)ubuntu_font_with_size:(CGFloat)size {
    return [self ubuntu_font_with_size:size weight:UIFontWeightRegular];
}

#pragma mark - KeyWindow Access

+ (nullable UIWindow *)key_window {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - Local Persistence

static NSString *const key_prefix = @"KKToolUtils_";

+ (void)save_to_local:(NSString *)key value:(nullable id)value {
    NSString *fullKey = [key_prefix stringByAppendingString:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (value) {
        [defaults setObject:value forKey:fullKey];
    } else {
        [defaults removeObjectForKey:fullKey];
    }
    [defaults synchronize];
}

+ (nullable id)read_from_local:(NSString *)key {
    NSString *fullKey = [key_prefix stringByAppendingString:key];
    return [[NSUserDefaults standardUserDefaults] objectForKey:fullKey];
}

+ (void)remove_from_local:(NSString *)key {
    NSString *fullKey = [key_prefix stringByAppendingString:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:fullKey];
    [defaults synchronize];
}

+ (void)clear_local_namespace {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults dictionaryRepresentation];
    for (NSString *key in dict.allKeys) {
        if ([key hasPrefix:key_prefix]) {
            [defaults removeObjectForKey:key];
        }
    }
    [defaults synchronize];
}

#pragma mark - Quick Access Properties

+ (nullable NSString *)token {
    return [self read_from_local:@"token"];
}

+ (void)setToken:(nullable NSString *)token {
    [self save_to_local:@"token" value:token];
}

+ (nullable NSString *)user_id {
    return [self read_from_local:@"userId"];
}

+ (void)setUser_id:(nullable NSString *)user_id {
    [self save_to_local:@"userId" value:user_id];
}

+ (nullable NSString *)mobile {
    return [self read_from_local:@"mobile"];
}

+ (void)setMobile:(nullable NSString *)mobile {
    [self save_to_local:@"mobile" value:mobile];
}

+ (nullable id)category_infos {
    return [self read_from_local:@"categoryInfos"];
}

+ (void)setCategory_infos:(nullable id)category_infos {
    [self save_to_local:@"categoryInfos" value:category_infos];
}

@end
