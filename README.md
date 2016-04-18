# SQLiteViewer_osX


A Simple SQLite database viewer for OS X.  Needed one and didn't like any of the options available so I made my own.

Design:

  * A Tables TableViews
    * This tableView shows the tables found in the sqlite database, will update this to a outline view eventually
  * A tab view with three tabs
    * Holds the tableview to view the data stored in the database tables.  This includes a table's data and query results
    * Will implement viewing the schema eventually.
  * Singleton SQLiteDatabaseHelper
    * Only need one connection to the database.
  * The rest is self explanitory. If you have any questions let me know.



Further Development:

 * Will eventually add sqlite editing/saving, but as of right now this is missing.
