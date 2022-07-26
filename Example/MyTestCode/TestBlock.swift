//
//  TestBlock.swift
//  MyTestCode_Example
//
//  Created by 徐东伟 on 2022/4/12.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation



public typealias TestReturnBlock = () -> Bool


/**
 闭包表达式语法
 { (parameters) -> (return type) in
     statements
 }
 
 */


func someFunctionThatTakesAClosure(closure:() -> Void){
    
    
    print("someFunctionThatTakesAClosure")
    closure()
  }

func testBlockFun(){
    
    let names = ["a","b","c"]
    
    func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    
    var sortNames = names.sorted(by: backward)
    print(sortNames)
    
    sortNames = names.sorted(by: { (s1,s2) -> Bool  in
        return s1 > s2
    })
    print(sortNames)
    
    sortNames = names.sorted(by: { s1, s2 in
        return s1 > s2
    })
    
    sortNames = names.sorted(by: { $0 > $1 })
    print(sortNames)
    
    
    /**
     运算符函数
     实际上还有一种更简短的方式来撰写上述闭包表达式。Swift 的 String 类型定义了关于大于号（ >）的特定字符串实现，让其作为一个有两个 String 类型形式参数的函数并返回一个 Bool 类型的值。这正好与  sorted(by:) 方法的第二个形式参数需要的函数相匹配。因此，你能简单地传递一个大于号，并且 Swift 将推断你想使用大于号特殊字符串函数实现
     */
    
    sortNames = names.sorted(by: > )
    print(sortNames)
    
    
    someFunctionThatTakesAClosure {
        print("closure")
        
    }
    
    

    
}
