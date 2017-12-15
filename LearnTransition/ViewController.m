//
//  ViewController.m
//  LearnTransition
//
//  Created by yiqiwang(王一棋) on 2017/12/15.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "ViewController.h"
#import <TransitionKit/TransitionKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    TKStateMachine *inboxStateMachine = [TKStateMachine new];

    TKState *unread = [TKState stateWithName:@"Unread"];
    [unread setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"unread");
    }];
    TKState *read = [TKState stateWithName:@"Read"];
    [read setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"read");
    }];
    TKState *deleted = [TKState stateWithName:@"Deleted"];
    [deleted setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"deleted");
    }];

    [inboxStateMachine addStates:@[ unread, read, deleted ]];
    inboxStateMachine.initialState = unread;

    TKEvent *viewMessage = [TKEvent eventWithName:@"View Message" transitioningFromStates:@[ unread ] toState:read];
    TKEvent *deleteMessage = [TKEvent eventWithName:@"Delete Message" transitioningFromStates:@[ read, unread ] toState:deleted];
    TKEvent *markAsUnread = [TKEvent eventWithName:@"Mark as Unread" transitioningFromStates:@[ read, deleted ] toState:unread];

    [inboxStateMachine addEvents:@[ viewMessage, deleteMessage, markAsUnread ]];

    // Activate the state machine
    [inboxStateMachine activate];

    [inboxStateMachine isInState:@"Unread"]; // YES, the initial state

    // Fire some events
    NSDictionary *userInfo = nil;
    NSError *error = nil;
    BOOL success = [inboxStateMachine fireEvent:@"View Message" userInfo:userInfo error:&error]; // YES
    success = [inboxStateMachine fireEvent:@"Delete Message" userInfo:userInfo error:&error]; // YES
    success = [inboxStateMachine fireEvent:@"Mark as Unread" userInfo:userInfo error:&error]; // YES

    success = [inboxStateMachine canFireEvent:@"Mark as Unread"]; // NO

    // Error. Cannot mark an Unread message as Unread
    success = [inboxStateMachine fireEvent:@"Mark as Unread" userInfo:nil error:&error]; // NO

    // error is an TKInvalidTransitionError with a descriptive error message and failure reason
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
