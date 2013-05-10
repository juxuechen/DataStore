//
//  ItemInfo.h
//  DataStore
//
//  Created by ChenYang on 13-5-10.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemDetails;

@interface ItemInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * cdInt;
@property (nonatomic, retain) ItemDetails *details;

@end
