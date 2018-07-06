//
//  AnimationEngine.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    private var layoutConstraints: [NSLayoutConstraint] = []
    
    init(layoutConstraints: [NSLayoutConstraint]) {
        self.layoutConstraints = layoutConstraints
    }
    
    /// define coordinates of centre-screen, off-screen-right and off-screen-left positions for display objects
    
    var screenCenterPosition: CGPoint {
        return CGPoint(x: 0.0, y: UIScreen.main.bounds.midY)
    }
    
    var offScreenRightPosition: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.width * 1.5, y: UIScreen.main.bounds.midY)
    }
    
    var offScreenLeftPosition: CGPoint {
        return CGPoint(x: -UIScreen.main.bounds.width * 1.5, y: UIScreen.main.bounds.midY)
    }
    
    func setOffScreenLeft() {
        var index = 0
        for _ in self.layoutConstraints {
            self.layoutConstraints[index].constant = offScreenLeftPosition.x
            index += 1
        }
    }
    
    func setOffScreenRight() {
        var index = 0
        for _ in self.layoutConstraints {
            self.layoutConstraints[index].constant = offScreenRightPosition.x
            index += 1
        }
    }
    
    func animateOffScreenLeft() {
        var index = 0
        for _ in self.layoutConstraints {
            
            // set up animation
            let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            moveAnim?.springBounciness = Constants.SPRING_BOUNCINESS
            moveAnim?.springSpeed = Constants.SPRING_SPEED
            moveAnim?.toValue = self.offScreenLeftPosition.x
            
            // apply to constsraint
            let conToAnimate = self.layoutConstraints[index]
            conToAnimate.pop_add(moveAnim, forKey: "moveToNewPosition")
            index += 1
        }
    }
    
    func animateOffScreenRight() {
        var index = 0
        for _ in self.layoutConstraints {
            
            // set up animation
            let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            moveAnim?.springBounciness = Constants.SPRING_BOUNCINESS
            moveAnim?.springSpeed = Constants.SPRING_SPEED
            moveAnim?.toValue = self.offScreenRightPosition.x
            
            // apply to constsraint
            let conToAnimate = self.layoutConstraints[index]
            conToAnimate.pop_add(moveAnim, forKey: "moveToNewPosition")
            index += 1
        }
    }
    
    func animateOnFromScreenLeft(){
        var index = 0
        for _ in self.layoutConstraints {
            let conToAnimate = self.layoutConstraints[index]
            
            // ensure initial position is at screen left
            conToAnimate.constant = self.offScreenLeftPosition.x
            
            // set up animation
            let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            moveAnim?.springBounciness = Constants.SPRING_BOUNCINESS
            moveAnim?.springSpeed = Constants.SPRING_SPEED
            moveAnim?.toValue = self.screenCenterPosition.x
            
            // apply to constsraint
            conToAnimate.pop_add(moveAnim, forKey: "moveToNewPosition")
            index += 1
        }
    }
    
    func animateOnFromScreenRight() {
        var index = 0
        for _ in self.layoutConstraints {
            let conToAnimate = self.layoutConstraints[index]
            
            // ensure initial position is at screen right
            conToAnimate.constant = self.offScreenRightPosition.x
            
            // set up animation
            let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            moveAnim?.springBounciness = Constants.SPRING_BOUNCINESS
            moveAnim?.springSpeed = Constants.SPRING_SPEED
            moveAnim?.toValue = self.screenCenterPosition.x
            
            // apply to constsraint
            conToAnimate.pop_add(moveAnim, forKey: "moveToNewPosition")
            index += 1
        }
    }
    
    static func animate(constraint: NSLayoutConstraint, by amount: CGFloat){
        
        // set up animation
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        moveAnim?.springBounciness = Constants.SPRING_BOUNCINESS
        moveAnim?.springSpeed = Constants.SPRING_SPEED
        moveAnim?.toValue = constraint.constant + amount
        
        // apply to constsraint
        constraint.pop_add(moveAnim, forKey: "moveToNewPosition")
    }
    
    
    
}
