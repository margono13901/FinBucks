//
//  BubbleNode.swift
//  Example
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

enum BubbleNodeColor {
    case Red
    case Blue
}

class Circle : SKSpriteNode {
    var fillSprite : SKSpriteNode!
    var cropNode : SKCropNode!
    var maskNode : SKSpriteNode!
    var lightColor: UIColor!
    var darkColor: UIColor!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        if (color == UIColor.redColor()) {
            fillSprite = SKSpriteNode(imageNamed: "redcircle")
        } else if (color == UIColor.blueColor()) {
            fillSprite = SKSpriteNode(imageNamed: "bluecircle")
        }
        
        maskNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.size.width, height: self.size.height))
        maskNode.position.y -= self.size.height/2
        cropNode = SKCropNode()
        cropNode.addChild(fillSprite)
        cropNode.maskNode = maskNode
        cropNode.zPosition = 1
        self.addChild(cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFillAmount(amount: CGFloat) {
        // amount parameter must be float value between 0.0 and 1.0
        let newHeight = amount * (self.size.height*2)
        maskNode.size = CGSize(width: self.size.width, height: newHeight)
    }
    
}

class BubbleNode: SIFloatingNode {
    
    var labelNode = SKLabelNode(fontNamed: "Avenir-Black")
    
    class func instantiate(name:String,color:BubbleNodeColor, value: CGFloat) -> BubbleNode! {
        let node = BubbleNode(circleOfRadius: 75)
        configureNode(node, andName: name,color:color, value: value)
        return node
    }
    
    class func configureNode(node: BubbleNode!, andName:String,color:BubbleNodeColor, value: CGFloat) {
        let boundingBox = CGPathGetBoundingBox(node.path);
        let radius = boundingBox.size.width / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        
        var circle: Circle?
        
        if (color == .Red) {
            circle = Circle(texture: SKTexture(imageNamed: "lightredcircle"), color: UIColor.redColor(), size: CGSize(width: radius * 2, height: radius * 2))
        } else if (color == .Blue) {
            circle = Circle(texture: SKTexture(imageNamed: "lightbluecircle"), color: UIColor.blueColor(), size: CGSize(width: radius * 2, height: radius * 2))
        }
        
        circle!.setFillAmount(value)
        circle!.zPosition = -1
        node.addChild(circle!)
        
        node.labelNode.text = andName
        node.labelNode.position = CGPointZero
        node.labelNode.fontColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        node.labelNode.fontSize = 25
        node.labelNode.userInteractionEnabled = false
        node.labelNode.verticalAlignmentMode = .Center
        node.labelNode.horizontalAlignmentMode = .Center
        node.zPosition = 1
        node.addChild(node.labelNode)
    }
    
    override func selectingAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.scaleTo(1.3, duration: 0.2)
    }
    
    override func normalizeAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.scaleTo(1, duration: 0.2)
    }
    
    override func removeAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.fadeOutWithDuration(0.2)
    }
    
    override func removingAnimation() -> SKAction {
        let pulseUp = SKAction.scaleTo(xScale + 0.13, duration: 0)
        let pulseDown = SKAction.scaleTo(xScale, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        return repeatPulse
    }
}