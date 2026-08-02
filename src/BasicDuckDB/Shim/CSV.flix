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


pub mod BasicDuckDB.Shim.CSV {

    use EffectExtras.Fail.Fail
    use BasicDuckDB.{ResultSetRow}
    use BasicDuckDB.DuckDBDriver.{DuckDBDriver}
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.DuckDBConnection.{DuckDBConnection}
    use BasicDuckDB.DuckDBResultSet.{DuckDBResultSet}
    use BasicDuckDB.JDBCStatement.{JDBCStatement}
    use BasicDuckDB.Shim.CSVOption.CSVOption
    use BasicDuckDB.Shim.Internal.Utils.{printOptions}
    

    pub def forEach(reader: ResultSetRow -> Unit \ ef, 
                    file_name: String, 
                    opts: List[CSVOption]): Result[IoError, Unit] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet = 
        let sql = "SELECT * FROM read_csv('${file_name}'${printOptions(opts)});";
        run {
            BasicDuckDB.JDBCStatement.forEachQuery(sql, reader)
        } with BasicDuckDB.JDBCStatement.runJDBCStatement1
          with BasicDuckDB.DuckDBConnection.runInMemoryDuckDBConnection
          with BasicDuckDB.DuckDBDriver.runDuckDBDriver 
    
    pub def fold(reader: ResultSetRow -> a -> a \ ef, 
                    s: a, 
                    file_name: String, 
                    opts: List[CSVOption]): Result[IoError, a] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet = 
        let sql = "SELECT * FROM read_csv('${file_name}'${printOptions(opts)});";
        run {
            BasicDuckDB.JDBCStatement.foldQuery(sql, reader, s)
        } with BasicDuckDB.JDBCStatement.runJDBCStatement1
          with BasicDuckDB.DuckDBConnection.runInMemoryDuckDBConnection
          with BasicDuckDB.DuckDBDriver.runDuckDBDriver 

    pub def loadFacts(reader: ResultSetRow -> #{ | r } \  ef, 
                        file_name: String, 
                        opts: List[CSVOption]): Result[IoError, #{ | r }] \ {IO + ef} - Fail - DuckDBDriver - DuckDBConnection - JDBCStatement - DuckDBResultSet =  
        fold((row, acc) -> { let ans = reader(row); acc <+> ans }, #{}, file_name, opts)


    pub def exportCSV(tableSpec: {create_table = String, schema_name = String, table_name = String},
                        file_name: String,
                        opts: List[CSVOption], 
                        appender: a -> Unit \ ef,
                        t: t): Result[IoError, Unit] \ {ef + IO + ForEach.Aef[t]} - Fail - DuckDBDriver - DuckDBConnection - JDBCStatement - DuckDBAppender with ForEach[t]  where ForEach.Elm[t] ~ a = 
        let opts1 = match opts {
            case Nil => ""
            case _   => " (${printOptions(opts)})"
        };
        let sql = "COPY ${tableSpec#schema_name}.${tableSpec#table_name} TO '${file_name}'${opts1};";
        run {
            discard JDBCStatement.execute(tableSpec#create_table);
            BasicDuckDB.DuckDBConnection.execDuckDBAppender(
                tableSpec#schema_name, 
                tableSpec#table_name, 
                () -> foreach (item <- t) appender(item) 
            );
            discard JDBCStatement.execute(sql)
        } with BasicDuckDB.JDBCStatement.runJDBCStatement1
          with BasicDuckDB.DuckDBConnection.runInMemoryDuckDBConnection
          with BasicDuckDB.DuckDBDriver.runDuckDBDriver


}

