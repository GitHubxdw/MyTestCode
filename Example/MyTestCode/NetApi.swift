//
//  NetApi.swift
//  MyTestCode_Example
//
//  Created by 徐东伟 on 2022/7/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
/*
//网络基本概念
https://www.cnblogs.com/fzz9/p/8964513.html
 
 TCP/IP，传输控制协议或者是因特网互联网协议是，基于网络层IP协议和传输层TCP协议组成
 

//网络框架

 AFNetWorking
 
 AFURLSessionManager/AFHTTPSessionManager
 
 AF的核心代码，主要负责网络请求的发起，回调处理，是在系统网络Api的上层封装
 
 大部分逻辑都是在AFURLSessionManager中处理，AFHTTPSessionManager只是专为http请求提供了一些便利的办法，如果需要扩展其它协议的方法可以考虑从AFURLSessionManager创建一个子类
 
 AFURLRequestSerialization/AFURLResponseSerialization
 主要处理一些参数序列化相关工作，AFURLRequestSerialization将传入的参数处理成NSURLRequest，比如自定义的header，一些post、get请求参数
 
 AFURLResponseSerialization
 主要是将系统返回的数据NSURLResponse处理成我们想要的数据、例如json、xml或者图片
 
 AFSecurityPolicy
 处理https相关公钥和验证逻辑
 
 
 AFNetworkReachabilityManager
 这是一个相对独立的模块，提供获取当前网络状态的功能
 
 UIKit+AFNetworking
 
 提供了一些简单便利的UIKit方法
 
 
//数据序列化处理
 
 */
