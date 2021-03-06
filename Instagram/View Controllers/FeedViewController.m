//
//  FeedViewController.m
//  Instagram
//
//  Created by Rucha Patki on 7/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "FeedViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Parse.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailViewController.h"

#import "ProfileGridViewController.h"


@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *postArray;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int numTimes;


@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numTimes = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.postArray = [NSMutableArray array];
    [self getPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 130;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

-(void)loadMoreData{
    // construct query
    PFQuery *query = [Post query];
    [query orderByDescending:@"createdAt"];
    self.numTimes++;
    query.limit = self.numTimes * 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = posts;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.postArray[indexPath.row];
    cell.post = post;
    cell.delegate = self;
    [cell setCell];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postArray.count;
}


- (void)getPosts {
    // construct query
    PFQuery *query = [Post query];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = posts;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toDetail"]){
        
        //Need to put somewhere
        PostCell *tappedCell = sender;
        Post *post = tappedCell.post;
        
        //passing over movie that was tapped to the destination view controller
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = post;
    }
    
    else if([segue.identifier isEqualToString:@"toProfile"]){
        Post *post = sender;
        ProfileGridViewController *profileViewController = [segue destinationViewController];

        profileViewController.post = post;
    }
}


- (void)postCell:(PostCell *)postCell didTapUser:(Post *)post {
    [self performSegueWithIdentifier:@"toProfile" sender:post];
}


@end
