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
    

    
    use BasicDuckDB.Base.Fail.Fail
    use BasicDuckDB.DuckDBDriver.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.JDBC.Statement.Statement

    
    pub def forEach(reader: Unit -> Unit \ ReadRowWithAlt + ef, 
                    file_name: String, 
                    table_name: {table_name = String}): Result[IoError, Unit] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - Statement - DuckDBResultSet = 
        let url = "jdbc:duckdb:";
        let sql1 = "ATTACH '${file_name}' AS temp_sqlite_db (TYPE sqlite); USE temp_sqlite_db;";
        let sql2 = "SELECT * FROM temp_sqlite_db.${table_name#table_name};";
        let sql3 = "USE memory; DETACH temp_sqlite_db;";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard Statement.executeQuery(sql1));
                let ans = BasicDuckDB.DuckDBConnection.queryForEach(reader, sql2);
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard Statement.executeQuery(sql3));
                ans
            }) 
        }  with BasicDuckDB.DuckDBDriver.runWithIOAndFail 
    
    pub def fold(reader: a -> a \ ReadRowWithAlt + ef, 
                    s: a, 
                    file_name: String, 
                    table_name: {table_name = String}): Result[IoError, a] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - Statement - DuckDBResultSet = 
        let url = "jdbc:duckdb:";
        let sql1 = "ATTACH '${file_name}' AS temp_sqlite_db (TYPE sqlite); USE temp_sqlite_db;";
        let sql2 = "SELECT * FROM temp_sqlite_db.${table_name#table_name};";
        let sql3 = "USE memory; DETACH temp_sqlite_db;";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard Statement.executeQuery(sql1));
                let ans = BasicDuckDB.DuckDBConnection.queryFold(reader, s, sql2);
                BasicDuckDB.DuckDBConnection.execStatement(() -> discard Statement.executeQuery(sql3));
                ans
            }) 
        }  with BasicDuckDB.DuckDBDriver.runWithIOAndFail 


    pub def load_facts(reader: Unit -> #{ | r } \ ReadRowWithAlt + ef, 
                        file_name: String, 
                        table_name: { table_name = String }): Result[IoError, #{ | r }] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - Statement - DuckDBResultSet = 
        fold(acc -> { let row = reader(); acc <+> row }, #{}, file_name, table_name)




}
