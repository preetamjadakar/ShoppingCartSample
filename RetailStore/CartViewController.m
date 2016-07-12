//
//  CartViewController.m
//  RetailStore
//
//  Created by Preetam Jadakar on 09/07/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import "CartViewController.h"
#import "Product.h"
#import "DetailViewController.h"
@interface CartViewController ()
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (nonatomic,retain)NSArray *cartData;
@property (weak, nonatomic) IBOutlet UILabel *emptyListMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;

@end

@implementation CartViewController
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
    
    [self.cartTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self fetchCartData];
    [self.cartTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // init the cell
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Product *product = [self.cartData objectAtIndex:indexPath.row];
    cell.textLabel.text = product.productName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: %@ $",product.price];

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        
        DetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.cartTableView indexPathForSelectedRow];
        detailVC.selectedProduct = self.cartData [indexPath.row];
    }
    
}

-(void)fetchCartData{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Product"
                                      inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"carted = true"]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedDate" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    self.cartData = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                        error:nil];
    if (self.cartData.count) {
        self.emptyListMessageLabel.hidden = YES;
        self.priceView.hidden = NO;
        
        NSDecimal * sum = (__bridge NSDecimal *)([self.cartData valueForKeyPath:@"@sum.self.price"]);
        self.totalPriceLabel.text = [NSString stringWithFormat:@"Total: %@ $", sum];

    }
    else{
        self.emptyListMessageLabel.hidden= NO;
        self.priceView.hidden = YES;
        self.totalPriceLabel.text = @"NA";
    }
}

@end
