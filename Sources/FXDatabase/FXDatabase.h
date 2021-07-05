//
//  FXDatabase.h
//  FXDatabase
//
//  Created by Mr.wu on 2020/7/14.
//  Copyright © 2020 Mr.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXIdentifierEntity<Entity: NSObject *> : NSObject
@property (nonatomic) NSInteger identifier;
@property (nonatomic, strong) Entity entity;
@end

@interface FXDatabase<Entity: NSObject *> : NSObject
@property (nonatomic, readonly) FMDatabase *database;
@property (nonatomic, readonly) NSString *dataBasePath;
@property (nonatomic, copy) Class tableType;

+ (instancetype)shareInstance;
- (instancetype)initWithDataBasePath:(NSString *)path NS_DESIGNATED_INITIALIZER;

- (void)addEntity:(Entity)entity;
- (NSArray<FXIdentifierEntity<Entity> *> *)queryEntitys;
- (void)deleteEntity:(FXIdentifierEntity<Entity> *)entity;
- (void)updateEntity:(FXIdentifierEntity<Entity> *)entity;

@end

NS_ASSUME_NONNULL_END
