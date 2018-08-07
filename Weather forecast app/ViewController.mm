//
//  ViewController.m
//  Weather forecast app
//
//  Created by air on 03.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#include "Manager.h"
#include "Model.h"
#import "ViewController.h"
#import "HourWeatherItem.h"


@interface ViewController()
{
    Model *model;
    //Manager manager;
}
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) NSArray* data;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = new Model();
    
    model->getWeatherData("Odessa,ua");
    

    
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 14;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    HourWeatherItem *item = [collectionView makeItemWithIdentifier:@"HourWeatherItem"
                                                           forIndexPath:indexPath ];
    
    //NSLog(@"%d", indexPath.item);
    item.image.image = [NSImage imageNamed:@"sun"];
    item.label.integerValue = indexPath.item;
    return item;
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
