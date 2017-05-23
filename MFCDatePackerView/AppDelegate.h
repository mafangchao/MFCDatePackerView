//
//  AppDelegate.h
//  MFCDatePackerView
//
//  Created by machao on 2017/5/23.
//  Copyright © 2017年 machao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

