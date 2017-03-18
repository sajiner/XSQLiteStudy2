//
//  XStudent.m
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import "XStudent.h"

@implementation XStudent

+ (NSString *)primaryKey {
    return @"stuNum";
}

+ (NSArray *)ignoreColumnNames {
    return @[@"score2"];
}

@end
