//
//  FXDatabase.m
//  FXDatabase
//
//  Created by Mr.wu on 2020/7/14.
//  Copyright © 2020 Mr.wu. All rights reserved.
//

#import "FXDatabase.h"
#import <objc/runtime.h>
@import FMDB;

@implementation FXIdentifierEntity
- (NSString *)description
{
    return [NSString stringWithFormat:@"id:%ld, %@", (long)self.identifier, self.entity];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, self.description];
}
@end

@interface FXDatabase ()
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, copy) NSString *identifierField;
@end

@implementation FXDatabase

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"db.sqlite"];
        NSLog(@"database.path:%@", path);
        instance = [[self alloc] initWithDataBasePath:path];
    });
    return instance;
}

- (instancetype)init
{
    return [self initWithDataBasePath:[FXDatabase shareInstance].dataBasePath];
}

- (instancetype)initWithDataBasePath:(NSString *)path {
    if (self = [super init]) {
        self.identifierField = @"id";
        self.dataBasePath = path;
        self.database = [FMDatabase databaseWithPath:path];
        if ([self.database open]) {

        } else {
            NSLog(@"未能打开数据库");
        }
    }
    return self;
}

- (void)setTableType:(Class)tableType {
    _tableType = tableType;
    NSString *tableName = NSStringFromClass(tableType);

    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(tableType, &outCount);
    NSMutableString *fieldStr = @"".mutableCopy;
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [fieldStr appendFormat:@"%@ text", key];
        if (i != outCount - 1) {
            [fieldStr appendFormat:@", "];
        }
    }

    NSString *createTableSqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ integer PRIMARY KEY AUTOINCREMENT, %@)", tableName, self.identifierField, fieldStr];

    [self.database executeUpdate:createTableSqlString];
}

- (void)addEntity:(NSObject *)entity {
    if (entity == nil) return;
    NSString *tableName = NSStringFromClass(entity.class);
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(entity.class, &outCount);
    NSMutableString *fieldStr = @"".mutableCopy;
    NSMutableString *valueStr = @"".mutableCopy;
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *field = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [entity valueForKey:field];
        [fieldStr appendString:field];
        [valueStr appendFormat:@"'%@'", value];
        if (i != outCount - 1) {
            [fieldStr appendString:@", "];
            [valueStr appendString:@", "];
        }
    }

    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", tableName, fieldStr, valueStr];
    [self.database executeUpdate:sql];
}

- (NSArray<FXIdentifierEntity *> *)queryEntitys {
    NSMutableArray *result = @[].mutableCopy;
    NSString *tableName = NSStringFromClass(self.tableType);
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(self.tableType, &outCount);
    NSMutableString *fieldStr = @"".mutableCopy;
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *field = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [fieldStr appendString:field];
        if (i != outCount - 1) {
            [fieldStr appendString:@", "];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"select %@, %@ FROM %@", self.identifierField, fieldStr, tableName];
    FMResultSet *rs = [self.database executeQuery:sql];
    while ([rs next]) {
        int identifier = [rs intForColumnIndex:0];
        id entity = [[self.tableType alloc] init];
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *field = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [entity setValue:[rs objectForColumnIndex:i + 1] forKey:field];
        }
        FXIdentifierEntity *idEntity = [[FXIdentifierEntity alloc] init];
        idEntity.identifier = identifier;
        idEntity.entity = entity;
        [result addObject:idEntity];
    }
    return result;
}

- (void)deleteEntity:(FXIdentifierEntity *)entity {
    if (entity == nil) return;
    NSString *tableName = NSStringFromClass(self.tableType);
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", tableName, self.identifierField, (long)entity.identifier];
    [self.database executeUpdate:sql];
}

- (void)updateEntity:(FXIdentifierEntity *)entity {
    if (entity == nil) return;
    NSString *tableName = NSStringFromClass(entity.entity.class);
    NSMutableString *updateStr = @"".mutableCopy;
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(entity.entity.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *field = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [updateStr appendFormat:@"%@ = '%@'", field, [entity.entity valueForKey:field]];
        if (i != outCount - 1) {
            [updateStr appendString:@", "];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@ = %ld", tableName, updateStr, self.identifierField, (long)entity.identifier];
    [self.database executeUpdate:sql];
}

@end
