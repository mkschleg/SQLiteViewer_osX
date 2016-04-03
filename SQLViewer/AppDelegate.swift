//
//  AppDelegate.swift
//  SQLViewer
//
//  Created by Matthew Schlegel on 4/3/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
		SQLiteDatabaseHelper.instance.close()
	}

	func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
		return true
	}

}

