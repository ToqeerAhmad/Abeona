//
//  WebServices.h
//
//  Copyright (c) 2014 Rac. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, ServiceParser)
{
    loginServiceParser,
    forgetPasswordParser
};

@protocol RemoteApiProtocol <NSObject>
@required
-(void) webServiceStart;
-(void) webServiceEnd;
-(void) webServiceEnd:(NSInteger)index;
-(void) webServiceError:(NSString*)errorType;
@optional
-(void) webServiceError:(NSString*)errorType andType : (NSString *) type;
-(void) webServiceEndWithResponse:(NSDictionary*)dict;
-(void) webServiceEnd:(id)returnObject andResponseType:(id)responseType;
@end


@interface WebServices : NSObject
{
    MBProgressHUD *progressBar;
}

@property (nonatomic, assign) id delegate;
@property(nonatomic) ServiceParser serviceParserType;

- (void)getDataFromQPX:(NSMutableDictionary *)paramsDict andServiceURL:(NSString *)serviceURL andServiceReturnType:(NSString *)returnType;
-(void)SendRequestForData:(NSMutableDictionary *)paramsDict andServiceURL:(NSString *)serviceURL andServiceReturnType:(NSString *)returnType;

@end
