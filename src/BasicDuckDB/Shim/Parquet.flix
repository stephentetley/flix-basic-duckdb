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


pub mod BasicDuckDB.Shim.Parquet {

    
    use BasicDuckDB.DuckDBDriver.{DuckDBDriver}
    use BasicDuckDB.DuckDBConnection.{DuckDBConnection}
    use BasicDuckDB.DuckDBResultSet.{DuckDBResultSet}
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.JDBC.Statement.{Statement}
    use BasicDuckDB.Shim.ParquetOption.ParquetOption
    use BasicDuckDB.Shim.Internal.Utils.{printOptions}
    
    // TODO multiple files... Output...

    pub def forEach(reader: Unit -> a \ ReadRowWithAlt + ef, file_name: String, opts: List[ParquetOption]): Result[IoError, Unit] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement + ReadRowWithAlt} = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_parquet('${file_name}'${printOptions(opts)});";
        Result.flatten(Result.flatten(run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.queryForEach(reader, sql)
            }) 
        } with BasicDuckDB.DuckDBDriver.runWithIO))
    
    pub def fold(reader: a -> a \ ReadRowWithAlt + ef, 
                    s: a, 
                    file_name: String, 
                    opts: List[ParquetOption]): Result[IoError, a] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement} = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_parquet('${file_name}')${printOptions(opts)};";
        Result.flatten(Result.flatten(run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.queryFold(reader, s, sql)
            }) 
        } with BasicDuckDB.DuckDBDriver.runWithIO))


    pub def load_facts(reader: Unit -> #{ | r } \ ReadRowWithAlt + ef, file_name: String, opts: List[ParquetOption]): Result[IoError, #{ | r }] \ {IO + ef} - {DuckDBConnection + DuckDBDriver + DuckDBResultSet + Statement} = 
        fold(acc -> { let row1 = reader(); acc <+> row1 }, #{}, file_name, opts)




}
