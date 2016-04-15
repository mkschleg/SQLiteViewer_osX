//
//  ViewController.swift
//  SQLViewer
//
//  Created by Matthew Schlegel on 4/3/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	@IBOutlet weak var tableView_Tables: NSTableView!
	@IBOutlet weak var tableView_Data: NSTableView!
	@IBOutlet weak var tableView_Query: NSTableView!
	
	@IBOutlet weak var tableHeaderView_Data: NSTableHeaderView!
	@IBOutlet weak var textBox_Query: NSTextField!
	
	
	@IBAction func openDatabase(sender: AnyObject) {
		
		
		var fileURL: NSURL?
		let openPanel = NSOpenPanel()
		openPanel.canChooseFiles = true
		openPanel.allowsMultipleSelection = false
		openPanel.canChooseDirectories = false
		openPanel.canCreateDirectories = false
		
		openPanel.beginWithCompletionHandler{ (result)->Void in
			if result == NSFileHandlingPanelOKButton{
				fileURL = openPanel.URL
				print("\(fileURL)")
				if fileURL != nil {
					print("Try to open \(fileURL) as a SQLite database")
					SQLiteDatabaseHelper.instance.close()
					SQLiteDatabaseHelper.instance.open(fileURL)
					self.fillTablesTable()
				}
				else{
					print("No file selected")
				}
			}
		}
		
		
		
		
	}
	
	@IBAction func runQuery(sender: AnyObject) {
		let queryStr = textBox_Query.stringValue
		(tableView_Query.delegate() as? sqlQueryTableDelegate)?.runQuery(queryStr)
		tableView_Query.reloadData()
		
	}
	
	private func fillTablesTable(){
		(tableView_Tables.dataSource() as? sqlTableDelegate)?.getData()
		tableView_Tables.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override var representedObject: AnyObject? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	func loadTables() -> Void {
		tableView_Tables.reloadData()
		tableView_Data.reloadData()
	}
	
	
}

