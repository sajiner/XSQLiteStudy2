//
//  XSqliteTool.h
//  XSQLitePackage
//
//  Created by sajiner on 2017/3/9.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSqliteTool : NSObject

/**
 执行数据库(增、删、改)

 @param sql sql语句
 @param uid 用户标识
 @return 结果，YES-成功 NO-失败
 */
+ (BOOL)dealSql: (NSString *)sql uid: (NSString *)uid;


/**
 查询操作

 @param sql sql语句
 @param uid 用户标识
 @return 结果集
 */
+ (NSMutableArray <NSMutableDictionary *>*)querySql: (NSString *)sql uid: (NSString *)uid;

/**
 执行多个数据
 
 @param sqls sql语句组
 @param uid 用户标识
 @return 结果，YES-成功 NO-失败
 */
+ (BOOL)dealSqls: (NSArray *)sqls uid: (NSString *)uid;

@end
