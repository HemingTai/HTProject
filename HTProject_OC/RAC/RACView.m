//
//  RACView.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/28.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "RACView.h"

@implementation RACView

//- (RACSubject *)btnClickSignal
//{
//    if (!_btnClickSignal)
//    {
//        _btnClickSignal = [RACSubject subject];
//    }
//    return _btnClickSignal;
//}

- (IBAction)btnAction:(id)sender
{
//    [self.btnClickSignal sendNext:sender];
    [self send:@"Tai"];
}

- (void)send:(id)obj
{
    
}

@end
