//
//  TestObject.h
//  DataStore
//
//  Created by Juxue Chen on 13-4-2.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject <NSCoding>

@property (nonatomic,assign) int number;
@property (nonatomic,retain) NSString *string;


@end
