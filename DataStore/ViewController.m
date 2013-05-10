//
//  ViewController.m
//  DataStore
//
//  Created by Juxue Chen on 13-4-2.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ItemInfo.h"
#import "ItemDetails.h"

@interface ViewController ()
{
    sqlite3 * database;
}

- (void)openDatabase;
- (void)closeDatabase;
- (void)createTable;

- (BOOL)excuteSQL:(NSString *)sqlCmd;
- (BOOL)excuteSQLWithCString:(const char *)sqlCmd;
- (NSArray *)queryAllCustomers;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self openDatabase];
    [self createTable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self closeDatabase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - achive

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

#pragma mark - sqlite3

- (void)openDatabase
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
	NSString * dbPath = [KSDocumentPath() stringByAppendingPathComponent:@"testSQLite.db"];
    
    // delete db if exists.
    //
	BOOL success	= [fileManager fileExistsAtPath:dbPath];
    if (success) {
        NSError *error;
        [fileManager removeItemAtPath:dbPath error:&error];
    }
    
    // open database
    //
    int state = sqlite3_open([dbPath UTF8String], &database);
    if (state == SQLITE_OK) {
        DLOG(@" >> Succeed to open database. %@", dbPath);
    }
    else {
        DLOG(@" >> Failed to open database. %@", dbPath);
    }
}

- (void)closeDatabase
{
    if (database != NULL) {
        int state = sqlite3_close(database);
        if (state == SQLITE_OK) {
            DLOG(@" >> Succeed to close database.");
        }
        else {
            DLOG(@" >> Failed to open database.");
        }
        
        database = NULL;
    }
}

- (void)createTable
{
    if (database == NULL) {
        DLOG(@" >> Database does not open yet.");
        return;
    }
    
//创建表
//    id 你自己起的字段名字。
//    int 数据类型，整型。
//    primary key 定义这个字段为主键。
//    auto_increment 定义这个字段为自动增长，即如果INSERT时不赋值，则自动加1
    const char * sqlCmd = "create table if not exists testDB (id integer primary key autoincrement, string text not null,number integer)";
    
    [self excuteSQLWithCString:sqlCmd];
}

- (BOOL)excuteSQL:(NSString *)sqlCmd
{
    char * errorMsg;
    const char * sql = [sqlCmd cStringUsingEncoding:NSUTF8StringEncoding];
    int state = sqlite3_exec(database, sql, NULL, NULL, &errorMsg);
    if (state == SQLITE_OK) {
        DLOG(@" >> Succeed to %@", sqlCmd);
    }
    else {
        DLOG(@" >> Failed to %@. Error: %@",
             sqlCmd,
             [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]);
        
        sqlite3_free(errorMsg);
    }
    
    return (state == SQLITE_OK);
}

- (BOOL)excuteSQLWithCString:(const char *)sqlCmd
{
    char * errorMsg;
    int state = sqlite3_exec(database, sqlCmd, NULL, NULL, &errorMsg);
    if (state == SQLITE_OK) {
        DLOG(@" >> Succeed to %@",
             [NSString stringWithCString:sqlCmd encoding:NSUTF8StringEncoding]);
    }
    else {
        DLOG(@" >> Failed to %@. Error: %@",
             [NSString stringWithCString:sqlCmd encoding:NSUTF8StringEncoding],
             [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]);
        
        sqlite3_free(errorMsg);
    }
    
    return (state == SQLITE_OK);
}

- (NSArray *)queryAllCustomers
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    const char * sqlCmd = "select string, number from testDB";
    sqlite3_stmt * statement;
    int state = sqlite3_prepare_v2(database, sqlCmd, -1, &statement, nil);
    if (state == SQLITE_OK) {
        DLOG(@" >> Succeed to prepare statement. %@",
             [NSString stringWithCString:sqlCmd encoding:NSUTF8StringEncoding]);
    }
    
    NSInteger index = 0;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        // get raw data from statement
        //
        char * cstrString = (char *)sqlite3_column_text(statement, 0);
        int number = sqlite3_column_int(statement, 1);
        
        NSString *string = [NSString stringWithCString:cstrString encoding:NSUTF8StringEncoding];
        
        [array addObject:[NSString stringWithFormat:@"%@-%d",string,number]];
        
        DLOG(@"   >> Record %d : %@  %d", index++, string, number);
    }
    
    sqlite3_finalize(statement);
    
    DLOG(@" >> Query %d records.", [array count]);
    return array;
}

- (IBAction)insertAction:(id)sender {
    if (database == NULL) {
        DLOG(@" >> Database does not open yet.");
        return;
    }
    
    NSString * sqlCmd = [NSString stringWithFormat:@"insert into testDB (string, number) values ('%@', %d)",@"小荔枝",19];
    
    [self excuteSQL:sqlCmd];
    [self queryAllCustomers];
}

- (IBAction)updateAction:(id)sender {
    if (database == NULL) {
        DLOG(@" >> Database does not open yet.");
        return;
    }
    
    NSString * sqlCmd = [NSString stringWithFormat:@"update testDB set number=%d where string='%@'",88, @"小荔枝"];
    
    [self excuteSQL:sqlCmd];
    [self queryAllCustomers];
}

- (IBAction)deleteAction:(id)sender {
    if (database == NULL) {
        DLOG(@" >> Database does not open yet.");
        return;
    }
    
    NSString * sqlCmd = [NSString stringWithFormat:@"delete from testDB where number=%d",
                         88];
    
    [self excuteSQL:sqlCmd];
    [self queryAllCustomers];
}



- (IBAction)cdIndesert:(id)sender {
    NSInteger i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"int"] integerValue];
     [[NSUserDefaults standardUserDefaults] setInteger:i++ forKey:@"int"];
    
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    ItemInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"ItemInfo" inManagedObjectContext:context];
    info.cdInt = [NSNumber numberWithInteger:i];
    ItemDetails *details = [NSEntityDescription insertNewObjectForEntityForName:@"ItemDetails" inManagedObjectContext:context];
    details.intString = [NSString stringWithFormat:@"string-%d-int-%d",i,i];
    info.details = details;
    details.info = info;
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    //创建一个叫做fetch request的新方法，你可以将一个fetch request看做Sql中的select语句
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ItemInfo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //调用executeFetchRequest方法，将FailedBankInfo表中的所有数据推入一个数据缓存中
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (ItemInfo *info in fetchedObjects) {
        NSLog(@"ItemInfo->cdInt: %@", info.cdInt);
        ItemDetails *details = info.details;
        NSLog(@"ItemDetails->intString: %@", details.intString);
    }
}

- (IBAction)cdUpdate:(id)sender {
}

- (IBAction)cdDelete:(id)sender {
}

@end
