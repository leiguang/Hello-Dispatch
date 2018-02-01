//
//  DispatchQueue.swift
//  Hello-Dispatch
//
//  Created by 雷广 on 2018/2/1.
//  Copyright © 2018年 雷广. All rights reserved.
//

// DispatchTime和DispatchWallTime 的区别
// DispatchTime:
//          DispatchTime represents a point in time relative to the default clock with nanosecond precision.
// DispatchWallTime:
//          DispatchTime represents an absolute point in time according to the wall clock with microsecond precision.

// 参考：[GCD 之任务操作](https://www.jianshu.com/p/5a16dfd36fad)
//      [Swift- 多线程编程GCD](https://www.jianshu.com/p/51d67a0f3b87)

import Foundation

func demo_DispatchQueue() {
    
//    demo_1()
    
    // DispatchWorkItem
//    demo_DispatchWorkItem()
    
    // DispatchGroup
    demo_DispatchGroup()
}

func demo_normal() {
    print("> > > > > > Start > > > > > >")
    
    // 全局队列，默认优先级'default'
    DispatchQueue.global().async {
        print("DispatchQoS: default")
    }
    
    // 全局队列 (可以设置服务等级)
    // 参数类型为 struct DispatchQoS 中的静态属性 (以下从优先级高到低)
    // userInteractive: 任务需要立刻被执行，用来在响应事件之后更新UI，提供好的用户体验。这个等级最好保持小规模。
    // userInitiated:   任务又UI发起异步执行。适用场景是需要及时结果，同时又可以继续交互的时候。
    // default:         默认优先级。
    // utility:         需要长时间运行的任务，伴有用户可见进度条指示器。经常会用来做计算，I/O，网络，持续的数据填充等任务。这个任务节能。
    // background:      用户不会察觉的任务，使用它来处理预加载，或者不需要用户交互 和对时间不敏感的任务。
    // unspecified:     未指明。
    DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: DispatchTime.now() + 1) {
        print("DispatchQoS: userInteractive.  Delay 1seconds")
    }
    
    
}

// DispatchWorkItem
func demo_DispatchWorkItem() {
    print("> > > > > > Start > > > > > >")

    // 队列默认就是串行执行的(serial)
//    let concurrentQueue = DispatchQueue(label: <#T##String#>)
    
    // DispatchQueue.Attributes 的属性
    //          concurrent为 并行队列；
    //          initiallyInactive 队列任务不会自动开始执行，需要开发者主动去触发。
    //      如: // 手动触发
    //          if let queue = inactiveQueue {
    //              queue.activate()
    //          }
    //      PS:
    //          // Suspend可以挂起一个线程，就是把这个线程暂停了，它占着资源，但不运行，
    //          // 用Resume是继续挂起的线程，让这个线程继续执行下去
    //          queue.resume()
    //          queue.suspend()
    
    // 创建并行队列
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    // DispatchWorkItem 对任务进行了封装，可以在 DispatchWorkItem 初始化方法中指定任务的内容和优先级。
//    let item = DispatchWorkItem(block: <#T##() -> Void#>)
    let item = DispatchWorkItem(qos: .default, flags: .noQoS) {
        print("use DispatchWorkItem")
    }
    
    
    //    concurrentQueue.async {
    //        item.perform()
    //    }
    // 等效于
    concurrentQueue.async(execute: item)
    
    
    // item执行完后 通知 某队列去执行某操作 (如：通知主队列刷新UI)
    item.notify(queue: DispatchQueue.main) {
        // 刷新UI
    }
    // 等效于
//    let refreshUIItem = DispatchWorkItem {
//        //
//    }
//    item.notify(queue: DispatchQueue.main, execute: item)
}


func demo_DispatchGroup() {
    let group = DispatchGroup()
    // 添加队列
    group.enter()
    let queue1 = DispatchQueue.global()
    queue1.async {
        print("enter queue1, date: \(Date()), thread: \(Thread.current)")
        for _ in 0..<1000000000 {
            
        }
        print("leave queue1, date: \(Date())")
        // 出队列
        group.leave()
    }
    
    
    // 如果需要上个队列完成后再执行，可以用wait()
    // return: DispatchTimeoutResult 为enum， 包含 success、timeOut
    let result = group.wait(timeout: DispatchTime.now() + 0.1)
    if case .success = result {
        print("result: \(result), date: \(Date())")
    } else {
        print("result: \(result), date: \(Date())")
    }
    
    
    group.enter()
    let queue2 = DispatchQueue.global()
    queue2.async {
        print("enter queue2, date: \(Date()), thread: \(Thread.current)")
        var sum = 0
        for i in 0..<100000000 {
            sum += i
            sum += i
        }
        print("leave queue2, date: \(Date())")
        group.leave()
    }
    
    // 全部执行完毕后通知
    group.notify(queue: DispatchQueue.main) {
        print("队列执行完毕, thread: \(Thread.current)")
    }
}




