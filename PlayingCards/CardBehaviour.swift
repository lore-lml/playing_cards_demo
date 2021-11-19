//
//  CardBehaviour.swift
//  PlayingCards
//
//  Created by Lorenzo Limoli on 19/11/21.
//

import UIKit

class CardBehaviour: UIDynamicBehavior {

    lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour = UICollisionBehavior()
        behaviour.translatesReferenceBoundsIntoBoundary = true
        return behaviour
    }()
    
    lazy var itemBehaviour: UIDynamicItemBehavior = {
        let behaviour = UIDynamicItemBehavior()
        behaviour.allowsRotation = false
        behaviour.elasticity = 1.0
        behaviour.resistance = 0
        return behaviour
    }()
    
    private func push(_ item: UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*Double.pi).random
        push.magnitude = 1.0 + 2.0.random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem){
        collisionBehaviour.addItem(item)
        itemBehaviour.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem){
        collisionBehaviour.removeItem(item)
        itemBehaviour.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehaviour)
        addChildBehavior(itemBehaviour)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
