//
//  PlayingCard.swift
//  PlayingCards
//
//  Created by Lorenzo Limoli on 17/11/21.
//

import Foundation

struct PlayingCard: CustomStringConvertible{
    enum Suite: String{
        case spades = "♠️"
        case hearts = "❤️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all: [Suite]{
            return [.spades, .hearts, .diamonds, .clubs]
        }
    }
    enum Rank: CustomStringConvertible{
        case ace
        case face(String)
        case numeric(Int)
        
        var description: String{
            switch self{
            case .ace: return "1"
            case .face(let kind): return kind
            case .numeric(let pips): return "\(pips)"
            }
        }
        
        var order: Int{
            switch self{
            case .ace: return 1
            case.numeric(let pips): return pips
            case.face(let kind) where kind == "J": return 11
            case.face(let kind) where kind == "Q": return 12
            case.face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank]{
            let numericRanks: [Rank] = Array(2...10).map{Rank.numeric($0)}
            let faceRanks: [Rank] = "JQK".map{Rank.face(String($0))}
            return [.ace] + numericRanks + faceRanks
        }
    }
    
    var suite: Suite
    var rank: Rank
    var description: String{
        return "\(rank)\(suite.rawValue)"
    }
}
