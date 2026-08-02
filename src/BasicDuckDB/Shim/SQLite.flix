/*
 * Copyright 2025 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


pub mod BasicDuckDB.Shim.SQLite {
    

    
    use EffectExtras.Fail.Fail
    use BasicDuckDB.{ResultSetRow}
    use BasicDuckDB.DuckDBDriver.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.JDBCStatement.JDBCStatement
    use BasicDuckDB.RowReader.RowReaderWithAlt

    
    pub def forEach(reader: ResultSetRow -> Unit \ ef, 
                    file_name: String, 
                    table_name: {table_name = String}): Result[IoError, Unit] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet  = 
        let url = "jdbc:duckdb:";
        let sql1 = "ATTACH '${file_name}' AS temp_sqlite_db (TYPE sqlite); USE temp_sqlite_db;";
        let sql2 = "SELECT * FROM temp_sqlite_db.${table_name#table_name};";
        let sql3 = "USE memory; DETACH temp_sqlite_db;";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard JDBCStatement.executeUpdate(sql1));
                let ans = BasicDuckDB.DuckDBConnection.forEachQuery(sql2, reader);
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard JDBCStatement.executeUpdate(sql3));
                ans
            }) 
        }  with BasicDuckDB.DuckDBDriver.runDuckDBDriver 
    
    pub def fold(reader: a -> a \ ef, 
                    s: a, 
                    file_name: String, 
                    table_name: {table_name = String}): Result[IoError, a] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet - RowReaderWithAlt = 
        let url = "jdbc:duckdb:";
        let sql1 = "ATTACH '${file_name}' AS temp_sqlite_db (TYPE sqlite); USE temp_sqlite_db;";
        let sql2 = "SELECT * FROM temp_sqlite_db.${table_name#table_name};";
        let sql3 = "USE memory; DETACH temp_sqlite_db;";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard JDBCStatement.executeUpdate(sql1));
                let ans = BasicDuckDB.DuckDBConnection.foldQuery(sql2, reader, s);
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard JDBCStatement.executeUpdate(sql3));
                ans
            }) 
        }  with BasicDuckDB.DuckDBDriver.runDuckDBDriver 


    pub def loadFacts(reader: Unit -> #{ | r } \ ef, 
                        file_name: String, 
                        table_name: { table_name = String }): Result[IoError, #{ | r }] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet - RowReaderWithAlt = 
        fold(acc -> { let row = reader(); acc <+> row }, #{}, file_name, table_name)




}
