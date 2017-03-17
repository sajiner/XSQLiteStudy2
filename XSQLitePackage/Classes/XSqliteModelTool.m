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

@end
