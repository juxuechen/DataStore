//
//  TestObject.m
//  DataStore
//
//  Created by Juxue Chen on 13-4-2.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    // 这里放置需要持久化的属性
    [aCoder encodeObject:[NSNumber numberWithInteger:self.number] forKey:@"number"];
    [aCoder encodeObject:self.string forKey:@"string"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        //  这里务必和encodeWithCoder方法里面的内容一致，不然会读不到数据
        self.number = [[aDecoder decodeObjectForKey:@"number"] intValue];
        self.string = [aDecoder decodeObjectForKey:@"string"];
    }
    return self;
}



@end
