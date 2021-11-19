//
//  ViewController.swift
//  PlayingCards
//
//  Created by Lorenzo Limoli on 17/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehaviour = CardBehaviour(in: animator)
    
    
    //    @IBOutlet weak var playingCardView: PlayingCardView!{
//        didSet{
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
//            swipe.direction = [.left, .right]
//            playingCardView.addGestureRecognizer(swipe)
//
//            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale))
//                playingCardView.addGestureRecognizer(pinch)
//        }
//    }
    
//    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
//        switch sender.state{
//        case .ended: playingCardView.isFaceUp = !playingCardView.isFaceUp
//        default: break
//        }
//    }
//
//    @objc func nextCard(){
//        if let card = deck.draw(){
//            playingCardView.rank = card.rank.order
//            playingCardView.suite = card.suite.rawValue
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        
        for _ in 0..<(cardViews.count + 1) / 2{
            guard let card = deck.draw() else{
                return
            }
            cards += [card, card]
        }
        
        for cv in cardViews{
            let card = cards.remove(at: cards.count.random_uniform)
            
            cv.isFaceUp = false
            cv.rank = card.rank.order
            cv.suite = card.suite.rawValue
            cv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehaviour.addItem(cv)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView]{
        return cardViews.filter{$0.isFaceUp && !$0.isHidden}
    }
    
    private var faceUpCardViewsMatch: Bool{
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
        faceUpCardViews[0].suite == faceUpCardViews[1].suite
    }

    @objc func flipCard(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state{
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView{
                cardBehaviour.removeItem(chosenCardView)
                UIView.transition(with: chosenCardView,
                                  duration: 0.4,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                                  completion: { finished in
                    if self.faceUpCardViewsMatch{
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.6,
                            delay: 0,
                            options: [],
                            animations: {
                                self.faceUpCardViews.forEach{
                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                }
                            },
                            completion: { position in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.75,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        self.faceUpCardViews.forEach{
                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                            $0.alpha = 0
                                        }
                                    },
                                    completion: { position in
                                        self.faceUpCardViews.forEach{
                                            $0.isHidden = true
                                            $0.alpha = 1
                                            $0.transform = .identity
                                        }
                                    }
                                )
                            }
                        )
                    }
                    else if self.faceUpCardViews.count == 2{
                        self.faceUpCardViews.forEach{ cardView in
                            UIView.transition(with: cardView,
                                              duration: 0.8,
                                              options: [.transitionFlipFromLeft],
                                              animations: {
                                cardView.isFaceUp = false
                            },
                                              completion: { finished in
                                self.cardBehaviour.addItem(cardView)
                            }
                            )
                        }
                    }else{
                        if !chosenCardView.isFaceUp{
                            self.cardBehaviour.addItem(chosenCardView)
                        }
                    }
                }
                )
            }
        default: break
        }
    }
}
