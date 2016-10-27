//
//  FLLTest2ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class FLLTest2ViewController: UIViewController {
    
    weak var tagTextField:UITextField!
    weak var flowLayout:TGFlowLayout!
    
    override func loadView() {
        
        /*
         这个例子用来介绍流式布局中的内容填充流式布局，主要用来实现标签流的功能。内容填充流式布局的每行的数量是不固定的，而是根据其内容的尺寸来自动换行。
         */

        
        let rootLayout = TGFlowLayout(.vert,arrangedCount:2)
        rootLayout.tg_arrangedGravity = TGGravity.vert.center
        rootLayout.tg_vspace = 4
        self.view = rootLayout
        
        
        let tempTagTextField = UITextField()
        tempTagTextField.placeholder = "input tag here"
        tempTagTextField.borderStyle = .roundedRect
        tempTagTextField.tg_left.equal(2)
        tempTagTextField.tg_top.equal(2)
        tempTagTextField.tg_height.equal(30)
        tempTagTextField.tg_width.equal(.fill)  //宽度占用剩余父视图宽度。
        rootLayout.addSubview(tempTagTextField)
        self.tagTextField = tempTagTextField
        
        let addTagButton = UIButton(type: .system)
        addTagButton.setTitle("Add Tag", for: .normal)
        addTagButton.addTarget(self, action: #selector(handleAddTag), for: .touchUpInside)
        addTagButton.sizeToFit()
        rootLayout.addSubview(addTagButton)
        
        let stretchSpacingLabel = UILabel()
        stretchSpacingLabel.text = "Stretch Spacing:"
        stretchSpacingLabel.tg_width.equal(.fill)
        stretchSpacingLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(stretchSpacingLabel)
        
        let stretchSpacingSwitch = UISwitch()
        stretchSpacingSwitch.addTarget(self, action: #selector(handleShrinkMargin), for: .valueChanged)
        rootLayout.addSubview(stretchSpacingSwitch)
        
        let stretchSizeLabel = UILabel()
        stretchSizeLabel.text = "Stretch Size:"
        stretchSizeLabel.tg_width.equal(.fill)
        stretchSizeLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(stretchSizeLabel)
        
        let stretchSizeSwitch = UISwitch()
        stretchSizeSwitch.addTarget(self, action: #selector(handleShrinkContent), for: .valueChanged)
        rootLayout.addSubview(stretchSizeSwitch)
        
        
        let autoArrangeLabel = UILabel()
        autoArrangeLabel.text = "Auto Arrange:"
        autoArrangeLabel.tg_width.equal(.fill)
        autoArrangeLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(autoArrangeLabel)
        
        let autoArrangeSwitch = UISwitch()
        autoArrangeSwitch.addTarget(self, action: #selector(handleShrinkAuto), for: .valueChanged)
        rootLayout.addSubview(autoArrangeSwitch)
        
        
        let flowLayout = TGFlowLayout()
        flowLayout.backgroundColor = UIColor.lightGray
        flowLayout.tg_space = 10
        flowLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.tg_width.equal(.fill)
        flowLayout.tg_height.equal(.fill)
        rootLayout.addSubview(flowLayout)
        self.flowLayout = flowLayout
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.createTagButton(NSLocalizedString("click to remove tag", comment:""))
        self.createTagButton(NSLocalizedString("tag2", comment:""))
        self.createTagButton(NSLocalizedString("TGLayout can used in XIB&SB", comment:""))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension FLLTest2ViewController
{
    
    func createTagButton(_ text:String)
    {
        let tagButton = UIButton()
        tagButton.setTitle(text,for:.normal)
        tagButton.layer.cornerRadius = 15;
        tagButton.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
        
        
        //这里可以看到尺寸宽度等于内容宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
        tagButton.tg_width.equal(.wrap, increment:10)
        tagButton.tg_width.lBound(40)
        tagButton.tg_height.equal(.wrap, increment:10) //高度等于自身内容的高度加10
        tagButton.addTarget(self,action:#selector(handleDelTag), for:.touchUpInside )
        self.flowLayout.addSubview(tagButton)
        
    }
    
    
    func handleAddTag(sender:Any!)
    {
        if let text = self.tagTextField.text
        {
            self.createTagButton(text)
            
            self.tagTextField.text = ""
            
            self.flowLayout.tg_layoutAnimationWithDuration(0.2)
        }
    }
    
    func handleShrinkMargin(sender:UISwitch!)
    {
        
        //间距拉伸
        if sender.isOn
        {
            self.flowLayout.tg_gravity = TGGravity.horz.fill //流式布局的tg_gravity如果设置为TGGravity.horz.fill表示子视图的间距会被拉伸，以便填充满整个布局。
        }
        else
        {
            self.flowLayout.tg_gravity = .none
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
    }
    
    func handleShrinkContent(sender:UISwitch!)
    {
        
        //内容拉伸
        if sender.isOn
        {
            self.flowLayout.tg_averageArrange = true  //对于内容填充的流时布局来说，tg_averageArrange属性如果设置为true表示里面的子视图的内容会自动的拉伸以便填充整个布局。
        }
        else
        {
            self.flowLayout.tg_averageArrange = false
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
        
    }
    
    func handleShrinkAuto(sender:UISwitch!)
    {
        
        //自动调整位置。
        if (sender.isOn)
        {
            self.flowLayout.tg_autoArrange = true  //tg_autoArrange属性会根据子视图的内容自动调整，以便以最合适的布局来填充布局。
        }
        else
        {
            self.flowLayout.tg_autoArrange = false
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
        
    }
    
    func handleDelTag(sender:UIButton!)
    {
        sender.removeFromSuperview()
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
    }
    
    
}
