//
//  SearchPickerViewController.h
//  JobShout
//
//  Created by Liam Flynn on 24/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchPickerDelegate;

@interface SearchPickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
    
    id<SearchPickerDelegate> __unsafe_unretained delegate;
    
    NSArray *contents;
    NSString *contentsTitle;
    NSUInteger defaultPosition;
    
    
    IBOutlet UITextField *__unsafe_unretained subTitle;
    IBOutlet UIPickerView *__unsafe_unretained picker;
    IBOutlet UIButton *__unsafe_unretained acceptButton;
}

@property (nonatomic, unsafe_unretained) id<SearchPickerDelegate> delegate;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSString *contentsTitle;
@property (nonatomic, assign) NSUInteger defaultPosition;

@end

@protocol SearchPickerDelegate
- (void)searchPicker:(SearchPickerViewController*)sbjectAlert didChangeSelection:(NSInteger)newSelection;
- (void)searchPickerFinished:(SearchPickerViewController*)sbjectAlert;
@end
