//
//  PickerViewAlert.h
//  JobShout
//
//  Created by Liam Flynn on 10/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PickerViewAlertDelegate;

@interface PickerViewAlert : NSObject<UIPickerViewDelegate, UIPickerViewDataSource> {
    
    id<PickerViewAlertDelegate> __unsafe_unretained delegate;
    UIActionSheet *actionSheet;
    
    NSArray *contents;
    NSUInteger defaultPosition;
}

@property (nonatomic, unsafe_unretained) id<PickerViewAlertDelegate> delegate;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, assign) NSUInteger defaultPosition;

-(void) showPickerinToolbar:(UIToolbar*)parentBar withDefault:(NSUInteger)position;

@end

@protocol PickerViewAlertDelegate
- (void)pickerViewAlert:(PickerViewAlert*)sbjectAlert didChangeSelection:(NSInteger)newSelection;
- (void)pickerViewAlertFinished:(PickerViewAlert*)sbjectAlert;
@end
