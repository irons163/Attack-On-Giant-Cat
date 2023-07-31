//
//  BuyViewController.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/30.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "BuyViewController.h"
#import "CommonUtil.h"

@interface BuyViewController ()

@end

@implementation BuyViewController{
    int currentClick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.ItemLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"GAME_SAVE_AND_AD_REMOVE", "")];
    self.ItemLabel.numberOfLines = 0;
    self.ItemLabel.textAlignment = NSTextAlignmentCenter;
    [self.ItemLabel sizeToFit];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define kRemoveAdsProductIdentifier @"com.irons.infinity.AttackOnGiantCat.RemoveAds"

const int click5000btn = 0;
const int click30000btn = 1;
const int click65000btn = 2;
const int click175000btn = 3;
const int click375000btn = 4;
const int click850000btn = 5;

- (IBAction)tapsRemoveAdsButton{
    NSLog(@"User requests to remove ads");
    
    currentClick = click5000btn;
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    } else {
        NSLog(@"User cannot make payments due to parental controls");
    }
}

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:false
                             completion:^{
        
    }];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count > 0) {
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    } else if(!validProduct) {
        NSLog(@"No products available");
    }
}

- (IBAction)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"received fial restored transactions: %i", queue.transactions.count);
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)doRemoveAds {
    [self.viewController removeAd];
    
    areAdsRemoved = YES;

    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load whether or not they bought it
    //it would be better to use KeyChain access, or something more secure
    //to store the user data, because NSUserDefaults can be changed.
    //You're average downloader won't be able to change it very easily, but
    //it's still best to use something more secure than NSUserDefaults.
    //For the purpose of this tutorial, though, we're going to use NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"isPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ((CommonUtil*)[CommonUtil sharedInstance]).isPurchased = true;
}

@end
