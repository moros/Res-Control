//
//  AppDelegate.swift
//  Res Control Launcher
//
//  Created by Doug Mason on 1/3/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let mainAppIdentifier = "com.masonsoftware.Res-Control"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == mainAppIdentifier
        }
        
        if !isRunning {
            let path = Bundle.main.bundlePath as NSString
            
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.removeLast()
            
            let newPath = NSString.path(withComponents: components)
            
            let url = URL(fileURLWithPath: newPath, isDirectory: true)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)
            NSApplication.shared.hide(nil)
        }
    }
}
