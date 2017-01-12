//
//  WebServices.m
//
//  Copyright (c) 2014 Rac. All rights reserved.
//


#import "WebServices.h"
#import "AFNetworking.h"
#import "JSONParser.h"

@implementation WebServices

-(void)SendRequestForData:(NSMutableDictionary *)paramsDict andServiceURL:(NSString *)serviceURL andServiceReturnType:(NSString *)returnType
{
    
    NSLog(@"%@",paramsDict);
    NSLog(@"%@",serviceURL);
    
    [self.delegate webServiceStart];
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] init];
    operation.securityPolicy.validatesDomainName = NO;
    operation.securityPolicy.allowInvalidCertificates = YES;

    [operation GET:serviceURL parameters:paramsDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                            
                                                           options:NSJSONWritingPrettyPrinted
                            
                                                             error:&error];
        
            NSString *aStr;
            aStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",aStr);
            if(responseObject != nil) {
                if (self.delegate) {
                    JsonParser *jsonObject = [[JsonParser alloc] init];
                    [jsonObject parseResponseData:responseObject];
                    [self.delegate webServiceEnd:@"" andResponseType:returnType];
                }
            }else {
                if(self.delegate){
                    NSString *webserviceError = [responseObject objectForKey:@"errors"];
                    @try {
                        [self.delegate webServiceError:webserviceError];
                    }
                    @catch (NSException *exception) {
                        
                    }
                    @finally {
                        NSLog(@"%@",webserviceError);
                    }
                }
            }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        if(self.delegate){
            @try {
                [self.delegate webServiceError:error.localizedDescription];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                NSLog(@"%@",error);
            }
            
        }
    }];
}



@end
