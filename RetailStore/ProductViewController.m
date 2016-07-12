//
//  ProductViewController.m
//  RetailStore
//
//  Created by Preetam Jadakar on 09/07/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import "ProductViewController.h"
#import "Product.h"
#import "DetailViewController.h"
@interface ProductViewController ()
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (nonatomic,retain)NSFetchedResultsController *fetchedResultsController;

@end

@implementation ProductViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.productTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[[self fetchedResultsController] sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[[self fetchedResultsController] sections] objectAtIndex:section];
    return  [sectionInfo name];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // init the cell
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Product *product = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = product.productName;
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"details" sender:self];
}
#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"details"]) {
        
        DetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.productTableView indexPathForSelectedRow];
        detailVC.selectedProduct = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
}
#pragma mark - fetched results controller

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    [request setFetchBatchSize:20];
    
    NSSortDescriptor *sdType = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
    NSSortDescriptor *sdName = [[NSSortDescriptor alloc] initWithKey:@"productName" ascending:YES];
    [request setSortDescriptors:@[sdType, sdName]];
    
    NSFetchedResultsController *aController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category" cacheName:nil];
    
    aController.delegate = self;
    self.fetchedResultsController = aController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}
@end
