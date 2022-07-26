//
//  TestLCode.swift
//  MyTestCode_Example
//
//  Created by 徐东伟 on 2022/4/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

/**
 哈希算法
 
 哈希算法并不是一个特定的算法而是一类算法的统称。哈希算法也叫散列算法，一般来说满足这样的关系：f(data)=key，输入任意长度的data数据，经过哈希算法处理后输出一个定长的数据key。同时这个过程是不可逆的，无法由key逆推出data。

 如果是一个data数据集，经过哈希算法处理后得到key的数据集，然后将keys与原始数据进行一一映射就得到了一个哈希表。一般来说哈希表M符合M[key]=data这种形式。

 哈希表的好处是当原始数据较大时，我们可以用哈希算法处理得到定长的哈希值key，那么这个key相对原始数据要小得多。我们就可以用这个较小的数据集来做索引，达到快速查找的目的。

 稍微想一下就可以发现，既然输入数据不定长，而输出的哈希值却是固定长度的，这意味着哈希值是一个有限集合，而输入数据则可以是无穷多个。那么建立一对一关系明显是不现实的。所以"碰撞"(不同的输入数据对应了相同的哈希值)是必然会发生的，所以一个成熟的哈希算法会有较好的抗冲突性。同时在实现哈希表的结构时也要考虑到哈希冲突的问题。

 密码上常用的MD5，SHA都是哈希算法，因为key的长度(相对大家的密码来说)较大所以碰撞空间较大，有比较好的抗碰撞性，所以常常用作密码校验。

 */



/**
 
 链表 [Linked List]：链表是由一组不必相连【不必相连：可以连续也可以不连续】的内存结构 【节点】，按特定的顺序链接在一起的抽象数据类型。
 抽象数据类型（Abstract Data Type [ADT]）：表示数学中抽象出来的一些操作的集合。
 内存结构：内存中的结构，如：struct、特殊内存块...等等之类；

 链表常用的有 3 类： 单链表、双向链表、循环链表。
 
 单链表 [Linked List]：由各个内存结构通过一个 Next 指针链接在一起组成，每一个内存结构都存在后继内存结构【链尾除外】，内存结构由数据域和 Next 指针域组成。



 */

