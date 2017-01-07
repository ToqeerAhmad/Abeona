//
//  HelperClass.m
//  Scissors-User-ios
//
//  Created by Salman Nasir on 12/01/2016.
//  Copyright © 2016 Salman Nasir. All rights reserved.
//

#import "HelperClass.h"

@implementation HelperClass

+(BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidNumericString:(NSString*)string
{
    NSString *emailRegex = @"[0-9]{10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

+(BOOL)internationalPhoneNumberVaidation:(NSString*)string
{
    NSString *emailRegex = @"^\\+(?:[0-9] ?){6,14}[0-9]$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}


+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}


+ (void)showAlertView:(NSString*)heading andMessage:(NSString *)message andView:(UIViewController *)view {
    
//    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:heading message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertView addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    
//    [view presentViewController:alertView animated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:heading message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}


+(NSString *)getDate:(NSString *) date withFormat :(NSString *)dateFormat{

    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* dateObj = [format dateFromString:date];
    [format setDateFormat:dateFormat];
    
    return [format stringFromDate:dateObj];
}

+(NSString *)getDate:(NSString *) date withColonFormat :(NSString *)dateFormat{
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* dateObj = [format dateFromString:date];
    [format setDateFormat:dateFormat];
    
    return [format stringFromDate:dateObj];
}

+(NSString *)getUserToken{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"user_token"];
    return token;
}

+(NSString *)getUserId{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"id"];
    return token;
}

/*** Image Url with Cache ***/
+(void)returnImageFromUrlWithCache:(NSString *)imageURL andImagePlacement:(UIImageView *)imagePlacement{
    
//    NSString  *signedImageURl = [NSString stringWithFormat:@"%@",imageURL];
//    [imagePlacement sd_setImageWithURL:[NSURL URLWithString:signedImageURl]
//                      placeholderImage:nil
//                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL * url) {
//                                 [[SDImageCache sharedImageCache] storeImage:image forKey:signedImageURl];
//                             }];
    
}



@end
