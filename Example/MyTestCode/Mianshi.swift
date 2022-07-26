//
//  Mianshi.swift
//  MyTestCode_Example
//
//  Created by 徐东伟 on 2022/5/24.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
/**
 UI层面
 
 1、UI布局
 
 2、iOS 中事件的响应链和传递链
 
 3、tableview列表优化
 
 
 内存、语法方向
 
 1、ARC下哪些情况会造成内存泄漏
      循环引用的情况
          a、类之前的相互引用、持有
          b、使用block
          c、使用delegate
          d、NSTimer
    CF类型内存/C语言malloc出来的对象
    单例也会造成内存泄漏
 
 2、Autoreleasepool的原理
 
 3、block有哪些类型
 
 block在修改NSMutableArray，需不需要添加__block
 
4、 iOS开发中有多少类型的多线程
 
 Pthread，较少使用。
 NSThread，每个 NSThread对象对应一个线程，量级较轻，通常我们会起一个 runloop 保活，然后通过添加自定义source0源或者 perform onThread 来进行调用，优点轻量级，使用简单，缺点：需要自己管理线程的生命周期，保活，另外还会线程同步，加锁、睡眠和唤醒。
 GCD：Grand Central Dispatch（派发） 是基于C语言的框架，可以充分利用多核，是苹果推荐使用的多线程技术
 优点：GCD更接近底层，而NSOperationQueue则更高级抽象，所以GCD在追求性能的底层操作来说，是速度最快的，有待确认
 缺点：操作之间的事务性，顺序行，依赖关系。GCD需要自己写更多的代码来实现
 NSOperation
 优点： 使用者的关注点都放在了 operation 上，而不需要线程管理。
 支持在操作对象之间依赖关系，方便控制执行顺序。
 支持可选的完成块，它在操作的主要任务完成后执行。
 支持使用KVO通知监视操作执行状态的变化。
 支持设定操作的优先级，从而影响它们的相对执行顺序。
 支持取消操作，允许您在操作执行时暂停操作。
 缺点：高级抽象，性能方面相较 GCD 来说不足一些;
 
 为什么只在主线程刷新UI

 5、runtime、runloop
 
 
 网络相关
 
 如何理解HTTP，什么是HTTTS，HTTPS连接过程简述
 
 TCP是什么
 UDP是什么
 TCP和UDP区别
 
 http 与https区别
 https协议需要到ca申请证书，一般免费证书很少，需要交费。
 http是超文本传输协议，信息是明文传输，https 则是具有安全性的ssl加密传输协议。
 http和https使用的是完全不同的连接方式，用的端口也不一样，前者是80，后者是443。
 http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全

  
 HTTPS就是使用SSL/TLS协议进行加密传输，让客户端拿到服务器的公钥，然后客户端随机生成一个对称加密的秘钥，使用公钥加密，传输给服务端，后续的所有信息都通过该对称秘钥进行加密解密，完成整个HTTPS的流程。
 
 AFNetWorking
 
 Moya
 
 
OC和swift混编 OC和swift区别
 
 swift注重安全，OC注重灵活
 swift注重面向协议编程、函数式编程、面向对象编程，OC注重面向对象编程
 swift注重值类型，OC注重指针和引用
 swift是静态类型语言，OC是动态类型语言
 swift容易阅读，文件结构和大部分语法简易化，只有.swift文件，结尾不需要分号
 swift中的可选类型，是用于所有数据类型，而不仅仅局限于类。相比于OC中的nil更加安全和简明
 swift中的泛型类型更加方便和通用，而非OC中只能为集合类型添加泛型
 swift中各种方便快捷的高阶函数（函数式编程） (Swift的标准数组支持三个高阶函数：map，filter和reduce,以及map的扩展flatMap)
 swift新增了两种权限，细化权限。open > public > internal(默认) > fileprivate > private
 swift中独有的元组类型(tuples)，把多个值组合成复合值。元组内的值可以是任何类型，并不要求是相同类型的。
 
 
 
 
 Wkwebview 原生交互   中文编码问题
 数据存储方式 沙盒目录文件
 设计模式
 数据埋点
 Kvc kvo原理
 https://www.imooc.com/article/285662
 https://www.jianshu.com/p/c82d83c52a41
 
 isa

     
 
 
 
 */


