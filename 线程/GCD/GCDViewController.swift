//
//  GCDViewController.swift
//  线程
//
//  Created by jps on 2020/8/27.
//  Copyright © 2020 jps. All rights reserved.
//

import UIKit

class GCDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        f()
        
        //gcdTest1()
        
        //gcdTest2()
        
        //gcdTest3()
        
        //gcdTest4()
        
        
    }
    
    
    ///创建队列
    func few() {
        /*
         创建一个队列
         label: 队列的名称，可以任意起名
         qos: 优先级 (用于指定队列的优先级, 是个枚举)
         attributes: 队列的属性 (串行、并行, 不设置默认串行)
         autoreleaseFrequency: 自动释放频率
         target:
         */
//        DispatchQueue(label: <#T##String#>, qos: <#T##DispatchQoS#>, attributes: <#T##DispatchQueue.Attributes#>, autoreleaseFrequency: <#T##DispatchQueue.AutoreleaseFrequency#>, target: <#T##DispatchQueue?#>)
//        DispatchQueue(label: "queue", qos: .utility, attributes: .initiallyInactive, autoreleaseFrequency: .workItem, target: <#T##DispatchQueue?#>)
        
        
        
        
        
        
    }
    
    /*
    /// qos_class_t
    public struct DispatchQoS : Equatable {
        //用户无法感知，比较耗时的一些操作
        @available(OSX 10.10, iOS 8.0, *)
        public static let background: DispatchQoS
        
        //实用级别，不需要很快完成的任务
        @available(OSX 10.10, iOS 8.0, *)
        public static let utility: DispatchQoS
        
        //系统默认的优先级，
        @available(OSX 10.10, iOS 8.0, *)
        public static let `default`: DispatchQoS
        
        //用户发起，需要在很快时间内完成的，例如用户的点击事件、以及用户的手势
        @available(OSX 10.10, iOS 8.0, *)
        public static let userInitiated: DispatchQoS
        
        //用户交互级别，需要在极快时间内完成的，例如UI的显示
        @available(OSX 10.10, iOS 8.0, *)
        public static let userInteractive: DispatchQoS
        
        //不指定
        public static let unspecified: DispatchQoS
        
        //优先级
        // userInteractive > userInitiated > `default` > utility > background
    }
     */
    
    
    /*
    public struct Attributes : OptionSet {

        //并行队列， 不指定attributes参数为串行队列
        public static let concurrent: DispatchQueue.Attributes

        //创建的时候, 是处于不活跃状态, 即不会执行任务, 需要手动调用activate()来激活队列执行任务
        @available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public static let initiallyInactive: DispatchQueue.Attributes
        
    }
     */
    
    
    //MARK:  ------------  线程一些基本方法  ------------
    
    func f() {
        //主队列
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            print("主线程执行任务")
        }
        
        
        //------- 用一个调度组，等所有任务执行完后，再去执行最终任务 -------
        
        //调度组
        let group = DispatchGroup()
        //全局队列
        let globalQueue = DispatchQueue.global(qos: .default)
        globalQueue.async(group: group, qos: .default, flags: []) {
            print("下载1")
        }
        globalQueue.async(group: group, qos: .default, flags: []) {
            print("下载2")
        }
        //所有任务执行完毕后,通知
        group.notify(qos: .default, flags: [], queue: .main) {
            print("回到主队列更新UI")
        }
        
        //在创建队列时，不指定队列类型时，默认为串行队列。
        
        //------ 串行队列 ------
        
        /*
         label:队列标识符
         */
        let serialQueue = DispatchQueue(label: "serial_queue1", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        
        
        //------ 并行队列 ------
        /*
         
         */
        let queue2 = DispatchQueue(label: "queue2", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        
        //在使用的时候, 我们一般不去创建并行队列, 而是使用系统为我们提供的全局的并行队列
        let queue3 = DispatchQueue.global()
        
        /*
         注意:
         在创建串行并行队列的时候, 参数attributes, 可以指定创建的是串行还是并行队列, 他还有一个值: .initiallyInactive, 即: 创建的时候, 是处于不活跃状态, 即不会执行任务, 需要手动调用activate()来激活队列执行任务
         */
    }
    
    //MARK:  ------------  开线程异步执行完耗时代码，返回主线程刷新UI  ------------
    //略
    
    //MARK:  ------------  延时提交任务  ------------
    func gcdTest0() {
        //主队列
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("主队列，延时提交任务, 3s")
        }
        //指定任务
        let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        queue.asyncAfter(deadline: .now() + 3) {
            print("指定队列，延时提交任务, 3s")
        }
        let t = DispatchTimeInterval.seconds(1)
        queue.asyncAfter(deadline: .now() + t) {
            print("指定队列，延时提交任务, 1s")
        }
    }
    
    //MARK:  ------------  等待异步执行多个任务后, 再执行下一个任务  ------------
    func gcdTest1() {
        //并行队列
        let queue = DispatchQueue(label: "com.queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        //任务一
        queue.async {
            for _ in 0...10 {
                print("任务1...")
            }
        }
        //任务二
        queue.async {
            for _ in 0...5 {
                print("任务2+++")
            }
        }
        //barrier 会等待上面执行完毕再执行下面的，会阻塞当前线程
        queue.async(group: nil, qos: .default, flags: .barrier) {
            print("前面的任务已执行完")
        }
        queue.async {
            print("任务3开始执行")
        }
        
    }
    
    
    
    
    //MARK:  ------------  信号量  ------------
    
    /*
     每十个任务并发执行
     */
    func gcdTest2() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        //剩余10个车位
        let semaphore = DispatchSemaphore(value: 10)
        
        for i in 1...100 {
            //来了一辆车，信号量减1
            //let result = semaphore.wait(timeout: .distantFuture)
            /*
             超时时间内，一只阻塞在这里，当超时后，则执行后面的代码
             如果要严格控制并发量，则要判断result的值，为.success时才往group里加任务
             如果直接加的话，一开始group里有10个任务，等一秒超时后又往group里加了一个任务，这时候就有11个任务了。
             */
            let result = semaphore.wait(timeout: .now() + 3)
            
            /*
            queue.async(group: group) {
                print("执行任务: \(i), 线程: \(Thread.current)")
                sleep(1)
                semaphore.signal()
            }*/
            
            switch result {
            case .success:
                queue.async(group: group) {
                    print("执行任务: \(i), 线程: \(Thread.current)")
                    sleep(3)
                    semaphore.signal()
                }

            case .timedOut:
                print("信号等待超时, 丢弃任务: \(i)")
            }
        }
    }
    
    
    
    
    //MARK:  ------------  Group的用法  ------------
    
    ///notify(依赖任务)
    func gcdTest3() {
        //调度组
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        queue.async(group: group, qos: .default, flags: []) {
            for i in 1...10 {
                sleep(1)
                print("第一组耗时任务: \(i)")
            }
        }
        queue.async(group: group, qos: .default, flags: []) {
            for i in 1...10 {
                sleep(1)
                print("第二组耗时任务: \(i)")
            }
        }
        //执行完上面的两个耗时操作, 回到queue队列中执行下一步的任务
        group.notify(queue: queue) {
            //group内所有线程的任务执行完毕
            print("notify: 前两个任务都执行完了，可以执行下一步任务")
        }
    }
    
    
    ///wait(任务等待)
    func gcdTest4() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        queue.async(group: group, qos: .default, flags: []) {
            for i in 1...10 {
                print("1任务: \(i)")
            }
        }
        queue.async(group: group, qos: .default, flags: []) {
            for i in 1...10 {
                sleep(1)
                print("2任务: \(i)")
            }
        }
        
        //等待上面任务执行，会阻塞当前线程，超时就执行下面的，上面的继续执行，queue的任务不受影响。
        let result = group.wait(timeout: .now() + 5)
        //let result = group.wait(timeout: .distantFuture)
        switch result {
        case .success:
            print("所有任务执行完，没有超时")
        case .timedOut:
            print("任务未执行完，超时了")
        }
        
        print("接下来做其他事")
    }
    
    
    

}


    



/*
 Swift多线程操作GCD使用总结
 https://www.jianshu.com/p/8d4cc42b095b
 Swift多线程编程总结
 https://juejin.im/post/6844903545213288461
 
 iOS多线程：线程生命周期，多线程的四种解决方案，线程安全问题，GCD的使用，NSOperation的使用
 https://www.jianshu.com/p/7649fad15cdb
 
 Swift - 多线程实现方式（3） - Grand Central Dispatch（GCD）
 https://www.hangge.com/blog/cache/detail_745.html
 */
