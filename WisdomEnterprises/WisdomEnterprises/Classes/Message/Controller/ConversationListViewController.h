//
//  ConversationListViewController.h
//  WisdomEnterprises
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "EaseConversationListViewController.h"

@interface ConversationListViewController : EaseConversationListViewController

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
