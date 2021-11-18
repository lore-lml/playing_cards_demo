//
//  PlayingCardDeck.swift
//  PlayingCards
//
//  Created by Lorenzo Limoli on 17/11/21.
//

import Foundation

struct PlayingCardDeck{
    private(set) var cards = [PlayingCard]()
    
    init(){
        for suite in PlayingCard.Suite.all{
            cards += PlayingCard.Rank.all.map{PlayingCard(suite: suite, rank: $0)}
        }
    }
    
    mutating func draw() -> PlayingCard?{
        if cards.count > 0{
            return cards.remove(at: cards.count.random_uniform)
        }
        return nil
    }
}

extension Int{
    var random_uniform: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        return 0
    }
}
