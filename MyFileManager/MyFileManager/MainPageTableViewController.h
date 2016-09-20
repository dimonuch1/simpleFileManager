//
//  MainPageTableViewController.h
//  MyFileManager
//
//  Created by Dima on 06.09.16.
//  Copyright © 2016 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateNewFolder.h"

@interface MainPageTableViewController : UITableViewController

@property(strong,nonatomic) NSString* path;

-(id)initWithFolderPath:(NSString*) path;

@end
