//
//  ItemDetails.h
//  DataStore
//
//  Created by ChenYang on 13-5-10.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemInfo;

@interface ItemDetails : NSManagedObject

@property (nonatomic, retain) NSString * intString;
@property (nonatomic, retain) ItemInfo *info;

@end
