//
//  HomeViewController.swift
//  线程
//
//  Created by jps on 2020/8/27.
//  Copyright © 2020 jps. All rights reserved.
//

import UIKit



/// static 修饰的属性，可以直接当枚举用。 无论是class还是sturct
public class AAAA {
    
    public static let aaa: AAAA = AAAA()
    
    static var bbb: AAAA = AAAA()
    
}

//public func + (time: DispatchTime, seconds: Double) -> DispatchTime { return DispatchTime.now() }

//public static func + (lhs: Int, rhs: Int) -> Int

public func 加 (lhs: Int, rhs: Int) -> Int {
    return lhs + rhs
}



// Swift 4.0 高级-自定义操作符
//Swift 4.0 高级-自定义操作符 https://blog.csdn.net/yao1500/article/details/80003631

precedencegroup Precedence {
    lowerThan: AdditionPrecedence  // 优先级, 比加法运算低
    associativity: none  // 结合方向:left, right or none
    assignment: false    // true=赋值运算符,false=非赋值运算符
}


 // 继承 MyPrecedence 优先级组 (只能用操作符，不能用字母)
infix operator ++++++: Precedence
// infix operator +++: AdditionPrecedence // 也可以直接继承加法优先级组(AdditionPrecedence)或其他优先级组

func ++++++(left: Int, right: Int) -> Int {
    return left + right
}



class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        aaa(a: .bbb)
        
        
        //加(lhs: 1, rhs: 2)
        
        let s = 1 ++++++ 2
        
        print("自定义加法操作符, reuslt: \(s)")
    }
    
    
    
    func  aaa(a: AAAA) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //GCD
    @IBAction func gcdClicked(_ sender: Any) {
        let gcdVC = GCDViewController()
        self.navigationController?.pushViewController(gcdVC, animated: true)
    }
    
    
    //OperationQueue
    @IBAction func operationQueueClicked(_ sender: Any) {
    }
    
    
    //Thread
    @IBAction func threadClicked(_ sender: Any) {
    }
    
    
    
    
    
    
}
