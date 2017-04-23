//
//  EmojiViewController.h
//  CodingChallenge
//
//  Created by Josh Nussbaum on 11/13/16.
//  Copyright © 2016 Josh Nussbaum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *emojiLabel;
@property (strong, nonatomic) IBOutlet UIImageView *emojiImage;

-(void)setEmojiWithLabelString:(NSString *)labelString_ imageData:(NSData *)imageData_;

@end
