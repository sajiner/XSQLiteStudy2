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

@end
