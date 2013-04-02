//
//  ViewController.m
//  DataStore
//
//  Created by Juxue Chen on 13-4-2.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)fileName{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"test"];
    
    return filename;
}

- (IBAction)aButtonAction1:(id)sender {
    TestObject *obj = [[TestObject alloc] init];
    obj.number = 2;
    obj.string = @"2";
    BOOL save = [NSKeyedArchiver archiveRootObject:obj toFile:self.fileName];
    NSLog(@"存储 %@",save?@"成功":@"失败");
}

- (IBAction)aButtonAction2:(id)sender {
    TestObject *obj = [NSKeyedUnarchiver unarchiveObjectWithFile:self.fileName];
    NSLog(@"obj %@",obj);
}

@end
