//
//  Product+CoreDataProperties.h
//  RetailStore
//
//  Created by Preetam Jadakar on 10/07/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *carted;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSDecimalNumber *price;
@property (nullable, nonatomic, retain) NSString *productName;
@property (nullable, nonatomic, retain) NSDate *updatedDate;

@end

NS_ASSUME_NONNULL_END
