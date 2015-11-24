//
//  Bubbles2.swift
//  Example
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//

import UIKit
import SpriteKit

class Bubbles2: UIViewController {
    private var skView: SKView!
    private var floatingCollectionScene: BubblesScene!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        skView = SKView(frame: UIScreen.mainScreen().bounds)
        skView.backgroundColor = SKColor.whiteColor()
        view.addSubview(skView)
        
        floatingCollectionScene = BubblesScene(size: skView.bounds.size)
       let navBarHeight = CGRectGetHeight(navigationController!.navigationBar.frame)
        let statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
        
        floatingCollectionScene.topOffset = navBarHeight + statusBarHeight
        skView.presentScene(floatingCollectionScene)

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "commitSelection"
        )
        let lpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        lpgr.minimumPressDuration = 2.0;
        self.view.addGestureRecognizer(lpgr)
        
        var arrayOfTitles :[String] = ["Savings","Sources","Spendings","Savings","Sources","Spendingss"];
        var colors :[UIColor] = [UIColor.redColor(),UIColor.greenColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.greenColor(),UIColor.yellowColor()];

        for i in 0..<6 {
            let node = BubbleNode.instantiate(arrayOfTitles[i],color: BubbleNodeColor.Blue, value: 0.5)
            floatingCollectionScene.addChild(node)
           
        }
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)

    }
    
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        
        print("long press")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("shop") 
        self.navigationController?.pushViewController(vc, animated: true)


        
    }
    dynamic private func commitSelection() {
        floatingCollectionScene.performCommitSelectionAnimation()
    }
}

