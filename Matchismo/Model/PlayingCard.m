//
//  PlayingCard.m
//  Matchismo
//
//  Created by John Eigenbrode on 2/13/13.
//  Copyright (c) 2013 JJRaptor. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int suitMatch = 0;
    int rankMatch = 0;
    
    if (otherCards.count) {
        for (PlayingCard *otherCard in otherCards) {
            if ([otherCard.suit isEqualToString:self.suit]) {
                suitMatch++;
            } else if (otherCard.rank == self.rank) {
                rankMatch++;
            }
        }
        
        if (suitMatch == otherCards.count)
            score = 1 * otherCards.count;
        else if (rankMatch == otherCards.count)
            score = 4 * otherCards.count;
    }
    return score;
}

@synthesize suit = _suit; // Have to synthesize since we are providing setter AND getter

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦", @"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count -1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)description
{
    return self.contents;
}




@end
