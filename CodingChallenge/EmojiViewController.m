//
//  EmojiViewController.m
//  CodingChallenge
//
//  Created by Josh Nussbaum on 11/13/16.
//  Copyright © 2016 Josh Nussbaum. All rights reserved.
//

#import "EmojiViewController.h"

@interface EmojiViewController (){
    NSString *labelString;
    NSData *imageData;
}

@end

@implementation EmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emojiLabel.text = labelString;
    self.emojiImage.image = [UIImage imageWithData:imageData];
    
}

-(void)setEmojiWithLabelString:(NSString *)labelString_ imageData:(NSData *)imageData_{
    labelString = labelString_;
    imageData = imageData_;
}


@end
