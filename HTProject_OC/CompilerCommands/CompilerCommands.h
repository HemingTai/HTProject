//
//  CompilerCommands.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/9.
//  Copyright © 2019 Hem1ng. All rights reserved.
//  编译器命令

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/******************************************************************************************************
 *__attribute__是一套编译器指令，被GNU和LLVM编译器所支持，允许对于__attribute__增加一些参数，做一些高级检查和优化。
 *__attribute__的语法是，在后面加两个括号，然后写属性列表，属性列表以逗号分隔。
 *在iOS中，很多例如NS_CLASS_AVAILABLE_IOS的宏定义，内部也是通过__attribute__实现的。
 ******************************************************************************************************/

//objc_subclassing_restricted属性表示被修饰的类不能被其他类继承，如果继承会报错
//__attribute__((objc_subclassing_restricted))
@interface CompilerCommands : NSObject

//NS_AVAILABLE属性表示macOS10.11和iOS8.0可用
@property (nonatomic, copy) NSString *command NS_AVAILABLE(10_11,8_0);

//unavailable属性表示不可用，可添加说明unavailable("xxx")，如果使用会报错
@property (nonatomic, copy) NSString *cmd __attribute__((unavailable("please use command instead")));

- (instancetype)initWithCommands:(nullable NSString *)cmd name:(nullable NSString *)name;

//objc_requires_super属性表示子类必须调用被修饰的方法super，如果使用会报警告
- (void)mainFunction __attribute__((objc_requires_super));

@end



@interface HTCompilerCommands : CompilerCommands

//objc_designated_initializer属性表示实现该方法时需要调用父类的方法，如果不调用会报警告，可简写NS_DESIGNATED_INITIALIZER
- (instancetype)initWithCommands:(NSString *)cmd __attribute__((objc_designated_initializer));

//deprecated属性表示废弃某函数，可添加说明deprecated("xxx")，如果使用会报警告
- (instancetype)initWithName:(NSString *)name __attribute__((deprecated("please use initWithCommands: instead")));

//NS_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, ...)表示在macOS2.0和iOS8.0被引入，在macOS10.0和iOS10.0被废弃
- (void)mainFunction NS_DEPRECATED(2_0, 10_0, 8_0, 10_0, "已废弃");

@end



//objc_runtime_name属性可以在编译时，将Class或Protocol指定为另一个名字，并且新名字不受命名规范制约，可以以数字开头。
__attribute__((objc_runtime_name("MyCompiler")))
@interface TestCompilerCommands : NSObject

@end



@interface HTCompilerCommandsViewController : UIViewController



@end

NS_ASSUME_NONNULL_END
