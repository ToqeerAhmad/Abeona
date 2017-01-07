//
//  HelperClass.h
//  Scissors-User-ios
//
//  Created by Salman Nasir on 12/01/2016.
//  Copyright © 2016 Salman Nasir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperClass : NSObject

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+(BOOL)isValidEmail:(NSString *)email;
+(NSString *)getDate:(NSString *) date withFormat :(NSString *)dateFormat;
+(NSString *)getDate:(NSString *) date withColonFormat :(NSString *)dateFormat;
+(NSString *)getUserToken;
+(NSString *)getUserId;
+ (void)showAlertView:(NSString*)heading andMessage:(NSString *)message andView:(UIViewController *)view;
+(void)returnImageFromUrlWithCache:(NSString *)imageURL andImagePlacement:(UIImageView *)imagePlacement;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+(BOOL)isValidNumericString:(NSString*)string;
+(BOOL)internationalPhoneNumberVaidation:(NSString*)string;

@end
