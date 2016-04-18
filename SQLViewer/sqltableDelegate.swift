//
//  sqltableDelegate.swift
//  SQLViewer
//
//  Created by Matthew Schlegel on 4/3/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import Cocoa


class sqlTableDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {
	
	var tableData: [String]? = nil
	var data: [String: [[String]]] = [String: [[String]]]()
	var schema: [String: [[String]]] = [String: [[String]]]()
	var currentTable: Int = -1
	
	@IBOutlet weak var tableView_tables: NSTableView!
	@IBOutlet weak var tableView_data: NSTableView!
	@IBOutlet weak var tableView_schema: NSTableView!
	
	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		//var newString = data.objectAtIndex(row).objectForKey(tableColumn?.identifier)
		if(tableView.identifier == "sqlite_tables"){
			if(tableColumn?.identifier == "tables"){
				return tableData?[row]
			}
			else {
				if(currentTable != -1){
					
				}
				return nil
			}
		} else if tableView.identifier == "sqlite_table_data" && currentTable != -1{
			
			return data[tableData![currentTable]]![row+1][data[tableData![currentTable]]![0].indexOf(tableColumn!.title)!]
		} else if tableView.identifier == "sqlite_table_schema" && currentTable != -1{
			return schema[tableData![currentTable]]![row+1][schema[tableData![currentTable]]![0].indexOf(tableColumn!.title)!]
		} else {
			return nil
		}
	}
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		if(tableView.identifier == "sqlite_tables" && tableData != nil){
			return tableData!.count
		} else if(tableView.identifier == "sqlite_table_data" && currentTable != -1){
			return (data[tableData![currentTable]]?.count)! - 1
		} else if(tableView.identifier == "sqlite_table_schema" && currentTable != -1){
			return(schema[tableData![currentTable]]?.count)! - 1
		}
		return 0
	}
	
	
	
	func getData(){
		
		//Get tables in SQLITE database
		tableData = SQLiteDatabaseHelper.instance.findTables()
		
		//Get information from tables

		if( tableData != nil){
			for i in 0..<tableData!.count{
				
				var query = SQLiteDatabaseHelper.instance.runQuery("select * from \(tableData![i])")
				data[tableData![i]] = query
				
				query = SQLiteDatabaseHelper.instance.runQuery("PRAGMA main.table_info(\(tableData![i]))")
				schema[tableData![i]] = query
				
			}
		}
		
	}
	
	func removeData(){
		
		currentTable = -1
		tableData?.removeAll()
		data.removeAll()
		schema.removeAll()
		
	}
	
	func updateTableColumns() -> Void{
		
		if(currentTable == -1){
			//TODO remove all columns
			for _ in 0..<tableView_data.numberOfColumns{
				tableView_data.removeTableColumn(tableView_data.tableColumns[0])
				tableView_schema.removeTableColumn(tableView_schema.tableColumns[0]);
			}
			return
		}
		let dataColumns = data[tableData![currentTable]]![0]
		let schemaColumns = schema[tableData![currentTable]]![0]
		
		//Data view
		var numColumnsCurrent = tableView_data.numberOfColumns
		var numColumnsNeeded = dataColumns.count
		if(numColumnsNeeded > numColumnsCurrent){
			//TODO add more columns
			for _ in 0..<(numColumnsNeeded - numColumnsCurrent){
				tableView_data.addTableColumn(NSTableColumn(identifier: ""))
			}

		} else if(numColumnsNeeded < numColumnsCurrent){
			//TODO remove extra columns
			for _ in 0..<(numColumnsCurrent - numColumnsNeeded){
				tableView_data.removeTableColumn(tableView_data.tableColumns[0])
			}
		}
		for i in 0..<numColumnsNeeded {
			tableView_data.tableColumns[i].title = dataColumns[i]
		}
		
		//Schema view
		numColumnsCurrent = tableView_schema.numberOfColumns
		numColumnsNeeded = schemaColumns.count
		if(numColumnsNeeded > numColumnsCurrent){
			//TODO add more columns
			for _ in 0..<(numColumnsNeeded - numColumnsCurrent){
				tableView_schema.addTableColumn(NSTableColumn(identifier: ""))
			}
			
		} else if(numColumnsNeeded < numColumnsCurrent){
			//TODO remove extra columns
			for _ in 0..<(numColumnsCurrent - numColumnsNeeded){
				tableView_schema.removeTableColumn(tableView_schema.tableColumns[0])
			}
		}
		for i in 0..<numColumnsNeeded {
			tableView_schema.tableColumns[i].title = schemaColumns[i]
		}
		
	}
	
	
	
	
	func tableViewSelectionDidChange(notification: NSNotification) {
		if((notification.object as? NSTableView)?.identifier == "sqlite_tables"){
			currentTable = ((notification.object as? NSTableView)?.selectedRow)!
			updateTableColumns()
			tableView_data.reloadData()
			tableView_schema.reloadData()
			
		}
	}
	
}



