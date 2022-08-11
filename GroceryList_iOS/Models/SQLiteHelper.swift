
//
//  SQLiteHelper.swift
//  GroceryList
//
//  Created by ADITI SAIN on 2022-04-10.
//

import Foundation
import SQLite3
import WidgetKit

class SQLiteHelper {
    
    private var db: OpaquePointer?
    private var stat: OpaquePointer?
    
    private let DATABASE_NAME = "list.db";
    private let DATABASE_VERSION = 1;
    private let TABLE = "listtable"
    private let ID = "id"
    private let LIST_NAME = "listname"
    private let ITEM_NAME = "itemname"
    private let QUANTITY = "quantity"
    private let COST = "cost"
    private let BOUGHT = "bought";


    func connect() -> Bool {
        // Create connection to database
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(DATABASE_NAME)
            
        sqlite3_open(fileUrl.path, &db)
            
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error Opening Database")
            return false
        }
        print("Connection created succefully")
        return true
    }

    func createTable() -> Bool{

        let createTaleQuerry = "CREATE TABLE IF NOT EXISTS " + TABLE + "( " + ID + " INTEGER," + LIST_NAME + " TEXT," + ITEM_NAME + " TEXT, " + QUANTITY + " INTEGER, " + COST + " REAL, " + BOUGHT + " INTEGER, PRIMARY KEY(id AUTOINCREMENT))"
        
        if sqlite3_exec(db, createTaleQuerry, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return false
        }
        print("Table created")
        return true
    }
    
    func insertData(list:ListModel) -> Bool{
      
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let insertQuerry = "INSERT INTO " + TABLE + " (" + LIST_NAME + "," + ITEM_NAME + "," + QUANTITY + "," + COST + "," + BOUGHT + ") VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare(db, insertQuerry,-1,&stat, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(stat)
            return false
        }
        
        if sqlite3_bind_text(stat, 1, list.listname ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            sqlite3_reset(stat)
            return false
        }
        
        if sqlite3_bind_text(stat, 2, list.itemname ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            sqlite3_reset(stat)
            return false
        }
     
        if sqlite3_bind_int(stat, 3, Int32(list.quantity)) != SQLITE_OK{
            sqlite3_reset(stat)
            return false
        }
        
        
        if sqlite3_bind_double(stat, 4, list.cost) != SQLITE_OK{
            sqlite3_reset(stat)
            return false
        }
        
        if sqlite3_bind_int(stat, 5, Int32(list.bought)) != SQLITE_OK{
            sqlite3_reset(stat)
            return false
        }
        
        if sqlite3_step(stat) != SQLITE_DONE{
            sqlite3_reset(stat)
            return false
        }
        
        
        var list = getFavouriteList()
        UserDefaults(suiteName:"group.ca.singhs.grocerylist-ios")?.set( list[0].listname, forKey: "fav")
        WidgetCenter.shared.reloadAllTimelines()
        print("widget reloaded")
        print("Inserted Succefully")
        sqlite3_reset(stat)
        return true
   }
    
    func getFavouriteList() -> [ListModel]{
//        var filter  = "Sobeys"
        var listarray = [ListModel]();
        let queryStatementString = "SELECT * FROM " + TABLE + " where listname = (select listname from " + TABLE + " limit 1)"
        print (queryStatementString)

      var queryStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
          SQLITE_OK {
        // 2
        while sqlite3_step(queryStatement) == SQLITE_ROW {
          // 3
            let list : ListModel = ListModel();
          let id = sqlite3_column_int(queryStatement, 0)
          // 4
            list.id = Int(id);
          guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
            print("Query result is nil")
              return  listarray;
          }
          let name = String(cString: queryResultCol1)
            list.listname = name;
          // 5
            
            guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
              print("Query result is nil")
                return  listarray;
            }
            let name2 = String(cString: queryResultCol2)
              list.itemname = name2;
            
            
            list.quantity = Int(sqlite3_column_int(queryStatement, 3));
            list.cost = sqlite3_column_double(queryStatement, 4);
            list.bought = Int(sqlite3_column_int(queryStatement, 5));
            listarray.append(list);
            
          print("\nQuery Result:")
            print("\(id) | \(name)| \(name2)| \(list.quantity)| \(list.cost)")
      
      }
      }
      // 7
      sqlite3_finalize(queryStatement)
//        print(list)
        return listarray;
    }
    
    
    func getdata(filter : String) -> [ListModel]{
//        var filter  = "Sobeys"
        var listarray = [ListModel]();
        let queryStatementString = "SELECT * FROM " + TABLE + " where listname = '"+filter+"';"

      var queryStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
          SQLITE_OK {
        // 2
        while sqlite3_step(queryStatement) == SQLITE_ROW {
          // 3
            let list : ListModel = ListModel();
          let id = sqlite3_column_int(queryStatement, 0)
          // 4
            list.id = Int(id);
          guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
            print("Query result is nil")
              return  listarray;
          }
          let name = String(cString: queryResultCol1)
            list.listname = name;
          // 5
            
            guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
              print("Query result is nil")
                return  listarray;
            }
            let name2 = String(cString: queryResultCol2)
              list.itemname = name2;
            
            
            list.quantity = Int(sqlite3_column_int(queryStatement, 3));
            list.cost = sqlite3_column_double(queryStatement, 4);
            list.bought = Int(sqlite3_column_int(queryStatement, 5));
            listarray.append(list);
            
          print("\nQuery Result:")
            print("\(id) | \(name)| \(name2)| \(list.quantity)| \(list.cost)")
      
      }
      }
      // 7
      sqlite3_finalize(queryStatement)
//        print(list)
        return listarray;
    }
    
    func getlistnames() -> [String]{

        var listarray = [String]();
        let queryStatementString = "SELECT distinct listname FROM " + TABLE + ";"

      var queryStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
          SQLITE_OK {
        // 2
        while sqlite3_step(queryStatement) == SQLITE_ROW {
          
          
          
            
          guard let queryResultCol1 = sqlite3_column_text(queryStatement, 0) else {
            print("Query result is nil")
              return  listarray;
          }
          let name = String(cString: queryResultCol1)
            listarray.append(name);
          // 5
            
           
      
      }
      }
      // 7
      sqlite3_finalize(queryStatement)
//        print(list)
        return listarray;
    }
    
    func deletedata(listname : String){
        let deleteStatementString = "DELETE FROM listtable where listname = '" + listname + "';"

      var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
              SQLITE_OK {
            while sqlite3_step(deleteStatement) == SQLITE_DONE {
              print("\nSuccessfully deleted row.")
            }
          } else {
            print("\nDELETE statement could not be prepared")
          }
          
          sqlite3_finalize(deleteStatement)
        
        var list = getFavouriteList()
        
        if (list.count == 0){
            UserDefaults(suiteName:"group.ca.singhs.grocerylist-ios")?.set( "Not Set", forKey: "fav")
            return
        }
        
        UserDefaults(suiteName:"group.ca.singhs.grocerylist-ios")?.set( list[0].listname, forKey: "fav")
        WidgetCenter.shared.reloadAllTimelines()
    }
    

    
}
