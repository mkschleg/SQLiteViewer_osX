//
//  sqlQueryTableDelegate.swift
//  SQLViewer
//
//  Created by Matthew Schlegel on 4/15/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import Cocoa


class sqlQueryTableDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {

	@IBOutlet weak var tableView_query: NSTableView!
	
	var queryData: [[String]]? = nil
	var queryString: String? = nil
	
	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?{
		
		if(queryData == nil){
			return nil
		}
		return queryData![row+1][queryData![0].indexOf(tableColumn!.title)!]
		
	}
	

	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		
		if queryData == nil{
			return 0
		}
		
		return (queryData!.count)-1
	}
	
	
	func updateTableColumns() -> Void{
		
		if(queryString == nil){
			//TODO remove all columns
			for _ in 0..<tableView_query.numberOfColumns{
				tableView_query.removeTableColumn(tableView_query.tableColumns[0])
			}
			return
		}
		let columns = queryData![0]
		let numColumnsCurrent = tableView_query.numberOfColumns
		let numColumnsNeeded = columns.count
		if(numColumnsNeeded > numColumnsCurrent){
			//TODO add more columns

			for _ in 0..<(numColumnsNeeded - numColumnsCurrent){
				tableView_query.addTableColumn(NSTableColumn(identifier: ""))
			}
			
			
		} else if(numColumnsNeeded < numColumnsCurrent){
			//TODO remove extra columns

			for _ in 0..<(numColumnsCurrent - numColumnsNeeded){
				tableView_query.removeTableColumn(tableView_query.tableColumns[0])
			}
		}
		
		for i in 0..<numColumnsNeeded {
			
			tableView_query.tableColumns[i].title = columns[i]
			
		}
		
		
	}
	
	func runQuery(queryStr: String){
		
		queryString = queryStr
		let query = SQLiteDatabaseHelper.instance.runQuery(queryStr)
		if(query == nil){
			queryData = nil
			queryString = nil
			return
		}
		queryData = query
		updateTableColumns()
		
	}
	
	
	
}
