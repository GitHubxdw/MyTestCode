//
//  TestRunLoop.swift
//  MyTestCode_Example
//
//  Created by 徐东伟 on 2022/4/24.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
/**
 一般来讲一个线程只能执行一个任务，执行完成后线程就会退出，我们需要一个机制需要线程能随时处理事件但并不退出
 
 这种模型一般被称为Event loop ，EventLoop在很多系统和框架里都有实现，比如node.js的事件处理，比如windows的消息循环,再比如os/ios里的runloop
。
 实现这种模型的关键点在于，如何管理事件和消息，如何让线程在没有处理事件的时候休眠以避免占用资源，在有消息到来时候立即唤醒。
 
 
 runloop实际上就是一个对象，这个对象管理了需要处理的事件和消息，并提供一个入口函数来执行上面的eventloop的逻辑，线程执行了这个函数后，就会一直在这个函数内部执行 接受消息-等待-处理消息的循环中，直到这个循环结束，比如传入quit的消息，函数返回
 
 
 OS和iOS中提供了两个这样的对象NSRunLoop 和 CFRunLoopRef，CFRunLoopRef是在CoreFoundation框架内，他提供了纯C函数的Api，所有的Api都是线程安全的
 
 NSRunLoop是基于CFRunLoop的封装，提供了面向对象的api，但是这些api不是线程安全的
 
 
 RunLoop与线程之前的关系
 
 苹果不允许创建RunLoop,它提供了两个自动获取的函数，CFRunLoopGetMain()和CFRunLoopGetCurrent()
 
 线程和RunLoop是一一对应的，其关系是保存在一个全局的Dictionary里，线程刚创建时并没有RunLoop，如果你不主动获取，一直都不会有
 ，RunLoop的创建是发生在第一次获取时，RunLoop的销毁是发生在线程结束时候，你只能在一个线程内部获取其RunLoop，主线程除外。
 
 RunLoop 对应的接口
   CFRunLoopRef
   CFRunLoopModeRef
   CFRunLoopSourceRef
   CFRunLoopTimerRef
   CFRunLoopObserverRef
 
 其中CFRunLoopModeRef并没有对外暴露，只是通过CFRunLoopRef的接口进行了封装，他们的关系如下图
 
 一个RunLoop包含若干个Mode，每个Mode又包含若干个Sorce/Timer/Observe，每次调用Runloop的主函数时，只能指定其中一个Mode，这个Mode被称为CurrentMode，如果需要切换Mode只能退出Loop，再重新指定一个Mode进入，这样处理只是为了分隔开不同组的Source/Timer/Observe，让其互不影响
 
 
 CFRunLoopSourceRef是产生事件的地方，Source有两个版本，source0和source1，source0只包含了一个回调（函数指针），它并不能主动触发事件，使用时你需要先调用
 CFRunLoopSourceSignal(source)，将这个source标记为待处理，然后手动调用CFRunLoopWakeUp
 (loop)来唤醒runloop，让其处理这个事件。
 
 source1包含了一个mach_port和一个回调函数，被用于通过其它内核和其它线程相互发送消息，这种Source能主动唤起Runloop。
 
 
 
 CFRunLoopTimerRef是基于事件的触发器，它的NSTimer是toll-free bridged的，可以混用。其包含一个时间长度和一个回调（函数指针）
 当其注册到RunLoop时候，RunLoop会注册对应的时间点，当时间点到时，RunLoop会唤醒以执行那个回调。
 
 CFRunLoopObserverRef是观察者，每个Observer都包含了一个回调(函数指针)，当RunLoop的状态发生变化时，观察者就能通过这个变化，观测到以下时间点
 
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
     kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
     kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
     kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
     kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
     kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
 };
 
  RunLoop的mode
 
 CFRunLoop 和 CFRunLoopMode的 结构如下
 
 struct __CFRunLoopMode {
     CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
     CFMutableSetRef _sources0;    // Set
     CFMutableSetRef _sources1;    // Set
     CFMutableArrayRef _observers; // Array
     CFMutableArrayRef _timers;    // Array
     ...
 };
  
 struct __CFRunLoop {
     CFMutableSetRef _commonModes;     // Set
     CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
     CFRunLoopModeRef _currentMode;    // Current Runloop Mode
     CFMutableSetRef _modes;           // Set
     ...
 };
 
  这里有个概念是 commonModes ,一个Mode可以将自己标记为common属性（通过将其modename添加到runloop的commonModes中），每当RunLoop的内容发生变化时，runloop都会自动将commonModeltems里的source/Observer/Timers 同步到具有common标记的所有Mode中
 应用场景：
 主线程的RunLoop有两个预置的Mode，KCFRunloopDefaultMode 和UITrackingRunLoopMode，这两个Mode都被标记为common属性，DefaultMode是app平时所处的状态，TraakingMode是追踪scrollerView滑动的状态，当你创建一个Timer并添加到DefaultMode上时，Timer会得到重复调用，但此时滑动tableview时候，RunLoop会将Mode切换为KCFRunLoopDafaultMode，这时Timer就不会被调用，并且也不影响到滑动
 
 有时需要一个Timer在两个Mode中都能回调，一种办法就是将这个Timer分别加入到这个Mode，还有一种方式是将Timer加入到顶层的RunLoop的commonModeItems
 中commonModeItems被RunLoop自动更新到具有Common属性的Mode里去
 
 
 CFRunLoop对外暴露的管理 Mode 接口只有下面2个
 CFRunLoopAddCommonMode(CFRunLoopRef runloop, CFStringRef modeName);
 CFRunLoopRunInMode(CFStringRef modeName, ...);
 
 Mode暴漏的管理item的接口有以下
 
 CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
 CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef modeName);
 CFRunLoopAddTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
 CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
 CFRunLoopRemoveObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef modeName);
 CFRunLoopRemoveTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
 
 
 你只能通过mode name来操作内部的mode，当你传入一个新的modename 但runloop没有对应的mode时，runloop会自动帮你创建对应的CFRunLoopModeRef，对于一个RunLoop来说其内部的Mode只能添加不能删除
 
 
 苹果公开提供的Mode有两个，KCFRunLoopDefaultMode（NSDefaultRunLoopMode）和 UITrackingRunLoopMode，可以用这两个modename来操作其对应的Mode
 
 
 苹果还提供一个操作common标记的字符串，KCFRunLoopCommonModes（NSRunLoopCommonModes）你可以用这个字符串来操作commonitems，或标记一个mode为common，使用时注意区分这个字符串和其它mode name
 
 
 RunLoop的内部逻辑
 
 
 
 AutoreleasePool
 
 App启动后在，在主线程的RunLoop注册两个Observe，其回调都是_wrapRunLoopWithAutoReleasePoolHandle（）
 
 第一个Observe观察的事件是Entry（进入Loop），其回调内会调用_objc_autoreleasePoolPush()创建自动释放池，其order = -2147483647
 优先级别最高保证创建释放池发生在其它所有回调之前。
 
 第二个Observe观察的事件是：BeforeWating （准备进入休眠时）,调用_objc_autoreleasePoolPop()和_objc_autoreleasePoolPush()来销毁和创建新的释放池
 
 Exit（即将退出Loop）时候调用_objc_autoreleasePoolPop()来释放自动释放池，这个Observe的优先级order = 2147483647 优先级最低，保证释放池子发生在其它回调之后
 
 
主线程执行的代码一般被写在诸如事件回调、Timer回调内部，这些回调会被RunLoop创建好的AutoReleasePool环绕着，所有不会出现内存泄漏，开发者也不必显示创建pool了
 
 
 
 
 苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。

 当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。这个过程的详细情况可以参考这里。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的App进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。

 _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。


 手势识别
 当上面的 _UIApplicationHandleEventQueue() 识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。随后系统将对应的 UIGestureRecognizer 标记为待处理。

 苹果注册了一个 Observer 监测 BeforeWaiting (Loop即将进入休眠) 事件，这个Observer的回调函数是 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的 GestureRecognizer，并执行GestureRecognizer的回调。

 当有 UIGestureRecognizer 的变化(创建/销毁/状态改变)时，这个回调都会进行相应处理。


 界面更新
 当在操作 UI 时，比如改变了 Frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 setNeedsLayout/setNeedsDisplay方法后，这个 UIView/CALayer 就被标记为待处理，并被提交到一个全局的容器去。

 苹果注册了一个 Observer 监听 BeforeWaiting(即将进入休眠) 和 Exit (即将退出Loop) 事件，回调去执行一个很长的函数：
 _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()。这个函数里会遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面。

 这个函数内部的调用栈大概是这样的：

 _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()
     QuartzCore:CA::Transaction::observer_callback:
         CA::Transaction::commit();
             CA::Context::commit_transaction();
                 CA::Layer::layout_and_display_if_needed();
                     CA::Layer::layout_if_needed();
                         [CALayer layoutSublayers];
                             [UIView layoutSubviews];
                     CA::Layer::display_if_needed();
                         [CALayer display];
                             [UIView drawRect];

 _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()
     QuartzCore:CA::Transaction::observer_callback:
         CA::Transaction::commit();
             CA::Context::commit_transaction();
                 CA::Layer::layout_and_display_if_needed();
                     CA::Layer::layout_if_needed();
                         [CALayer layoutSublayers];
                             [UIView layoutSubviews];
                     CA::Layer::display_if_needed();
                         [CALayer display];
                             [UIView drawRect];

 定时器
 NSTimer 其实就是 CFRunLoopTimerRef，他们之间是 toll-free bridged 的。一个 NSTimer 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00, 10:10, 10:20 这几个时间点。RunLoop为了节省资源，并不会在非常准确的时间点回调这个Timer。Timer 有个属性叫做 Tolerance (宽容度)，标示了当时间点到后，容许有多少最大误差。

 如果某个时间点被错过了，例如执行了一个很长的任务，则那个时间点的回调也会跳过去，不会延后执行。就比如等公交，如果 10:10 时我忙着玩手机错过了那个点的公交，那我只能等 10:20 这一趟了。

 CADisplayLink 是一个和屏幕刷新率一致的定时器（但实际实现原理更复杂，和 NSTimer 并不一样，其内部实际是操作了一个 Source）。如果在两次屏幕刷新之间执行了一个长任务，那其中就会有一帧被跳过去（和 NSTimer 相似），造成界面卡顿的感觉。在快速滑动TableView时，即使一帧的卡顿也会让用户有所察觉。Facebook 开源的 AsyncDisplayLink 就是为了解决界面卡顿的问题，其内部也用到了 RunLoop，这个稍后我会再单独写一页博客来分析。


 PerformSelecter
 当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。

 当调用 performSelector:onThread: 时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效。
 
 */

