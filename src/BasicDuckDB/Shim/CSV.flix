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


mod BasicDuckDB.Shim.CSV {


    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet
    use BasicDuckDB.RowReader
    use BasicDuckDB.JDBC.Statement
    use BasicDuckDB.Shim.CSVOption
    use BasicDuckDB.Shim.Internal.Utils.{printOptions}
    
    // TODO multiple files... Output...

    pub def forEach(reader: RowReader[a, ef], file_name: String, opts: List[CSVOption]): Result[IoError, Unit] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement} = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_csv('${file_name}'${printOptions(opts)});";
        Result.flatten(Result.flatten(run {
            DuckDBDriver.execDuckDBConnection(url, () -> {
                DuckDBConnection.queryForEach(reader, sql)
            }) 
        } with DuckDBDriver.runWithIO))
    
    pub def fold(reader: RowReader[b, ef], f: (a, b) -> a \ ef1, s: a, file_name: String, opts: List[CSVOption]): Result[IoError, a] \ {IO + ef + ef1} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement} =  
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_csv('${file_name}'${printOptions(opts)});";
        Result.flatten(Result.flatten(run {
            DuckDBDriver.execDuckDBConnection(url, () -> {
                DuckDBConnection.queryFold(reader, f, s, sql)
            }) 
        } with DuckDBDriver.runWithIO))

    pub def load_facts(reader: RowReader[#{ | r }, ef], file_name: String, opts: List[CSVOption]): Result[IoError, #{ | r }] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement} = 
        fold(reader, (acc, b) -> acc <+> b, #{}, file_name, opts)
        
}
