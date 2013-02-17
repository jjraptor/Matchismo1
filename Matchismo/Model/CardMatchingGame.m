//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by John Eigenbrode on 2/13/13.
//  Copyright (c) 2013 JJRaptor. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGame()
@property (strong, nonatomic)NSMutableArray *cards;
// Make public readonly properties privately readwrite
@property (readwrite, nonatomic) int score; 
@property (readwrite, nonatomic) int lastMatchScore;
@property (readwrite, strong, nonatomic) NSArray *lastMatchCards;
@end

@implementation CardMatchingGame

- (NSMutableArray*)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// Designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index forMatchMode:(NSInteger)mode
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        self.lastMatchCards = @[card];
        if (!card.isFaceUp) {
            self.lastMatchScore = 0;
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            
            // see if flipping this card creates a match
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    // if found add to array of cards to match
                    [otherCards addObject:otherCard];
                }
                if ([otherCards count] == mode -1){
                    // Do we have cards?
                    if (otherCards.count) {
                        int matchScore = [card match:@[otherCard]];
                        self.lastMatchCards = [self.lastMatchCards arrayByAddingObjectsFromArray:otherCards];
                        if (matchScore) {
                            card.unplayable = YES;
                            for (Card *card in otherCards) {
                                card.unplayable = YES;
                            }
                            self.lastMatchScore += matchScore * MATCH_BONUS;
                        } else {
                            otherCard.faceUp = NO;
                            self.lastMatchScore = -MISMATCH_PENALTY;
                        }
                        break;
                    }
                }
            }
            self.score = self.lastMatchScore -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
