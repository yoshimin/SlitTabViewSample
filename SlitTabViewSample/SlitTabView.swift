//
//  TabView.swift
//  Practice
//
//  Created by Shingai Yoshimi on 12/8/15.
//  Copyright © 2015 Shingai Yoshimi. All rights reserved.
//

import UIKit

public class SlitTabView: UIControl {
    private let kSlitSize = CGSizeMake(12, 6)
    
    // 選択されているタブのインデックス
    var _selectedTabIndex = 0
    public var selectedTabIndex: Int {
        get {
            return _selectedTabIndex
        }
        set(index) {
            _selectedTabIndex = index
            
        }
    }
    
    var labels: [UILabel] = []
    var tabLayer: CAShapeLayer?
    var labelLayer: CAShapeLayer?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor()
        
        layer.masksToBounds = false
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowColor = UIColor.grayColor().CGColor;
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.6
    }
    
    // タブに表示する項目をセットする
    public func setItems(titles: [String]?) {
        labels.removeAll()
        
        for title in titles! {
            let label = UILabel.init()
            label.text = title
            label.textAlignment = .Center
            labels.append(label)
            
            addSubview(label)
        }
        
        setNeedsDisplay()
    }
    
    // タブに表示する項目を追加する
    public func insertItemWithTitle(title: String?, atIndex index: Int) {
        let label = UILabel.init()
        label.text = title
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        labels.insert(label, atIndex: index)
        
        addSubview(label)
        
        setNeedsDisplay()
    }
    
    // タブに表示されているタイトルを取得する
    public func titleForItemAtIndex(index: Int) -> String? {
        return labels[index].text
    }
    
    // selectedTabIndexに応じて切れ込みが入ったタブの描画用のパスを返す
    func tabLayerPath() -> CGPathRef {
        let maskPath = UIBezierPath()
        
        if labels.count == 0 {
            return maskPath.CGPath
        }
        
        let tabWidth = frame.width / CGFloat(labels.count)
        let origin = CGPointZero
        let bottomLeft = CGPointMake(origin.x, frame.height)
        let slitLeft = CGPointMake(tabWidth * (CGFloat(selectedTabIndex) + 0.5) - kSlitSize.width * 0.5, bottomLeft.y)
        let slitTop = CGPointMake(slitLeft.x + kSlitSize.width * 0.5, slitLeft.y - kSlitSize.height)
        let slitRight = CGPointMake(slitLeft.x + kSlitSize.width, slitLeft.y)
        let bottomRight = CGPointMake(frame.width, bottomLeft.y)
        let topRigiht = CGPointMake(bottomRight.x, origin.y)
        
        maskPath.moveToPoint(origin)
        maskPath.addLineToPoint(bottomLeft)
        maskPath.addLineToPoint(slitLeft)
        maskPath.addLineToPoint(slitTop)
        maskPath.addLineToPoint(slitRight)
        maskPath.addLineToPoint(bottomRight)
        maskPath.addLineToPoint(topRigiht)
        maskPath.addLineToPoint(origin)
        
        return maskPath.CGPath
    }
    
    // selectedTabIndexに応じてラベルの描画用のパスを返す
    func labelLayerPath() -> CGPathRef {
        let maskPath = UIBezierPath()
        
        if labels.count == 0 {
            return maskPath.CGPath
        }
        
        let tabWidth = frame.width / CGFloat(labels.count)
        let origin = CGPointMake(tabWidth * CGFloat(selectedTabIndex), 0)
        let bottomLeft = CGPointMake(origin.x, frame.height)
        let slitLeft = CGPointMake(bottomLeft.x + (tabWidth - kSlitSize.width) * 0.5, bottomLeft.y)
        let slitTop = CGPointMake(slitLeft.x + kSlitSize.width * 0.5, slitLeft.y - kSlitSize.height)
        let slitRight = CGPointMake(slitLeft.x + kSlitSize.width, slitLeft.y)
        let bottomRight = CGPointMake(origin.x + tabWidth, bottomLeft.y)
        let topRigiht = CGPointMake(bottomRight.x, origin.y)
        
        maskPath.moveToPoint(origin)
        maskPath.addLineToPoint(bottomLeft)
        maskPath.addLineToPoint(slitLeft)
        maskPath.addLineToPoint(slitTop)
        maskPath.addLineToPoint(slitRight)
        maskPath.addLineToPoint(bottomRight)
        maskPath.addLineToPoint(topRigiht)
        maskPath.addLineToPoint(origin)
        
        return maskPath.CGPath
    }
    
    func moveSlit(animated: Bool) {
        if animated {
            self.setLabelsFont()
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 0.25
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            // completion処理用に、アニメーションが終了しても登録を残しておく
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.tabLayer?.path = self.tabLayerPath()
                self.labelLayer?.path = self.labelLayerPath()
            })
            
            animation.toValue = tabLayerPath()
            tabLayer?.addAnimation(animation, forKey: "tabAnimation")
            
            animation.toValue = labelLayerPath()
            labelLayer?.addAnimation(animation, forKey: "labelAnimation")
            
            CATransaction.commit()
            return
        }
        
        tabLayer?.path = tabLayerPath()
        labelLayer?.path = labelLayerPath()
        setLabelsFont()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLabelsFrame()
        setLabelsFont()
        
        tabLayer?.removeFromSuperlayer()
        
        tabLayer = CAShapeLayer()
        tabLayer?.fillColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1).CGColor
        tabLayer?.path = tabLayerPath()
        layer.insertSublayer(tabLayer!, atIndex: 0)
        
        labelLayer?.removeFromSuperlayer()
        
        labelLayer = CAShapeLayer()
        labelLayer?.fillColor = UIColor.whiteColor().CGColor
        labelLayer?.path = labelLayerPath()
        layer.insertSublayer(labelLayer!, above: tabLayer)
    }
    
    func setLabelsFrame() {
        if labels.count == 0 {
            return;
        }
        
        let tabSize = CGSizeMake(frame.width/CGFloat(labels.count), frame.height);
        
        for (index, label) in labels.enumerate() {
            label.frame = CGRectMake(tabSize.width*CGFloat(index), 0, tabSize.width, tabSize.height);
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first?.locationInView(self)
        
        for (index, label) in labels.enumerate() {
            if CGRectContainsPoint(label.frame, location!) {
                selectedTabIndex = index
            }
        }
        moveSlit(true)
        
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func setLabelsFont() {
        for (index, label) in labels.enumerate() {
            if index == selectedTabIndex {
                label.font = UIFont.boldSystemFontOfSize(18)
                label.textColor = UIColor.blackColor()
            } else {
                label.font = UIFont.systemFontOfSize(18)
                label.textColor = UIColor.darkGrayColor()
            }
        }
    }
}
