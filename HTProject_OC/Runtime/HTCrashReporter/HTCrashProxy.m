//
//  HTCrashProxy.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/23.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTCrashProxy.h"
#import "HTCrashConfiguration.h"

@implementation HTCrashProxy

- (void)ht_handleCrashMethod {
    NSString *exceptionName = @"App crashed due to uncaught exception: unrecognized selector send to instance";
    NSString *logExceptionMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n\n%@\n\n",HTCrashReporterTitleSeparator, exceptionName, HTCrashReporterBottomSeparator];
    NSLog(@"%@", logExceptionMessage);
}

@end
