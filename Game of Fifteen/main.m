//
//  main.m
//  Game of Fifteen
//
//  Created by Justin Amburn on 2/21/15.
//  Copyright (c) 2015 Justin Amburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TileMove.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {

//        Test array address comparison...
//        NSLog(@"BEGIN MAIN DEBUG");
//        NSMutableArray *array1;
//        NSMutableArray *array2;
//        array1 = [[NSMutableArray alloc] init];
//        array2 = [[NSMutableArray alloc] init];
//        
//        NSObject *n = [[NSObject alloc] init];
//        NSObject *n1 = [[NSObject alloc] init];
//        NSObject *n2 = [[NSObject alloc] init];
//        
//        [array1 addObject:n];
//        [array1 addObject:n1];
//        [array1 addObject:n2];
//        
//        for (NSObject *obj in array1) {
//            [array2 addObject:obj];
//        }
//        
//        NSLog(@"@%",array1);
//        NSLog(@"@%",array2);
//    
//        for (int i = 0; i < [array2 count]; i++) {
//            if (array1[i] == array2[i]) {
//                NSLog(@"array1[%d] %@ is equal to array2[%d] %@", i,array1[i],i,array2[i]);
//            }
//            else {
//                NSLog(@"array1[%d] %@ is NOT equal to array2[%d] %@", i,array1[i],i,array2[i]);
//            }
//        }
//        
//        
////        Now swap element index 2 and 3 in array2.
//        
//        NSObject *tmp = array2[1];
//        array2[1] = array2[2];
//        array2[2] = tmp;
//        
//        for (int i = 0; i < [array2 count]; i++) {
//            if (array1[i] == array2[i]) {
//                NSLog(@"array1[%d] %@ is equal to array2[%d] %@", i,array1[i],i,array2[i]);
//            }
//            else {
//                NSLog(@"array1[%d] %@ is NOT equal to array2[%d] %@", i,array1[i],i,array2[i]);
//            }
//        }
//        
//        NSLog(@"END MAIN DEBUG");
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
