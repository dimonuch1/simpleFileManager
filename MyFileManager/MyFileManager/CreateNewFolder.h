//
//  CreateNewFolder.h
//  MyFileManager
//
//  Created by Dima on 09.09.16.
//  Copyright © 2016 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageTableViewController.h"

@interface CreateNewFolder : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITextField *nameNewFolder;

@property(strong,nonatomic) NSString* path;

- (IBAction)createAction:(UIButton *)sender;
-(void) setPath:(NSString*)path;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
