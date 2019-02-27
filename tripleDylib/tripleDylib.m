//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  tripleDylib.m
//  tripleDylib
//
//  Created by grx on 2019/2/21.
//  Copyright (c) 2019 grx. All rights reserved.
//

#import "tripleDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>

CHConstructor{
    printf(INSERT_SUCCESS_WELCOME);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"成功加载webView" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertVC animated:true completion:nil];
    });
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//
//#ifndef __OPTIMIZE__
//        CYListenServer(6666);
//
//        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
//        [manager loadCycript:NO];
//
//        NSError* error;
//        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
//        NSLog(@"result: %@", result);
//        if(error.code != 0){
//            NSLog(@"error: %@", error.localizedDescription);
//        }
//#endif
//
//    }];
}


CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);

    NSLog(@"origin name is:%@",originName);

    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);

    NSLog(@"password is %@",password);

    [self newMethod:@"output"];

    //set new property
    self.newProperty = @"newProperty";

    NSLog(@"newProperty : %@", self.newProperty);

    //change the value
    return @"grx";

}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);

    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
}

