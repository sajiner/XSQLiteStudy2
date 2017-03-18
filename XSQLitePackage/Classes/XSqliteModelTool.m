//
//  XSqliteModelTool.m
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import "XSqliteModelTool.h"
#import "XModelTool.h"
#import "XSqliteTool.h"
#import "XModelProtocol.h"
#import "XTableModel.h"

@implementation XSqliteModelTool

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid {
    
    // create table if not exists tableName(字段1 类型，字段2 类型 。。。)
    
    NSString *tableName = [XModelTool tableName:cls];
    NSString *columnNameAndType = [XModelTool columnNameAndTypeStr:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"请先实现+ primaryKey 方法");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, columnNameAndType, primaryKey];
    
    return [XSqliteTool dealSql:sql uid:uid];
}

+ (BOOL)isTableRequiredUpdate: (Class)cls uid: (NSString *)uid {
    NSArray *tableSortedNames = [XTableModel tableSortedNames:cls uid:uid];
    NSArray *modelSortedNames = [XModelTool tableSortedIvarNames:cls];
    
    return ![tableSortedNames isEqualToArray:modelSortedNames];
}

+ (BOOL)isSuccessUpdateTable:(Class)cls uid:(NSString *)uid {
    
    NSArray *sqls = [self udpateSqls:cls uid:uid];
    return [XSqliteTool dealSqls:sqls uid:uid];
}

+ (NSArray *)udpateSqls: (Class)cls uid: (NSString *)uid {
    if ([self isTableRequiredUpdate:cls uid:uid] == NO) {
        NSLog(@"不需要更新表");
        return nil;
    }
    // 创建正确结构的临时表
    NSMutableArray *sqls = [NSMutableArray array];
    NSString *tableName = [XModelTool tableName:cls];
    // 1.创建临时表
    NSString *tempTableName = [XModelTool tempTableName:cls];
    NSString *columnNameAndType = [XModelTool columnNameAndTypeStr:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"请先实现+ primaryKey 方法");
        return nil;
    }
    NSString *primaryKey = [cls primaryKey];
    NSString *tempSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tempTableName, columnNameAndType, primaryKey];
    [sqls addObject:tempSql];
    
    // 2.插入旧表中的主键数据到临时表
    NSString *insertPKeySql = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@", tempTableName, primaryKey, primaryKey, tableName];
    [sqls addObject:insertPKeySql];
    
    // 根据主键更新新表内容
    NSArray *oldNames = [XTableModel tableSortedNames:cls uid:uid];
    NSArray *newNames = [XModelTool tableSortedIvarNames:cls];
    for (NSString *name in newNames) {
        if (![oldNames containsObject:name]) {
            continue;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tempTableName, name, name, tableName, tableName, primaryKey, tempTableName, primaryKey];
        [sqls addObject:updateSql];
    }
    // 删除旧表
    NSString *dropSql = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [sqls addObject:dropSql];
    // 更新表明
    NSString *tableNameSql = [NSString stringWithFormat:@"alter table %@ rename to %@", tempTableName, tableName];
    [sqls addObject:tableNameSql];
    
    return sqls;
}

@end
