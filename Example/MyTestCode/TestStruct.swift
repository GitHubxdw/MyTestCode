//
//  TestStruct.swift
//  MyTestCode_Example
//
//  Created by 徐东伟 on 2022/4/12.
//  Copyright © 2022 CocoaPods. All rights reserved.
//
import Foundation
/**
 struct和class区别
 class是引用类型，当值传递的时候，它是传递对已有instance的引用
 struct是值类型，当值进行传递的时候，它会copy传递的值
 
 struct存储在stack(堆)中，class存储在heap(栈)中，struct更快
 
 
 class是引用类型；struct是值类型
 class支持继承；struct不支持继承
 class声明的方法修改属性不需要mutating关键字；struct需要
 class没有提供默认的memberwise initializer；struct提供默认的memberwise initializer
 class支持引用计数(Reference counting)；struct不支持
 class支持Type casting；struct不支持
 class支持Deinitializers；struct不支持
 链接：https://juejin.cn/post/6844903775816155144
 
 */

/**
 
 ===：代表两个变量或者常量引用的同一个instance
 ==：代表两个变量或者常量的值是否相同，并不一定是引用的同一个instance
 如果想让自定义的class支持==操作符，可以使该类遵守Equatable

 */


func testStructFun() {
    let cat = Animal()
    cat.name = "mao"
    cat.weight = 30
    cat.block = { ()->Bool in
      return true
    }
    
    if cat.block!() {
        
    }
    
    
    let blackCat = cat
    blackCat.name = "black_cat"
    blackCat.weight = 60
    print("class:" + "动物的名称:" + cat.name,"动物的重量:",cat.weight)
    print("class:" + "动物的名称:" + blackCat.name,"动物的重量:",blackCat.weight)
    
    //如果struct的instance声明为let，是不能改变instance的值的
    var catAtruct = AnimalStruct()
    catAtruct.name = "mao"
    catAtruct.weight = 30
    
    var blackCatTrack = catAtruct
    blackCatTrack.name = "black_mao"
    blackCatTrack.weight = 60
    
    print("struct:" + "动物的名称:" + catAtruct.name,"动物的重量:",catAtruct.weight)
    print("struct:" + "动物的名称:" + blackCatTrack.name,"动物的重量:",blackCatTrack.weight)
    
    blackCatTrack.addWeight(weight: 100)
    print("struct:" + "动物的重量:",blackCatTrack.weight)
    
}

class Animal {
    var name : String = ""
    var weight : Float = 0
    var  block : TestReturnBlock?
}

struct AnimalStruct {
    var name : String = ""
    var weight : Float = 0
    
    //当在struct修改属性的时候需要使用mutating
    mutating func addWeight(weight:Float){
        self.weight = self.weight + weight
    }
}





