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
        
        if(self.segmentControl.selectedSegmentIndex == 0){
    if(![fm createDirectoryAtPath: [self.path stringByAppendingPathComponent:self.nameNewFolder.text]
             withIntermediateDirectories:YES
                              attributes:nil
                            error:&error]){
        NSLog(@"%@",[error localizedFailureReason]);
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
        }else if(self.segmentControl.selectedSegmentIndex == 1){
            NSString* filePath = [self.path stringByAppendingPathComponent:self.nameNewFolder.text];
            filePath = [NSString stringWithFormat:@"%@.txt",filePath];
            [fm createFileAtPath:filePath
                        contents:nil
                      attributes:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else{
    
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"Please enter some text"
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Ok", nil];
        [alert show];
    
    }
        
}




- (IBAction)valueChange:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex == 0){
        self.labelName.text = @"Folder Name";
        self.nameNewFolder.placeholder = @"folder naem";
        
    }else if(sender.selectedSegmentIndex == 1){
        self.labelName.text = @"File Name";
        self.nameNewFolder.placeholder = @"file naem";
    }

    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIButton* b = [[UIButton alloc]init];
    [self createAction:b];

    return YES;
}


@end
