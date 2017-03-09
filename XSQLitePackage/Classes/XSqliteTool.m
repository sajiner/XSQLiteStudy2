//
//  XSqliteTool.m
//  XSQLitePackage
//
//  Created by sajiner on 2017/3/9.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import "XSqliteTool.h"
#import "sqlite3.h"

#define kPathName NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

sqlite3 *ppDb = nil;

@implementation XSqliteTool

#pragma mark -  查询操作
- (NSMutableArray<NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid {
    if (![self openDB:uid]) {
        NSLog(@"打开数据库失败");
        return false;
    }
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句失败");
    }
    NSMutableArray *resultArrM = [NSMutableArray array];
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        int count = sqlite3_column_count(stmt);
        for (int i = 0; i < count; i++) {
            
            const char *columnNameC = sqlite3_column_name(stmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            int type = sqlite3_column_type(stmt, i);
            
            id value = nil;
            switch (type) {
                case SQLITE_TEXT:
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                    break;
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(stmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(stmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(stmt, i));
                    break;
                default:
                    break;
            }
            [dictM setValue:value forKey:columnName];
        }
        [resultArrM addObject:dictM];
    }
    sqlite3_finalize(stmt);
    [self closeDB];
    
    return resultArrM;
}

#pragma mark - 执行数据库
- (BOOL)dealSql: (NSString *)sql uid: (NSString *)uid {
    if (![self openDB:uid]) {
        NSLog(@"打开数据库失败");
        return false;
    }
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    [self closeDB];
    return result;
}

#pragma mark - 打开数据库
- (BOOL)openDB: (NSString *)uid {
    NSString *dbName = @"common.sqlite";
    if (uid) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    NSString *fileName = [kPathName stringByAppendingPathComponent:dbName];
    
    return sqlite3_open(fileName.UTF8String, &ppDb) == SQLITE_OK;
}

#pragma mark - 关闭数据库
- (void)closeDB {
    sqlite3_close(ppDb);
}

#pragma mark - 单例
static id _instance;
+ (instancetype)shareInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return _instance;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return _instance;
}



@end
