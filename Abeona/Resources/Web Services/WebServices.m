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
    
    ModelLocator *model = [ModelLocator getInstance];
    
    [self.delegate webServiceStart];
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] init];
    operation.securityPolicy.validatesDomainName = NO;
    operation.securityPolicy.allowInvalidCertificates = YES;
    
    NSLog(@"%@",paramsDict);
    
    operation.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [operation POST:serviceURL parameters:paramsDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                            
                                                           options:NSJSONWritingPrettyPrinted
                            
                                                             error:&error];
        
        NSString *aStr;
        aStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",aStr);
        
        if(responseObject != nil) {
            if (self.delegate) {
                
                NSMutableArray *triptripOptions = [[responseObject objectForKey:@"trips"] valueForKey:@"tripOption"];
                if (triptripOptions.count > 0) {
                    model.tripOptions = triptripOptions;
                    model.flightSegmentsArray = [[[[model.tripOptions objectAtIndex:0] valueForKey:@"slice"] objectAtIndex:0] valueForKey:@"segment"];
                }

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
        
        
    } failure:^(AFHTTPRequestOperation*  _Nonnull operation, NSError*  _Nonnull error) {
        
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
        
            if(responseObject != nil) {
                if (self.delegate) {
                    
                    if ([returnType isEqualToString:@"destination"]) {
                        
                        NSArray *components = [[[responseObject valueForKey:@"results"] objectAtIndex:0] valueForKey:@"address_components"];
                        for (NSDictionary *dict in components) {
                            NSString *type = [[dict valueForKey:@"types"] objectAtIndex:0];
                            if ([type isEqualToString:@"country"]) {
                                [model.stepsAdressArray addObject:[dict valueForKey:@"long_name"]];
                                break;
                            }
                        }

                    }
                    else if ([returnType isEqualToString:@"AirportCode"])
                    {
                        model.code = [responseObject valueForKey:@"code"];
                    }
                    else if ([returnType isEqualToString:@"DRIVING"])
                    {
                       
                        NSArray *routes = [responseObject objectForKey:@"routes"];
                        if (routes.count > 0) {
                            NSLog(@"%@",aStr);
                            model.legsDrivingDict = [[[routes objectAtIndex:0] objectForKey:@"legs"]objectAtIndex:0];
                            model.drivingSteps = [[[[routes objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
                            
                        }
                        else
                        {
                            model.optionsArray = [responseObject objectForKey:@"available_travel_modes"];
                        }
                        
                    }
                    else  if ([returnType isEqualToString:@"transit"])
                    {
                        
                        NSArray *routes = [responseObject objectForKey:@"routes"];
                        if (routes.count > 0) {
                            model.legsTransitDict = [[[routes objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0];
                            model.transitSteps = [[[[routes objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps" ];
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
