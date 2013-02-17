//
//  PlayingCard.h
//  Matchismo
//
//  Created by John Eigenbrode on 2/13/13.
//  Copyright (c) 2013 JJRaptor. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
