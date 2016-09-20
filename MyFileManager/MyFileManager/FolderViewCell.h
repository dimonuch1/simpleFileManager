//
//  FolderViewCell.h
//  MyFileManager
//
//  Created by Dima on 08.09.16.
//  Copyright © 2016 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *folderImage;

@end
