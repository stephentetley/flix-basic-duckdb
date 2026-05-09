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

    use EffectExtras.Fail.Fail
    use BasicDuckDB.DuckDBDriver.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.JDBC.Statement.Statement
    use BasicDuckDB.Shim.ParquetOption.ParquetOption
    use BasicDuckDB.Shim.Internal.Utils.{printOptions}
    
    // TODO multiple files... Output...

    pub def forEach(reader: Unit -> Unit \ ef, 
                    file_name: String, 
                    opts: List[ParquetOption]): Result[IoError, Unit] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - Statement - DuckDBResultSet - ReadRowWithAlt = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_parquet('${file_name}'${printOptions(opts)});";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.forEachQuery(sql, reader)
            }) 
        } with BasicDuckDB.DuckDBDriver.runWithIOAndFail 
    
    pub def fold(reader: a -> a \ ef, 
                    s: a, 
                    file_name: String, 
                    opts: List[ParquetOption]): Result[IoError, a] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - Statement - DuckDBResultSet - ReadRowWithAlt= 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_parquet('${file_name}')${printOptions(opts)};";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                BasicDuckDB.DuckDBConnection.foldQuery(sql, reader, s)
            }) 
        } with BasicDuckDB.DuckDBDriver.runWithIOAndFail 


    pub def load_facts(reader: Unit -> #{ | r } \ ef, 
                        file_name: String, 
                        opts: List[ParquetOption]): Result[IoError, #{ | r }] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - Statement - DuckDBResultSet - ReadRowWithAlt= 
        fold(acc -> { let row1 = reader(); acc <+> row1 }, #{}, file_name, opts)




}
