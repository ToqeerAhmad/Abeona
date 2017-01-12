//
//  JsonParser.m
//  Abeona
//
//  Created by Toqir Ahmad on 12/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "JsonParser.h"
#import "ResponseModel.h"

@implementation JsonParser

- (void)parseResponseData:(NSMutableArray *)responseArray {
    
    ModelLocator *model = [ModelLocator getInstance];
    model.resposeArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dict in responseArray) {
        ResponseModel *object = [[ResponseModel alloc] init];
        object.title = [[dict objectForKey:@"title"] objectForKey:@"rendered"];
        object.content = [[dict objectForKey:@"content"] objectForKey:@"rendered"];
        object.image = [[dict objectForKey:@"attraction_image"] objectForKey:@"source_url"];
        object.lattitude = [[dict objectForKey:@"acf"] objectForKey:@"latitude"];
        object.longitude = [[dict objectForKey:@"acf"] objectForKey:@"longitude"];
        object.address = [[dict objectForKey:@"acf"] objectForKey:@"address"];
        object.phone = [[dict objectForKey:@"acf"] objectForKey:@"phone"];
        object.type = [[dict objectForKey:@"acf"] objectForKey:@"attraction_type"];
        object.typeMarket = [[dict objectForKey:@"acf"] objectForKey:@"target_market"];
        [model.resposeArray addObject:object];
    }
    
}
    
@end
