//
//  AppDelegate.swift
//  Res Control Launcher
//
//  Created by Doug Mason on 1/3/21.
//

import Cocoa

@main
class AppDelegate: NSObject {
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let mainAppIdentifier = "com.masonsoftware.Res-Control"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.filter {
            $0.bundleIdentifier == mainAppIdentifier
        }.isEmpty
        
        if !isRunning {
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("Res Control")
            
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared.launchApplication(newPath)
        }
    }
}
