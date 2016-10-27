//
//  RLTest2ViewController.swift
//  TangramKit
//
//  Created by zhangguangkai on 16/5/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class RLTest2ViewController: UIViewController {

    weak var hiddenButton: UIButton!
    
    override func loadView()
    {
        /*
         这个例子展示的是相对布局里面 多个子视图按比例分配宽度或者高度的实现机制，通过对子视图扩展的TGLayoutSize尺寸对象的equal方法的值设置为一个数组对象，即可实现尺寸的按比例分配能力。而这个方法要比AutoLayout实现起来要简单的多。
         */
        
        let rootLayout = TGRelativeLayout()
        rootLayout.tg_padding = UIEdgeInsetsMake(0, 0, 0, 10)
        rootLayout.backgroundColor = .gray
        self.view = rootLayout
        
        let hiddenSwitch = UISwitch()
        hiddenSwitch.addTarget(self, action:#selector(handleSwitch), for: .valueChanged)
        hiddenSwitch.tg_right.equal(0)
        hiddenSwitch.tg_top.equal(10)
        rootLayout.addSubview(hiddenSwitch)
        
        let hiddenSwitchLabel = UILabel()
        hiddenSwitchLabel.text = NSLocalizedString("flex size when subview hidden switch:", comment:"")
        hiddenSwitchLabel.sizeToFit()
        hiddenSwitchLabel.tg_left.equal(10)
        hiddenSwitchLabel.tg_centerY.equal(hiddenSwitch.tg_centerY)
        rootLayout.addSubview(hiddenSwitchLabel)
        
        /**水平平分3个子视图**/
        let v1 = UIButton()
        v1.backgroundColor = .red
        v1.setTitle(NSLocalizedString("average 1/3 width\nturn above switch", comment:""), for: .normal)
        v1.titleLabel?.numberOfLines = 2
        v1.titleLabel?.adjustsFontSizeToFitWidth = true
        v1.titleLabel?.textAlignment = .center
        v1.tg_height.equal(40)
        v1.tg_top.equal(60)
        v1.tg_left.equal(10)
        rootLayout.addSubview(v1)
        
        let v2 = UIButton()
        v2.backgroundColor = .red
        v2.setTitle(NSLocalizedString("average 1/3 width\nhide me", comment:""), for:.normal)
        v2.addTarget(self, action: #selector(handleHidden), for: .touchUpInside)
        v2.titleLabel?.numberOfLines = 2
        v2.titleLabel?.adjustsFontSizeToFitWidth = true
        v2.titleLabel?.textAlignment = .center
        v2.tg_height.equal(v1.tg_height)
        v2.tg_top.equal(v1.tg_top)
        v2.tg_left.equal(v1.tg_right, offset:10)
        rootLayout.addSubview(v2)
        
        let v3 = UIButton()
        v3.backgroundColor = .red
        v3.setTitle(NSLocalizedString("average 1/3 width\nshow me", comment:""), for: .normal)
        v3.addTarget(self, action:#selector(handleShow), for: .touchUpInside)
        v3.titleLabel?.numberOfLines = 2
        v3.titleLabel?.adjustsFontSizeToFitWidth = true
        v3.titleLabel?.textAlignment = .center
        v3.tg_height.equal(v1.tg_height)
        v3.tg_top.equal(v1.tg_top)
        v3.tg_left.equal(v2.tg_right, offset:10)
        rootLayout.addSubview(v3)
        
        //v1,v2,v3平分父视图的宽度。因为每个子视图之间都有10的间距，因此平分时要减去这个间距值。这里的宽度通过设置等于数组来完成均分。
        v2.tg_width.add(-10)
        v3.tg_width.add(-10)
        v1.tg_width.equal([v2.tg_width,v3.tg_width], increment:-10)
        
        /**某个视图宽度固定其他平分**/
        let v4 = UILabel()
        v4.backgroundColor = .green
        v4.text = NSLocalizedString("width equal to 260", comment:"")
        v4.adjustsFontSizeToFitWidth = true
        v4.textAlignment = .center
        v4.tg_top.equal(v1.tg_bottom, offset:30)
        v4.tg_left.equal(10)
        v4.tg_height.equal(40)
        v4.tg_width.equal(160)  //第一个视图宽度固定
        rootLayout.addSubview(v4)
        
        let v5 = UILabel()
        v5.backgroundColor = .green
        v5.text = NSLocalizedString("1/2 with of free superview", comment:"")
        v5.adjustsFontSizeToFitWidth = true
        v5.textAlignment = .center
        v5.tg_top.equal(v4.tg_top)
        v5.tg_left.equal(v4.tg_right, offset:10)
        v5.tg_height.equal(v4.tg_height)
        rootLayout.addSubview(v5)
        
        let v6 = UILabel()
        v6.backgroundColor = .green
        v6.text = NSLocalizedString("1/2 with of free superview", comment:"")
        v6.adjustsFontSizeToFitWidth = true
        v6.textAlignment = .center
        v6.tg_top.equal(v4.tg_top)
        v6.tg_left.equal(v5.tg_right, offset:10)
        v6.tg_height.equal(v4.tg_height)
        rootLayout.addSubview(v6)
        
        //v4固定,v5,v6按一定的比例来平分父视图的宽度，这里同样也是因为每个子视图之间有间距，因此都要减10
        v4.tg_width.add(-10)
        v6.tg_width.add(-10)
        v5.tg_width.equal([v4.tg_width, v6.tg_width], increment:-10)
        
        /**子视图按比例平分**/
        let v7 = UILabel()
        v7.backgroundColor = UIColor.blue
        v7.text = NSLocalizedString("20% with of superview", comment:"")
        v7.adjustsFontSizeToFitWidth = true
        v7.textAlignment = .center
        v7.tg_top.equal(v4.tg_bottom, offset:30)
        v7.tg_left.equal(10)
        v7.tg_height.equal(40)
        rootLayout.addSubview(v7)
        
        let v8 = UILabel()
        v8.backgroundColor = UIColor.blue
        v8.text = NSLocalizedString("30% with of superview", comment:"")
        v8.adjustsFontSizeToFitWidth = true
        v8.textAlignment = .center
        v8.tg_top.equal(v7.tg_top)
        v8.tg_left.equal(v7.tg_right, offset:10)
        v8.tg_height.equal(v7.tg_height)
        rootLayout.addSubview(v8)
        
        let v9 = UILabel()
        v9.backgroundColor = UIColor.blue
        v9.text = NSLocalizedString("50% with of superview", comment:"")
        v9.adjustsFontSizeToFitWidth = true
        v9.textAlignment = .center
        v9.tg_top.equal(v7.tg_top)
        v9.tg_left.equal(v8.tg_right, offset:10)
        v9.tg_height.equal(v7.tg_height)
        rootLayout.addSubview(v9)
        
        //v7,v8,v9按照2：3：5的比例均分父视图。
        v8.tg_width.multiply(0.3)
        v8.tg_width.add(-10)
        v9.tg_width.multiply(0.5)
        v9.tg_width.add(-10)
        v7.tg_width.equal([v8.tg_width, v9.tg_width], increment:-10, multiple:0.2)
        
        
        /*
         下面部分是一个高度均分的实现方法。
         */
        let bottomLayout = TGRelativeLayout()
        bottomLayout.backgroundColor = UIColor.lightGray
        bottomLayout.tg_left.equal(10)
        bottomLayout.tg_right.equal(0)
        bottomLayout.tg_top.equal(v7.tg_bottom, offset:30)
        bottomLayout.tg_bottom.equal(10)
        rootLayout.addSubview(bottomLayout)
        
        let v10 = UIView()
        v10.backgroundColor = UIColor.red
        v10.tg_width.equal(40)
        v10.tg_right.equal(bottomLayout.tg_centerX, offset:50)
        v10.tg_top.equal(10)
        bottomLayout.addSubview(v10)
        
        let v11 = UIView()
        v11.backgroundColor = UIColor.red
        v11.tg_width.equal(v10.tg_width)
        v11.tg_right.equal(v10.tg_right)
        v11.tg_top.equal(v10.tg_bottom, offset:10)
        bottomLayout.addSubview(v11)

        //V10,V11实现了高度均分
        v11.tg_height.add(-20)
        v10.tg_height.equal([v11.tg_height], increment:-10)
        
        
        let v12 = UIView()
        v12.backgroundColor = UIColor.green
        v12.tg_width.equal(40)
        v12.tg_left.equal(bottomLayout.tg_centerX, offset:50)
        v12.tg_top.equal(10)
        bottomLayout.addSubview(v12)
        
        let v13 = UIView()
        v13.backgroundColor = UIColor.green
        v13.tg_width.equal(v12.tg_width)
        v13.tg_left.equal(v12.tg_left)
        v13.tg_top.equal(v12.tg_bottom,offset:10)
        bottomLayout.addSubview(v13)
        
        let v14 = UIView()
        v14.backgroundColor = UIColor.green
        v14.tg_width.equal(v12.tg_width)
        v14.tg_left.equal(v12.tg_left)
        v14.tg_top.equal(v13.tg_bottom, offset:10)
        bottomLayout.addSubview(v14)
        
        //注意这里最后一个偏移-20，也能达到和底部边距的效果。
        v13.tg_height.add(-10)
        v14.tg_height.add(-20)
        v12.tg_height.equal([v13.tg_height, v14.tg_height], increment:-10)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - Handle Method
extension RLTest2ViewController
{
    func handleSwitch(_ sender: UISwitch) {
 
        //tg_autoLayoutViewGroupWidth这个相对布局的属性表示当某个均分宽度的视图隐藏后，是否会激发剩余的子视图重新均分宽度。
        let rl = self.view as! TGRelativeLayout
        rl.tg_autoLayoutViewGroupWidth = !rl.tg_autoLayoutViewGroupWidth
    }
    
    func handleHidden(_ sender: UIButton) {
        
        sender.isHidden = true
        self.hiddenButton = sender
    }
    
    func handleShow(_ sender: UIButton) {
        
        if self.hiddenButton != nil {
            self.hiddenButton.isHidden = false
            self.hiddenButton = nil
        }
    }

}
