#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKToolUtils : NSObject

+ (NSString *)md5:(NSString *)input;
+ (nullable NSString *)url_domainFromHtml:(NSString *)html;

+ (void)emi_amount:(NSString *)amount duration:(NSString *)duration interest:(NSString *)interest result:(void(^)(NSString *amount, NSString *duration, NSString *interest))result;

#pragma mark - Card Formatting

+ (NSString *)format_card:(NSString *)num;

#pragma mark - Amount Formatting

+ (NSString *)format_amount:(NSString *)amount;

#pragma mark - Hex Color Parsing

+ (UIColor *)color_from_hex:(NSString *)hexString;

#pragma mark - Ubuntu Font Library

+ (UIFont *)ubuntu_font_with_size:(CGFloat)size weight:(UIFontWeight)weight;
+ (UIFont *)ubuntu_font_with_size:(CGFloat)size;

#pragma mark - KeyWindow Access

+ (nullable UIWindow *)key_window;

#pragma mark - Local Persistence

+ (void)save_to_local:(NSString *)key value:(nullable id)value;
+ (nullable id)read_from_local:(NSString *)key;
+ (void)remove_from_local:(NSString *)key;
+ (void)clear_local_namespace;

#pragma mark - Quick Access Properties

+ (nullable NSString *)token;
+ (void)setToken:(nullable NSString *)token;

+ (nullable NSString *)user_id;
+ (void)setUser_id:(nullable NSString *)user_id;

+ (nullable NSString *)mobile;
+ (void)setMobile:(nullable NSString *)mobile;

+ (nullable id)category_infos;
+ (void)setCategory_infos:(nullable id)category_infos;

+ (nullable NSString *)thanks;
+ (void)setThanks:(nullable NSString *)thanks;
@end

NS_ASSUME_NONNULL_END
