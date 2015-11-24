//
//  BubbleController.swift
//  Example
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//

import UIKit
import SpriteKit

class BubbleController: UIViewController, SIFloatingCollectionSceneDelegate {
    private var skView: SKView!
    private var floatingCollectionScene: BubblesScene!
    var mainArray: [BubbleNode]!
    var savingsArray: [BubbleNode]!
    var spendingArray: [BubbleNode]!
    var bucketArray: [BucketModel]!
    let nodeColor = UIColor(red:0.47, green:0.77, blue:0.88, alpha:1.0)
    var savingsValue, spendingValue, sourceValue: Float!
    var mainArrayOrder: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainArray = [BubbleNode]()
        savingsArray = [BubbleNode]()
        spendingArray = [BubbleNode]()
        bucketArray = [BucketModel]()
        mainArrayOrder = [String]()

        UserModel.currentUser().getAllInvestments { (investments, error) -> Void in
            var total: Float = 0.0
            var count: Float = 0.0
            for investment in investments {
                count = count + 1.0
                total = total + (investment as! InvestmentModel).currentValue().floatValue / (investment as! InvestmentModel).goal().floatValue
            }
            self.savingsValue = total / count
            self.addMainNode("Savings", value: CGFloat(self.savingsValue))
            self.mainArrayOrder.append("Savings")
        }
        
        UserModel.currentUser().getAllTransactions { (res, err) -> Void in
            var total: Float = 0.0
            var max: Float = 300.0
            var count: Float = 0.0
            for transaction in res {
                total = total + (transaction as! TransactionModel).amount()
                count = count + 1.0
            }
            self.spendingValue = (total / max)
            self.sourceValue = (max - total) / max
            self.addMainNode("Spending", value: CGFloat(self.spendingValue))
            self.mainArrayOrder.append("Spending")
            self.addMainNode("Source", value: CGFloat(self.sourceValue))
            self.mainArrayOrder.append("Source")
        }
        
//        UserModel.currentUser().getAllBuckets { (buckets, error) -> Void in
//            var total: Float = 0.0
//            var count: Float = 0.0
//            var max: Float = 0.0
//            for bucket in buckets {
//                self.bucketArray.append(bucket as! BucketModel)
//                count = count + 1.0
//                max = max + (bucket as! BucketModel).max().floatValue
//                total = total + (bucket as! BucketModel).amount().floatValue
//            }
//            self.spendingValue = (total / max) / count
//            self.sourceValue = (max - total) / max
//            self.addMainNode("Spending", value: CGFloat(self.spendingValue))
//            self.mainArrayOrder.append("Spending")
//            self.addMainNode("Source", value: CGFloat(self.sourceValue))
//            self.mainArrayOrder.append("Source")
//        }
        
        skView = SKView(frame: UIScreen.mainScreen().bounds)
        skView.backgroundColor = SKColor.whiteColor()
        view.addSubview(skView)
        
        floatingCollectionScene = BubblesScene(size: skView.bounds.size)
        let navBarHeight = CGRectGetHeight(navigationController!.navigationBar.frame)
        let statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
        floatingCollectionScene.topOffset = navBarHeight + statusBarHeight
        floatingCollectionScene.floatingDelegate = self

        skView.presentScene(floatingCollectionScene)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        let titleImgView = UIImageView(image: UIImage(named: "logo"))
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        titleImgView.frame = titleView.bounds
        titleView.addSubview(titleImgView)
        titleImgView.contentMode = UIViewContentMode.ScaleAspectFit
        self.navigationItem.titleView = titleImgView
        
        let leftButton: UIButton = UIButton(type: .Custom)
        leftButton.setImage(UIImage(named: "menu"), forState: UIControlState.Normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: "menuButtonSelected", forControlEvents: UIControlEvents.TouchDown)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightButton: UIButton = UIButton(type: .Custom)
        rightButton.setImage(UIImage(named: "profile"), forState: UIControlState.Normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.addTarget(self, action: "profileButtonSelected", forControlEvents: UIControlEvents.TouchDown)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("recognizePinchGesture:"))
        skView.addGestureRecognizer(pinchGesture)
      
    }
    
    func recognizePinchGesture(sender: UIPinchGestureRecognizer) {
        if (floatingCollectionScene.type != SIFloatingCollectionSceneType.Main) {
            removeAllNodes(floatingCollectionScene)
            addMainNodes()
            floatingCollectionScene.type = SIFloatingCollectionSceneType.Main
        }
    }
    
    func addMainNodes(){
        mainArrayOrder.append("Source")
        mainArrayOrder.append("Savings")
        mainArrayOrder.append("Spending")
        addMainNode("Source", value:CGFloat(self.sourceValue));
        addMainNode("Savings", value:CGFloat(self.savingsValue));
        addMainNode("Spending", value:CGFloat(self.spendingValue));
    }
    
    func addMainNode(title:String, value:CGFloat) {
        let node = BubbleNode.instantiate(title, color: BubbleNodeColor.Blue, value: value)
        floatingCollectionScene.addChild(node)
        mainArray.append(node)
    }
    
    func addSavingsNodes() {
        
        UserModel.currentUser().getAllInvestments { (investments, error) -> Void in
            for investment in investments {
                self.addSavingsNode((investment as! InvestmentModel).name(), value: CGFloat((investment as! InvestmentModel).currentValue().floatValue))
            }
        }
        
        savingsArray.append(BubbleNode.instantiate("Holiday",color: BubbleNodeColor.Blue, value: CGFloat(savingsValue)))
        savingsArray.append(BubbleNode.instantiate("+",color:BubbleNodeColor.Red, value: 1.0))
        for node in savingsArray {
            floatingCollectionScene.addChild(node)
        }
    }
    
    func addSavingsNode(title: String, value: CGFloat) {
        let node = BubbleNode.instantiate(title,color: BubbleNodeColor.Blue, value: CGFloat(value))
        floatingCollectionScene.addChild(node)
        savingsArray.append(node)
    }
    
    
    
    func addSpendingNodes() {
        UserModel.currentUser().getAllBuckets { (buckets, error) -> Void in
            for bucket in buckets {
                var total: Float = 0.0
                let max = (bucket as! BucketModel).max()
                (bucket as! BucketModel).getAllTransactions({ (res, err) -> Void in
                    for transaction in res {
                        total = total + (transaction as! TransactionModel).amount()
                    }
                    self.addSpendingNode((bucket as! BucketModel).name(), value: CGFloat(total / max.floatValue))
                })
                
            }
        }
    }
    
    func addSpendingNode(title: String, value: CGFloat) {
        let node = BubbleNode.instantiate(title,color: BubbleNodeColor.Blue, value: CGFloat(value))
        floatingCollectionScene.addChild(node)
        spendingArray.append(node)
    }
    
    func menuButtonSelected() {
        
    }
    
    func profileButtonSelected() {
        self.performSegueWithIdentifier("showProfileVC", sender: self)
    }
    
    dynamic private func commitSelection() {
        //code goes here
    }
    
    func removeAllNodes(scene: SIFloatingCollectionScene) {
        mainArray.removeAll()
        savingsArray.removeAll()
        spendingArray.removeAll()
        mainArrayOrder.removeAll()
        scene.removeAllFloatingNodes()
    }
    
    func floatingScene(scene: SIFloatingCollectionScene, didSelectFloatingNodeAtIndex index: Int) {
        print("before : \(scene.floatingNodes.count) nodes")
        if (scene.type == SIFloatingCollectionSceneType.Main) {
            let string = mainArrayOrder[index]
            switch(string) {
            case "Source":
                print("after : \(scene.floatingNodes.count) nodes")
            case "Savings":
                removeAllNodes(scene)
                print("after : \(scene.floatingNodes.count) nodes")
                addSavingsNodes()
                scene.type = SIFloatingCollectionSceneType.Savings
            case "Spending":
                removeAllNodes(scene)
                print("after : \(scene.floatingNodes.count) nodes")
                addSpendingNodes()
                scene.type = SIFloatingCollectionSceneType.Spendings
            default:
                print("default")
            }
        }
        
    }

    func randomFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    

}

