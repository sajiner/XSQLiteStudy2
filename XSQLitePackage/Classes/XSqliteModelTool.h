//
//  XSqliteModelTool.h
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSqliteModelTool : NSObject

/**
 创建sqlite表

 @param cls 类名
 @param uid uid
 */
+ (BOOL)createTable: (Class)cls uid: (NSString *)uid;

/**
 判断表是否需要更新

 @param cls 类名
 @param uid uid
 @return Yes - 需要更新， NO-不需要更新
 */
+ (BOOL)isTableRequiredUpdate: (Class)cls uid: (NSString *)uid;

/**
 更新表

 @param cls 类名
 @param uid uid
 @return Yes - 更新成功， NO-更新失败
 */
+ (BOOL)isSuccessUpdateTable: (Class)cls uid: (NSString *)uid;

/**
 获取更新表的所有sql语句

 @param cls 类名
 @param uid uid
 @return 更新表的所有sql语句
 */
+ (NSArray *)udpateSqls: (Class)cls uid: (NSString *)uid;

/**
 更新或者存储模型

 @param model model
 @param uid uid
 @return 是否成功
 */
+ (BOOL)saveOrUpdateModel: (id)model uid: (NSString *)uid;

@end
