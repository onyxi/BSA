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
    
    // Properties:
    private var layoutConstraints: [NSLayoutConstraint] = [] // used to hold set of layout constraints to be animated
    
    // Custom initialiser
    init(layoutConstraints: [NSLayoutConstraint]) {
        self.layoutConstraints = layoutConstraints
    }
    
    /// define coordinates of centre-screen, off-screen-right and off-screen-left positions for the costrained view
    var screenCenterPosition: CGPoint {
            return CGPoint(x: 0.0, y: UIScreen.main.bounds.midY)
        }
    var offScreenRightPosition: CGPoint {
            return CGPoint(x: UIScreen.main.bounds.width * 1.5, y: UIScreen.main.bounds.midY)
        }
    var offScreenLeftPosition: CGPoint {
            return CGPoint(x: -UIScreen.main.bounds.width * 1.5, y: UIScreen.main.bounds.midY)
        }
    
    
    // Places position of the constrained view to off-screen-left
    func setOffScreenLeft() {
        var index = 0
        for _ in self.layoutConstraints {
            self.layoutConstraints[index].constant = offScreenLeftPosition.x
            index += 1
        }
    }
    
    // Places position of the constrained view to off-screen-right
    func setOffScreenRight() {
        var index = 0
        for _ in self.layoutConstraints {
            self.layoutConstraints[index].constant = offScreenRightPosition.x
            index += 1
        }
    }
    
    // Animates constrained the view to off-screen-left position
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
    
    // Animates constrained the view to off-screen-right position
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
    
    // Animates constrained view to on-screen centre position from off-screen-left position
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
    
    // Animates constrained view to on-screen centre position from off-screen-right position
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
    
    // Animates a given constraint's 'constant' value to another given value
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
