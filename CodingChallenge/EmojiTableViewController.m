//
//  EmojiTableViewController.m
//  CodingChallenge
//
//  Created by Josh Nussbaum on 11/13/16.
//  Copyright © 2016 Josh Nussbaum. All rights reserved.
//

#import "EmojiTableViewController.h"
#import "EmojiTableViewCell.h"
#import "EmojiViewController.h"

@interface EmojiTableViewController (){
    NSDictionary *emojiDictionary;
    NSMutableDictionary *emojiImageDataDictionary;
    NSArray *emojiKeys;
    NSInteger selectedRow;
    NSInteger scrollingRowIndex;
}

@end

@implementation EmojiTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    scrollingRowIndex = 0;
    emojiDictionary = [[NSDictionary alloc]init];
    emojiImageDataDictionary = [[NSMutableDictionary alloc]init];
    emojiKeys = [[NSArray alloc]init];
    
    [self getEmojiData];

//    for (int i = 0; i < emojiKeys.count; i++){
//        NSString *key = emojiKeys[i];
//        NSString *urlString = emojiDictionary[key];
//        
//        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlString]];
//        
//        [emojiImageDataDictionary setObject:imageData forKey:key];
//        
//    }

}


- (void)getEmojiData{
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/emojis"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSError *err = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableContainers
                              error:&err];
    
    NSLog(@"Here is the data -> %@", jsonData);
    emojiDictionary = jsonData;
    emojiKeys = [emojiDictionary allKeys];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return emojiDictionary.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"We are rendering this index -> %ld", (long)indexPath.row);
    EmojiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmojiTableViewCell" forIndexPath:indexPath];
    
    NSString *key = emojiKeys[indexPath.row];
    
    // check to see if we have the imageData in emojiImageDataDictionary, and if we do then use that instead of making a web call
    NSData *imageData = [emojiImageDataDictionary objectForKey:key];
    if (imageData == nil){
        NSString *urlString = emojiDictionary[key];
        
        imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlString]];
        
        [emojiImageDataDictionary setObject:imageData forKey:key];

    }
    
    cell.emojiImageView.image = [UIImage imageWithData: imageData];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"show_emoji_segue" sender:self];
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        // after done displaying the last cell, load the next 20
        [self loadEmojisWithStart:indexPath.row end:indexPath.row + 20];
    }
}


-(void) loadEmojisWithStart:(NSInteger)start end:(NSInteger)end{
    if (end > emojiKeys.count) end = emojiKeys.count;
    NSLog(@"Loading from start: %ld to end: %ld", (long)start, (long)end);
    for (int i = 0; i < end; i++){
        NSString *key = emojiKeys[i];
        
        NSData *imageData = [emojiImageDataDictionary objectForKey:key];
        if (imageData == nil){
            NSString *urlString = emojiDictionary[key];
            
            imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlString]];
            
            [emojiImageDataDictionary setObject:imageData forKey:key];
        }
    }
}
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSArray *visibleTableViewCells = self.tableView.indexPathsForVisibleRows;
//    NSLog(@"Here are the visible cells -> %@", visibleTableViewCells);
//
//    NSIndexPath *lastIndexPath = [visibleTableViewCells objectAtIndex:(visibleTableViewCells.count-1)];
//    NSInteger lastIndex = lastIndexPath.row;
//    NSLog(@"Here is the scrolling row index -> %ld, and the last visible index -> %ld", (long)scrollingRowIndex, (long)lastIndex);
//    if (scrollingRowIndex == 0){
//        scrollingRowIndex = lastIndex + 40;
//    }
//    
//    if (lastIndex + 20 >= scrollingRowIndex){
//        [self loadEmojisWithStart:lastIndex end:scrollingRowIndex];
//        scrollingRowIndex += 20;
//    }
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show_emoji_segue"]) {
        NSString *labelString = emojiKeys[selectedRow];
        NSData *imageData = emojiImageDataDictionary[labelString];
        EmojiViewController *vc = [segue destinationViewController];
        [vc setEmojiWithLabelString:labelString imageData:imageData];
    }
    
}

@end
