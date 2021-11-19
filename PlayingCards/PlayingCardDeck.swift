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

extension Double{
    var random: Double{
        if self < 0.001{
            return 0
        }
        
        var range = [Double]()
        for v in stride(from: 0, to: abs(self), by: 0.1){
            range.append(v)
        }
        
        if self >= 0.0 {
            return range[range.count.random_uniform]
        }else{
            return -range[range.count.random_uniform]
        }
    }
}
