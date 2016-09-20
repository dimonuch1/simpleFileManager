//
//  CreateNewFolder.m
//  MyFileManager
//
//  Created by Dima on 09.09.16.
//  Copyright © 2016 Dima. All rights reserved.
//

#import "CreateNewFolder.h"
//#import "ViewController.h"
#import <UIKit/UIKit.h>

@implementation CreateNewFolder 

-(void) viewDidLoad{
    //сразу вызываем клавиатуру
    [super viewDidLoad];
    [self.nameNewFolder isFirstResponder];
    self.nameNewFolder.delegate = self;
}

-(void) setPath:(NSString *)path{
    _path = path;
}

- (IBAction)createAction:(UIButton *)sender {
    
    if(self.nameNewFolder.text.length > 0){
        
        NSFileManager* fm = [NSFileManager defaultManager];
        if(!fm)
            NSLog(@"Manager dosen't exist!");
        NSError* error = nil;
    if(![fm createDirectoryAtPath: [self.path stringByAppendingPathComponent:self.nameNewFolder.text]
             withIntermediateDirectories:YES
                              attributes:nil
                            error:&error]){
        NSLog(@"%@",[error localizedFailureReason]);
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    }else{
    
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"Please enter some text"
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Ok", nil];
        [alert show];
    
    }
        
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIButton* b = [[UIButton alloc]init];
    [self createAction:b];

    return YES;
}


@end
