//
//  WebServices.m
//
//  Copyright (c) 2014 Rac. All rights reserved.
//


#import "WebServices.h"
#import "AFNetworking.h"
#import "JSONParser.h"

@implementation WebServices


- (void)getDataFromQPX:(NSDictionary *)paramsDict andServiceURL:(NSString *)serviceURL andServiceReturnType:(NSString *)returnType {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDict // Here you can pass array or dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);

    
    
    [self.delegate webServiceStart];
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] init];
    operation.securityPolicy.validatesDomainName = NO;
    operation.securityPolicy.allowInvalidCertificates = YES;

    NSLog(@"%@",paramsDict);
    
    [operation POST:serviceURL parameters:jsonString success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                            
                                                           options:NSJSONWritingPrettyPrinted
                            
                                                             error:&error];
        
        NSString *aStr;
        aStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",aStr);
        
        if(responseObject != nil) {
            if (self.delegate) {
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

-(void)SendRequestForData:(NSMutableDictionary *)paramsDict andServiceURL:(NSString *)serviceURL andServiceReturnType:(NSString *)returnType
{
    
    ModelLocator *model = [ModelLocator getInstance];
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
//            NSLog(@"%@",aStr);
            if(responseObject != nil) {
                if (self.delegate) {
                    if ([returnType isEqualToString:@"DRIVING"]) {
                       
                        NSArray *routes = [responseObject objectForKey:@"routes"];
                        if (routes.count > 0) {
                            model.legsDrivingDict = [[routes objectAtIndex:0] objectForKey:@"legs"];
                            model.drivingSteps = [[[[routes objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
                            
                        }else {
                            model.optionsArray = [responseObject objectForKey:@"available_travel_modes"];
                        }
                        
                    }else  if ([returnType isEqualToString:@"transit"]) {
                        
                        NSArray *routes = [responseObject objectForKey:@"routes"];
                        if (routes.count > 0) {
                            model.legsTransitDict = [[routes objectAtIndex:0] objectForKey:@"legs"];
                            model.transitSteps = [[[[routes objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
                        }else {
                            model.optionsArray = [responseObject objectForKey:@"available_travel_modes"];
                        }
                        
                    }else {
                        JsonParser *jsonObject = [[JsonParser alloc] init];
                        [jsonObject parseResponseData:responseObject];
                    }
                }
                [self.delegate webServiceEnd:@"" andResponseType:returnType];

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
