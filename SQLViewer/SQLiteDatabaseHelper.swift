//
//  SQLiteDatabaseHelper.swift
//  SQLViewer
//
//  Created by Matthew Schlegel on 4/3/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import Foundation
//import Cocoa

class SQLiteDatabaseHelper{
	
	static let instance: SQLiteDatabaseHelper = SQLiteDatabaseHelper()
	var dbConnection: COpaquePointer = nil
	var URL: NSURL? = nil
	
	
	private init(){
		
	}
	
	func open(fileURL: NSURL?){
		if(fileURL != nil){
			if(sqlite3_open(fileURL!.path!, &dbConnection) != SQLITE_OK){
				print("error opening database")
				dbConnection = nil
				return
			}else {
				print("Database opened at: \(fileURL!.path!)")
				
				URL = fileURL
			}
			findTables()
		} else {
			print("error no filePath found")
		}
	}
	
	func close(){
		if(sqlite3_close(dbConnection) != SQLITE_OK){
			print("error closing database")
		}
		else{
			print("Database closed")
		}
	}
	
	func findTables() -> [String]?{
		
		var statement: COpaquePointer = nil
		if(sqlite3_prepare_v2(dbConnection, "select name from sqlite_master where type='table'", -1, &statement, nil) != SQLITE_OK){
			let errmsg = String.fromCString(sqlite3_errmsg(dbConnection))
			print("error preparing statement: \(errmsg)")
			return nil
		}
		
		var tables: [String] = [String]()
		tables.append("sqlite_master")
		
		while sqlite3_step(statement) == SQLITE_ROW{
			let tableName = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 0)))
			if (tableName != nil) {tables.append(tableName!)}
		}
		
		if sqlite3_finalize(statement) != SQLITE_OK{
			let errmsg = String.fromCString(sqlite3_errmsg(dbConnection))
			print("error finalizing statement: \(errmsg)")
			return nil
		}
		return tables
		
	}
	
	//Returns data the first row being the columns.
	
	func runQuery(query:String) -> [[String]]?{
		
		var statement: COpaquePointer = nil
		if(sqlite3_prepare_v2(dbConnection, query, -1, &statement, nil) != SQLITE_OK){
			let errmsg = String.fromCString((sqlite3_errmsg(dbConnection)))
			print("error preparing statement: \(errmsg)")
			return nil
		}
		
		var ret = [[String]]()
		let count = sqlite3_column_count(statement)
		
		var columns = [String]()
		
		for i in 0..<count {
			columns.append(String.fromCString(UnsafePointer<Int8> (sqlite3_column_name(statement, i)))!)
		}
		ret.append(columns)
		
		//TODO get data
		while sqlite3_step(statement) == SQLITE_ROW{
			var temp = [String]()
			for i in 0..<count{
				if let s = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, i))){
					temp.append(s)
				} else {
					temp.append("")
				}
				//print(String.fromCString(UnsafePointer<Int8> (sqlite3_column_text(statement, i))))
			}
			ret.append(temp)
		}
		
		if(sqlite3_finalize(statement) != SQLITE_OK){
			let errmsg = String.fromCString(sqlite3_errmsg(dbConnection))
			print("error finalizing statement \(errmsg)")
		}
		
		
		return ret
		
	}
	
	
	
	
	
}

