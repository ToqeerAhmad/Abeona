//
//  JsonParser.h
//  Abeona
//
//  Created by Toqir Ahmad on 12/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

- (void)parseResponseData:(NSMutableArray *)responseArray;
    
@end
