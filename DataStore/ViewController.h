//
//  ViewController.h
//  DataStore
//
//  Created by Juxue Chen on 13-4-2.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"

@interface ViewController : UIViewController 

@property (nonatomic,readonly) NSString *fileName;
- (IBAction)aButtonAction1:(id)sender;
- (IBAction)aButtonAction2:(id)sender;

- (IBAction)insertAction:(id)sender;
- (IBAction)updateAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

- (IBAction)cdIndesert:(id)sender;
- (IBAction)cdUpdate:(id)sender;
- (IBAction)cdDelete:(id)sender;

@end
