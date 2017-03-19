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
    NSDictionary *oldNameToNewNameDict = @{};
    if ([cls respondsToSelector:@selector(oldNameToNewName)]) {
        oldNameToNewNameDict = [cls oldNameToNewName];
    }
    NSArray *oldNames = [XTableModel tableSortedNames:cls uid:uid];
    NSArray *newNames = [XModelTool tableSortedIvarNames:cls];
    for (NSString *newName in newNames) {
        NSString *oldName = newName;
        if ([oldNameToNewNameDict[newName] length] != 0) {
            oldName = oldNameToNewNameDict[newName];
        }
        
        if (![oldNames containsObject:newName] && ![oldNames containsObject:oldName]) {
            continue;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tempTableName, newName, oldName, tableName, tableName, primaryKey, tempTableName, primaryKey];
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

+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid {
    
    // 判断表格是否存在，不存在就创建
    Class cls = [model class];
    if (![XTableModel isTableExists:cls uid:uid]) {
        NSLog(@"表不存在");
        [self createTable:cls uid:uid];
    }
    // 判断是否需要更新, 需要，就更新
    if ([self isTableRequiredUpdate:cls uid:uid]) {
        BOOL result = [self isSuccessUpdateTable:cls uid:uid];
        if (!result) {
            NSLog(@"更新表格失败");
            return NO;
        }
    }
    NSString *tableName = [XModelTool tableName:cls];
    // 获取主键
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"请先实现+ primaryKey 方法");
        return nil;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    // 根据主键的值判断是更新还是保存（有值-更新，无值-保存
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [XSqliteTool querySql:checkSql uid:uid];
    
    NSArray *columnNames = [XModelTool classIvarNameAndTypeDict:cls].allKeys;
    NSMutableArray *setValueArray = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        [values addObject:value];
        
        NSString *str = [NSString stringWithFormat:@"%@='%@'", columnName, value];
        [setValueArray addObject:str];
    }
    
    NSString *execSql;
    // 更新
    if (result.count > 0) {
        execSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = %@", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
    } else { // 插入
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    
    return [XSqliteTool dealSql:execSql uid:uid];
}

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid {
    Class cls = [model class];
    NSString *tableName = [XModelTool tableName:cls];
    // 获取主键
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"请先实现+ primaryKey 方法");
        return nil;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
   
    NSString *execSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    return [XSqliteTool dealSql:execSql uid:uid];
}

+ (NSArray *)queryModel:(id)model uid:(NSString *)uid {
    Class cls = [model class];
    NSString *tableName = [XModelTool tableName:cls];
    // 获取主键
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"请先实现+ primaryKey 方法");
        return nil;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    NSString *execSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *resultArr = [XSqliteTool querySql:execSql uid:uid];
    return [self parseResults:resultArr withClass:cls];
}

+ (NSArray *)parseResults: (NSArray <NSDictionary *>*)results withClass:(Class)cls {
    
    NSDictionary *nameTypeDict = [XModelTool classIvarNameAndTypeDict:cls];
    
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *type = nameTypeDict[key];
            id resultValue = obj;
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            } else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            [model setValue:resultValue forKeyPath:key];
        }];
    }
    NSLog(@"%@", models);
    return models;
}

@end
