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


pub mod BasicDuckDB.Shim.XLSX {

    use EffectExtras.Fail.Fail
    use BasicDuckDB.{ResultSetRow}
    use BasicDuckDB.DuckDBDriver.{DuckDBDriver}
    use BasicDuckDB.DuckDBConnection.{DuckDBConnection}
    use BasicDuckDB.DuckDBResultSet.{DuckDBResultSet}
    use BasicDuckDB.JDBCStatement.{JDBCStatement}
    use BasicDuckDB.Shim.XLSXOption.XLSXOption
    use BasicDuckDB.Shim.Internal.Utils.{printOptions}
    
    pub def forEachRow(reader: ResultSetRow -> Unit \ ef, 
                    file_name: String, 
                    opts: List[XLSXOption]): Result[IoError, Unit] \ IO + ef - DuckDBConnection - Fail - DuckDBDriver - DuckDBResultSet - JDBCStatement = 
        let sql = "SELECT * FROM read_xlsx('${file_name}'${printOptions(opts)});";
        run {
            BasicDuckDB.JDBCStatement.forEachQuery(sql, reader)
        } with BasicDuckDB.JDBCStatement.runJDBCStatement1
          with BasicDuckDB.DuckDBConnection.runInMemoryDuckDBConnection
          with BasicDuckDB.DuckDBDriver.runDuckDBDriver
    

    pub def fold(reader: ResultSetRow -> a -> a \ ef, 
                    s: a, 
                    file_name: String, 
                    opts: List[XLSXOption]): Result[IoError, a] \ IO + ef - DuckDBConnection - Fail - DuckDBDriver - DuckDBResultSet - JDBCStatement = 
        let sql = "SELECT * FROM read_xlsx('${file_name}')${printOptions(opts)};";
        run {
            BasicDuckDB.JDBCStatement.foldQuery(sql, reader, s)
        } with BasicDuckDB.JDBCStatement.runJDBCStatement1
          with BasicDuckDB.DuckDBConnection.runInMemoryDuckDBConnection
          with BasicDuckDB.DuckDBDriver.runDuckDBDriver 


    pub def loadFacts(reader: ResultSetRow -> #{ | r } \ ef, 
                        file_name: String, 
                        opts: List[XLSXOption]): Result[IoError, #{ | r }] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet = 
        fold((row, acc) -> { let row1 = reader(row); acc <+> row1 }, #{}, file_name, opts)
    

}
