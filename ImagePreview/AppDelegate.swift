//
//  AppDelegate.swift
//  ImagePreview
//
//  Created by Yohta Watanave on 2019/12/25.
//  Copyright © 2019 Yohta Watanave. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

//    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var menu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @objc
    func handleShowImageNotification(notification: Notification) {
        // Insert code here to initialize your application
        guard let windowList: NSArray = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) else {
            return
        }
        let swiftWindowList = (windowList as! [NSDictionary])
            .filter { $0[kCGWindowOwnerName] as! NSString == "ターミナル" }
        print(swiftWindowList)
        
        let windowDic = swiftWindowList.first!
        
        let bounds = windowDic[kCGWindowBounds] as! NSDictionary
        let x = bounds["X"] as! Int
        let y = bounds["Y"] as! Int
        let width = bounds["Width"] as! Int
        let height = bounds["Height"] as! Int
        
        let screenFrame = NSScreen.main!.frame
        print(screenFrame)
        
        var rect = NSRect(x: x + width / 2,
                          y: y + 60,
                          width: width / 2,
                          height: height - 60)
        
        let affineTransform = CGAffineTransform(translationX: 0, y: screenFrame.height)
            .scaledBy(x: 1, y: -1)
        rect = rect.applying(affineTransform)
        print(rect)
        let panel = NSPanel(contentRect: rect,
                            styleMask: .nonactivatingPanel,
                            backing: .buffered,
                            defer: true)
        panel.level = NSWindow.Level.floating
        panel.makeKeyAndOrderFront(nil)
        self.panel = panel
        
        let url = URL(fileURLWithPath: "/private/tmp/test.jpg")
        let data = try! Data(contentsOf: url)
        let iamgeView = NSImageView(image: NSImage(contentsOf: url)!)
        panel.contentView = iamgeView
    }
    
    @objc
    func handleHideImageNotification(notification: Notification) {
        self.panel?.close()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DistributedNotificationCenter.default()
            .addObserver(self, selector: #selector(self.handleShowImageNotification(notification:)), name: NSNotification.Name("SHOW_IMAGE"), object: "tech.watanave.ImagePreview")
        DistributedNotificationCenter.default()
            .addObserver(self, selector: #selector(self.handleHideImageNotification(notification:)), name: NSNotification.Name("HIDE_IMAGE"), object: "tech.watanave.ImagePreview")
        
        // メニューバーに表示されるアプリ。今回は文字列で設定
        self.statusItem.button?.title = "IM"
        //メニューのハイライトモードの設定
        self.statusItem.highlightMode = true
        //メニューの指定
        self.statusItem.menu = menu
    }
    
    var panel: NSPanel?

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

