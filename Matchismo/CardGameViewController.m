//
//  CardGameViewController.m
//  Matchismo
//
//  Created by John Eigenbrode on 2/12/13.
//  Copyright (c) 2013 JJRaptor. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic) BOOL cardHasBeenFlipped;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSString *resultsString;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (nonatomic) NSUInteger matchMode;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *modeSwitchLabel;
@property (strong, nonatomic) NSMutableArray *playHistory;
@property (weak, nonatomic) IBOutlet UISlider *resultsSlider;
@property (nonatomic) NSUInteger rank;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game  // Lazy instantiation of game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (NSMutableArray *)playHistory
{
    if (!_playHistory) _playHistory = [[NSMutableArray alloc] init];
    return _playHistory;
}

- (NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][_rank];
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (NSString *)resultsString
 {
 if (!_resultsString) _resultsString = @"No cards have been flipped!";
 return _resultsString;
 }

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        // Set card back to UIImage
        if (!cardButton.isSelected) [cardButton setImage:[UIImage imageNamed:@"Penquin.jpg"] forState:UIControlStateNormal];
        else [cardButton setImage:nil forState:UIControlStateNormal];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultsLabel.alpha = 1.0;
    [self updateResultsString];
    self.resultsSlider.maximumValue = self.flipCount+0.9;
    //self.resultsLabel.text = [NSString stringWithFormat:@"%@", self.resultsString];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] forMatchMode:(NSInteger)self.matchMode];
    NSLog(@"%d", self.matchMode);
    self.flipCount++;
    if (!self.cardHasBeenFlipped) {
        self.cardHasBeenFlipped = YES;
        self.modeSwitch.enabled = NO;
        self.modeSwitch.hidden = YES;
        self.modeSwitchLabel.hidden = YES;
        self.resultsSlider.hidden = NO;
    }
    [self updateUI];
}

- (IBAction)dealNewDeck:(UIButton *)sender
{
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
    [self updateUI];
    self.flipCount = 0;
    self.cardHasBeenFlipped = NO;
    self.modeSwitch.enabled = YES;
    self.modeSwitch.hidden = NO;
    self.modeSwitchLabel.hidden = NO;
    self.resultsSlider.hidden = YES;
    
    self.resultsLabel.text = [NSString stringWithFormat:@"New Game"];
}

- (IBAction)toggleMatchMode:(UISwitch *)sender
{
    if (sender.on) {
        self.matchMode = 3;
    } else {
        self.matchMode = 2;
    }
}

- (NSString *)textForCardFlip
{
    PlayingCard *card = [self.game.lastMatchCards lastObject];
    _rank = card.rank;
    return [NSString stringWithFormat:@"%@%@ flipped %@",[self rankAsString], card.suit,(card.faceUp) ? @"up!" : @"back!"];
}

- (void)updateResultsString
{
    if (self.game.lastMatchCards) {
        NSString *text;
        if ([self.game.lastMatchCards count]>1) {
            if (self.game.lastMatchScore<0) {
                text = [NSString stringWithFormat:@"don't match! (%d penalty)",self.game.lastMatchScore];
            } else {
                text = [NSString stringWithFormat:@"match! %d points bonus",self.game.lastMatchScore];
            }
        } else
            text = [self textForCardFlip];
        self.resultsLabel.text = text;
        [self.playHistory addObject:text];
    } else
        self.resultsLabel.text = [[NSString alloc] initWithFormat:@"Play!"];
}

- (IBAction)browsePlayHistory:(UISlider *)sender
{
    if (self.flipCount) {
     self.resultsLabel.alpha = 0.5;
    int index = sender.value;
    if (index) self.resultsLabel.text = [self.playHistory objectAtIndex:index -1];
    }
}




- (void)viewDidLoad
{
    self.resultsSlider.hidden = YES;
    if (self.modeSwitch.on) {
        self.matchMode = 3;
    } else {
        self.matchMode = 2;
    }
}


@end
