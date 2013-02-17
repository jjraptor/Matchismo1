//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by John Eigenbrode on 2/13/13.
//  Copyright (c) 2013 JJRaptor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index forMatchMode:(NSInteger)mode;;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;
@property (nonatomic, readonly) int lastMatchScore;
@property (readonly, strong, nonatomic) NSArray *lastMatchCards;

@end
