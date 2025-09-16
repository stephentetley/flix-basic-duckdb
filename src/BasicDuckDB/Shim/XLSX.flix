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


mod BasicDuckDB.Shim.XLSX {



    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet
    use BasicDuckDB.RowReader
    use BasicDuckDB.JDBC.Statement
    
    pub def forEach(f: Unit -> Unit \ ef, file_name: String): Result[IoError, Unit] \ ((~(IO + DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement + RowReader)) & ef) + IO = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_xlsx('${file_name}');";
        Result.flatten(Result.flatten(run {
            DuckDBDriver.execDuckDBConnection(url, () -> {
                DuckDBConnection.queryForEach(f, sql)
            }) 
        } with DuckDBDriver.runWithIO))
    
    pub def fold(f: a -> a \ ef, s: a, file_name: String): Result[IoError, a] \ ((~(IO + DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement + RowReader)) & ef) + IO = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_xlsx('${file_name}');";
        Result.flatten(Result.flatten(run {
            DuckDBDriver.execDuckDBConnection(url, () -> {
                DuckDBConnection.queryFold(f, s, sql)
            }) 
        } with DuckDBDriver.runWithIO))

}
