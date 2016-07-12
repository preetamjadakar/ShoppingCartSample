//
//  DetailViewController.m
//  RetailStore
//
//  Created by Preetam Jadakar on 10/07/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *cartButton;
- (IBAction)cartAction:(id)sender;
@end

@implementation DetailViewController
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.nameLabel.text = [NSString stringWithFormat:@"Name: %@",self.selectedProduct.productName];
    self.categoryLabel.text = [NSString stringWithFormat:@"Category: %@",self.selectedProduct.category];
    self.priceLabel.text = [NSString stringWithFormat:@"Price: %@ $",self.selectedProduct.price];
    
    [self checkCartStatus];
}
-(void)checkCartStatus{
    if ([self.selectedProduct.carted isEqualToNumber:@1]) {
        [self.cartButton setTitle:@"Remove from Cart" forState:UIControlStateNormal];
    }
    else
    {
        [self.cartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
        
    }
}

- (IBAction)cartAction:(id)sender {
    
    if ([self.selectedProduct.carted isEqualToNumber:@1]) {
        self.selectedProduct.carted = @0;
    }
    else{
        self.selectedProduct.carted = @1;
    }
    self.selectedProduct.updatedDate = [NSDate date];
    //update button title as per status
    [self checkCartStatus];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
}
@end
