# SQLiteViewer_osX


A Simple SQLite database viewer for OS X.  Needed one and didn't like any of the options available so I made my own.

Design:

  * 2 TableViews
    * One for viewing the SQLite tables in the database.
    * One for viewing the data.
  * Singleton SQLiteDatabaseHelper
    * Only need one connection to the database.
  * The rest is self explanitory.



Further Development:

 * Will eventually add sqlite editing/saving, but as of right now this is missing.
 * Will eventually add query support.  The system for this is already set up with the "query" function in SQLiteDatabaseHelper
