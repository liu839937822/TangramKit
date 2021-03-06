//
//  FLLTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class FLLTest3ViewController: UIViewController {

    weak var flowLayout: TGFlowLayout!
    var oldIndex: Int = 0
    var currentIndex: Int = 0
    var hasDrag: Bool = false
    weak var addButton: UIButton!
    
    override func loadView() {
        
        /*
         这个例子用来介绍布局视图对动画的支持，以及通过布局视图的autoresizesSubviews属性，以及子视图的扩展属性tg_useFrame和tg_noLayout来实现子视图布局的个性化设置。
         
         布局视图的autoresizesSubviews属性用来设置当布局视图被激发要求重新布局时，是否会对里面的所有子视图进行重新布局。
         子视图的扩展属性tg_useFrame表示某个子视图不受布局视图的布局控制，而是用最原始的frame属性设置来实现自定义的位置和尺寸的设定。
         子视图的扩展属性tg_noLayout表示某个子视图会参与布局，但是并不会正真的调整布局后的frame值。
         
         */

        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_gravity = TGGravity.horz.fill
        self.view = rootLayout
        
        let tipLabel = UILabel()
        tipLabel.font = .systemFont(ofSize: 13)
        tipLabel.text = NSLocalizedString("  You can drag the following tag to adjust location in layout, MyLayout can use subview's useFrame,noLayout property and layout view's autoresizesSubviews propery to complete some position adjustment and the overall animation features: \n useFrame set to YES indicates subview is not controlled by the layout view but use its own frame to set the location and size instead.\n \n autoresizesSubviews set to NO indicate layout view will not do any layout operation, and will remain in the position and size of all subviews.\n \n noLayout set to YES indicate subview in the layout view just only take up the position and size but not real adjust the position and size when layouting.", comment: "")
        tipLabel.numberOfLines = 0
        tipLabel.tg_height.equal(.wrap)  //高度动态确定。
        rootLayout.addSubview(tipLabel)
        
        let tip2Label = UILabel()
        tip2Label.text = NSLocalizedString("double click to remove tag", comment: "")
        tip2Label.font = .systemFont(ofSize: 13)
        tip2Label.textColor = .lightGray
        tip2Label.textAlignment = .center
        tip2Label.sizeToFit()
        tip2Label.tg_top.equal(3)
        rootLayout.addSubview(tip2Label)
        
        let flowLayout = TGFlowLayout.init(.vert, arrangedCount: 4)
        flowLayout.backgroundColor = .lightGray
        flowLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.tg_space = 10  //流式布局里面的子视图的水平和垂直间距设置为10
        flowLayout.tg_averageArrange = true  //流式布局里面的子视图的宽度将平均分配。
        flowLayout.tg_height.equal(.fill) //占用剩余的高度。
        flowLayout.tg_top.equal(10)
        rootLayout.addSubview(flowLayout)
        self.flowLayout = flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...10 {
            let label = NSLocalizedString("drag me \(index)", comment: "")
            self.flowLayout.addSubview(self.createTagButton(text: label))
        }
        
        //最后添加添加按钮。
        let addButton = self.createAddButton()
        self.flowLayout.addSubview(addButton)
        self.addButton = addButton
    }
    
    //创建标签按钮
    internal func createTagButton(text: String) -> UIButton {
        let tagButton = UIButton()
        tagButton.setTitle(text, for: .normal)
        tagButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tagButton.layer.cornerRadius = 20
        tagButton.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        tagButton.tg_height.equal(44)
        tagButton.addTarget(self, action: #selector(handleTouchDrag(sender:event:)), for: .touchDragInside) //注册拖动事件。
        tagButton.addTarget(self, action: #selector(handleTouchDown(sender:event:)), for: .touchDown) //注册按下事件
        tagButton.addTarget(self, action: #selector(handleTouchUp), for: .touchUpInside)  //注册抬起事件
        tagButton.addTarget(self, action: #selector(handleTouchDownRepeat(sender:event:)), for: .touchDownRepeat) //注册多次点击事件
        return tagButton;
    }
    
    //创建添加按钮
    private func createAddButton() -> UIButton {
        let addButton = UIButton()
        addButton.setTitle(NSLocalizedString("add tag", comment: ""), for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        addButton.setTitleColor(UIColor.blue, for: .normal)
        addButton.layer.cornerRadius = 20
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.red.cgColor
        addButton.tg_height.equal(44)
        addButton.addTarget(self, action: #selector(handleAddTagButton(sender:)), for: .touchUpInside)
        return addButton
    }
}

extension FLLTest3ViewController {
    func handleAddTagButton(sender: AnyObject) {
        let label = NSLocalizedString("drag me \(self.flowLayout.subviews.count-1)", comment: "")
        self.flowLayout.insertSubview(self.createTagButton(text: label), at: self.flowLayout.subviews.count-1)
    }
    
    func handleTouchDrag(sender: UIButton, event: UIEvent) {
        self.hasDrag = true
        
        let touch: UITouch = (event.touches(for: sender)! as NSSet).anyObject() as! UITouch
        let pt = touch.location(in: self.flowLayout)
        
        //判断当前手指在具体视图的位置。这里要排除self.addButton的位置。
        var sbv2: UIView!
        for sbv: UIView in self.flowLayout.subviews  {
            if sbv != sender && sender.tg_useFrame && sbv != self.addButton {
                let rect1 = sbv.frame
                if rect1.contains(pt) {
                    sbv2 = sbv
                    break
                }
            }
        }
        
        if sbv2 != nil {
            self.flowLayout.tg_layoutAnimationWithDuration(0.2)
            
            //得到要移动的视图的位置索引。
            self.currentIndex = self.flowLayout.subviews.index(of: sbv2)!
            if self.oldIndex != self.currentIndex {
                self.oldIndex = self.currentIndex
            }
            else {
                self.currentIndex = self.oldIndex + 1
            }
            
            //因为sender在bringSubviewToFront后变为了最后一个子视图，因此要调整正确的位置。
            for index in ((self.currentIndex + 1)...self.flowLayout.subviews.count-1).reversed() {
                self.flowLayout.exchangeSubview(at: index, withSubviewAt: index-1)
            }
            
            self.flowLayout.autoresizesSubviews = true
            sender.tg_useFrame = false
            sender.tg_noLayout = true //这里设置为true表示布局时不会改变sender的真实位置而只是在布局视图中占用一个位置和尺寸，正是因为只是占用位置，因此会调整其他视图的位置。
            
            self.flowLayout.layoutIfNeeded()
        }
        
        
        //在进行sender的位置调整时，要把sender移动到最顶端，也就子视图数组的的最后，这时候布局视图不能布局，因此要把autoresizesSubviews设置为false，同时因为要自定义
        //sender的位置，因此要把tg_useFrame设置为true，并且恢复tg_noLayout为false。

        self.flowLayout.bringSubview(toFront: sender)
        self.flowLayout.autoresizesSubviews = false
        sender.tg_useFrame = true
        sender.tg_noLayout = false
        sender.center = pt  //因为tg_useFrame设置为了YES所有这里可以直接调整center，从而实现了位置的自定义设置。
    }
    
    func handleTouchDown(sender: UIButton, event: UIEvent) {
        self.oldIndex = self.flowLayout.subviews.index(of: sender)!
        self.currentIndex = self.oldIndex
        self.hasDrag = false
    }
    
    func handleTouchUp(sender: UIButton, event: UIEvent) {
        if !self.hasDrag {
            return
        }
        
        sender.tg_useFrame = false
        self.flowLayout.autoresizesSubviews = true
        
        for index in ((self.currentIndex+1)...(self.flowLayout.subviews.count-1)).reversed() {
            self.flowLayout.exchangeSubview(at: index, withSubviewAt: index-1)
        }
    }
    
    func handleTouchDownRepeat(sender: UIButton, event: UIEvent) {
        sender.removeFromSuperview()
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
    }
}
