//
//  AppDelegate.swift
//  Res Switcher
//
//  Created by Doug Mason on 1/2/21.
//

import Cocoa
import IOKit

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var menu: NSMenu!
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let itemImage = NSImage(named: "StatusMenuTemplate")
        itemImage?.isTemplate = true
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusItem?.button?.image = itemImage
        self.statusItem?.menu = self.menu
    }
    
    deinit {
        guard let item = self.statusItem else {
            return
        }
        NSStatusBar.system.removeStatusItem(item)
    }
    
    @IBAction func openDisplayPreferences(_ sender: Any) {
        NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Displays.prefPane"))
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
      
        for item in self.menu.items {
            if item.hasSubmenu || item.isKind(of: DisplayModeMenuItem.self) {
                self.menu.removeItem(item)
            } else if item.isSeparatorItem {
                break
            }
        }
        
        // loop through all displays (max 16)
        var numberOfDisplays: UInt32 = 0
        var displays = [CGDirectDisplayID](arrayLiteral: 16)
        CGGetOnlineDisplayList(UInt32(16), &displays, &numberOfDisplays)
        
        for (index, display) in displays.enumerated() {
            
            // The menu to add the display modes to, by default directly
            // into the main menu
            var containerMenu = self.menu
            
            // If we have multiple displays, put each list of display
            // modes into its own submenu
            if numberOfDisplays > 1 {
                let subMenu = NSMenu()
                let subMenuItem = NSMenuItem()
                if let productName = display.productName() {
                    subMenuItem.title = productName
                }
                
                subMenuItem.submenu = subMenu
                containerMenu?.insertItem(subMenuItem, at: index)
                containerMenu = subMenu
            }
            
            // Add the display modes to the container menu
            // (either the main menu or a display submenu)
            if let menuItems = DisplayModeMenuItem.getMenuItems(forDisplay: display) as? [NSMenuItem] {
                for item in menuItems {
                    
                    // Add to the top of the menu,
                    // in reverse order (highest resolution first)
                    containerMenu?.insertItem(item, at: 0)
                }
            }
        }
    }
}

