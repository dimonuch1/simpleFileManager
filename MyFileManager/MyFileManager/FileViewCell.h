//
//  FileViewCell.h
//  MyFileManager
//
//  Created by Dima on 08.09.16.
//  Copyright © 2016 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UILabel* nameFile;
@property(weak,nonatomic) IBOutlet UILabel* sizeAndDate;
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;

@end
