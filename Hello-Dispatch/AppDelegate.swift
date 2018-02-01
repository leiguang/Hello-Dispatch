//
//  AppDelegate.swift
//  Hello-Dispatch
//
//  Created by 雷广 on 2018/2/1.
//  Copyright © 2018年 雷广. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        demo_DispatchQueue()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

