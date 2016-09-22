//
//  MainPageTableViewController.m
//  MyFileManager
//
//  Created by Dima on 06.09.16.
//  Copyright © 2016 Dima. All rights reserved.
//

#import "MainPageTableViewController.h"
#import "FolderViewCell.h"
#import "FileViewCell.h"


@interface MainPageTableViewController ()

//@property(strong,nonatomic) NSString* path;
@property(strong,nonatomic) NSArray* contents;
@property(strong,nonatomic) NSDictionary* dic;


- (IBAction)backHome:(UIButton *)sender;

@end

@implementation MainPageTableViewController

-(id)initWithFolderPath:(NSString*) path{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        self.path = path;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.path){
        self.path = @"/Users";
    }
    /*
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
     */
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if([self.navigationController.viewControllers count] > 1){
        UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButton:)];
        self.navigationItem.leftBarButtonItem = back;
        [self.tableView reloadData];
        //self.backHome.hidden = NO;
        /*
        //self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"domik.png"];
        UIBarButtonItem* home = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"domik.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backHome:)];
        self.navigationItem.rightBarButtonItem = home;
         */
    }
}

-(void) setPath:(NSString *)path{
    _path = path;
    NSError* error = nil;
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path
                                                                        error:&error];
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }
    [self.tableView reloadData];
    self.navigationItem.title = [self.path lastPathComponent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) isDirectory:(NSIndexPath*) indexPath{
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager]fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

-(NSString*) fileSizeFromValue:(unsigned long long)size{
    static NSString* units[] = {@"B",@"KB",@"MB",@"GB",@"TB"};
    static int unitsCount = 5;
    int index = 0;
    double fileSize = (double)size;
    while (fileSize > 1024 && index < unitsCount) {
        fileSize/=1024;
        index++;
    }
    return [NSString stringWithFormat:@"%.2f %@",fileSize,units[index]];
}


#pragma mark - Actions


- (void)backButton:(UIBarButtonItem *)sender {
    //self.path = [self.path stringByDeletingLastPathComponent];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backHome:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)deleteButton:(UIButton *)sender {
    //static BOOL b = NO;
    self.tableView.editing = !self.tableView.editing;
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        //NSLog(@"%@",indexPath);
        NSString* fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
        NSFileManager* fm = [NSFileManager defaultManager];
        NSError* error = nil;
        if(![fm removeItemAtPath:filePath error:&error]){
            NSLog(@"Error: %@",error.description);
        }
        
        NSMutableArray* tmp = [NSMutableArray arrayWithArray:self.contents];
        [tmp removeObjectAtIndex:indexPath.row];
        self.contents = tmp;
        [self.tableView reloadData];
        
        
        /*
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
         */
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* fileIdentifire = @"fileCell";
    static NSString* folderIdentifire = @"folderCell";
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    
    if([self isDirectory:indexPath]){
        
        FolderViewCell*folderCell = [tableView dequeueReusableCellWithIdentifier:folderIdentifire];
        folderCell.nameLabel.text = fileName;
        folderCell.folderImage.image = [UIImage imageNamed:@"folder2.png"];
        return folderCell;
    }else{
        NSString* path = [self.path stringByAppendingPathComponent:fileName];
        
        NSDictionary* attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
        
        FileViewCell* fileCell = [tableView dequeueReusableCellWithIdentifier:fileIdentifire];
        fileCell.nameFile.text = fileName;
        fileCell.fileImage.image = [UIImage imageNamed:@"file.png"];
        
        static NSDateFormatter* dateFormatter = nil;
        
        if(!dateFormatter){
            dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        NSString* date = [dateFormatter stringFromDate:[attributes fileModificationDate]];
        NSString* size = [self fileSizeFromValue:[attributes fileSize]];
        fileCell.sizeAndDate.text = [NSString stringWithFormat:@"%@ %@",size,date];
        return fileCell;
    }
    return nil;
}


//значек добавления либо удаления ячейки
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self isDirectory:indexPath]){
        NSString* folderName = [self.contents objectAtIndex:indexPath.row];
        NSString* newPath = [self.path stringByAppendingPathComponent:folderName];
        
    MainPageTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainPageTableViewController"];
        
        vc.path = newPath;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}


#pragma mark - Segue

-(BOOL) shouldPerformSegueWithIdentifier:(nonnull NSString *)identifier sender:(nullable id)sender{
    return YES;
}

-(void) prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender{
    CreateNewFolder* cf = segue.destinationViewController;
    [cf setPath:_path];
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
