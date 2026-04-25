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

    
    use BasicDuckDB.DuckDBDriver.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.JDBC.Statement.Statement

    
    pub def forEach(reader: Unit -> a \ ReadRowWithAlt + ef, 
                    file_name: String, 
                    table_name: {table_name = String}): Result[String, Unit] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement + ReadRowWithAlt} = 
        let url = "jdbc:duckdb:";
        let sql1 = "ATTACH '${file_name}' AS temp_sqlite_db (TYPE sqlite); USE temp_sqlite_db;";
        let sql2 = "SELECT * FROM temp_sqlite_db.${table_name#table_name};";
        let sql3 = "USE memory; DETACH temp_sqlite_db;";
        Result.flatten(Result.flatten(run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                let _ = Script.executeUpdate(sql1);
                let ans = BasicDuckDB.DuckDBConnection.queryForEach(reader, sql2);
                let _ = Script.executeUpdate(sql3);
                ans
            }) 
        } with BasicDuckDB.DuckDBDriver.runWithIO))
    
    pub def fold(reader: a -> a \ ReadRowWithAlt + ef, 
                    s: a, 
                    file_name: String, 
                    table_name: {table_name=String}): Result[String, a] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement} = 
        let url = "jdbc:duckdb:";
        let sql1 = "ATTACH '${file_name}' AS temp_sqlite_db (TYPE sqlite); USE temp_sqlite_db;";
        let sql2 = "SELECT * FROM temp_sqlite_db.${table_name#table_name};";
        let sql3 = "USE memory; DETACH temp_sqlite_db;";
        Result.flatten(Result.flatten(run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                let _ = Script.executeUpdate(sql1);
                let ans = BasicDuckDB.DuckDBConnection.queryFold(reader, s, sql2);
                let _ = Script.executeUpdate(sql3);
                ans
            }) 
        } with BasicDuckDB.DuckDBDriver.runWithIO))


    pub def load_facts(reader: Unit -> #{ | r } \ ReadRowWithAlt + ef, 
                        file_name: String, 
                        table_name: { table_name = String }): Result[String, #{ | r }] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement} = 
        fold(acc -> { let row1 = reader(); acc <+> row1 }, #{}, file_name, table_name)




}
