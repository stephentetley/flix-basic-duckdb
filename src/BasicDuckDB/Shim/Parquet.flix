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
    use BasicDuckDB.{ResultSetRow}
    use BasicDuckDB.DuckDBDriver.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.JDBCStatement.JDBCStatement
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.Shim.ParquetOption.ParquetOption
    use BasicDuckDB.Shim.Internal.Utils.{printOptions}
    
    // TODO multiple files... Output...

    pub def forEach(reader: ResultSetRow -> Unit \ ef, 
                    file_name: String, 
                    opts: List[ParquetOption]): Result[IoError, Unit] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet  = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_parquet('${file_name}'${printOptions(opts)});";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, conn -> {
                BasicDuckDB.DuckDBConnection.runDuckDBConnection(conn, () -> {
                    BasicDuckDB.DuckDBConnection.forEachQuery(sql, reader)
                })
            }) 
        } with BasicDuckDB.DuckDBDriver.runDuckDBDriver 
    
    pub def fold(reader: ResultSetRow -> a -> a \ ef, 
                    s: a, 
                    file_name: String, 
                    opts: List[ParquetOption]): Result[IoError, a] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet  = 
        let url = "jdbc:duckdb:";
        let sql = "SELECT * FROM read_parquet('${file_name}')${printOptions(opts)};";
        run {
            BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, conn -> {
                BasicDuckDB.DuckDBConnection.runDuckDBConnection(conn, () -> {
                    BasicDuckDB.DuckDBConnection.foldQuery(sql, reader, s)
                })
            }) 
        } with BasicDuckDB.DuckDBDriver.runDuckDBDriver 


    pub def loadFacts(reader: ResultSetRow -> #{ | r } \ ef, 
                        file_name: String, 
                        opts: List[ParquetOption]): Result[IoError, #{ | r }] \ {IO + ef} - DuckDBDriver - Fail - DuckDBConnection - JDBCStatement - DuckDBResultSet = 
        fold((row, acc) -> { let ans = reader(row); acc <+> ans }, #{}, file_name, opts)


    pub def exportParquet(tableSpec: {create_table = String, schema_name = String, table_name = String},
                        file_name: String,
                        opts: List[ParquetOption], 
                        appender: a -> Unit \ ef,
                        t: t): Result[IoError, Unit] \ {ef + IO + ForEach.Aef[t]} - Fail - DuckDBDriver - DuckDBConnection - DuckDBAppender with ForEach[t]  where ForEach.Elm[t] ~ a = 
        let opts1 = match opts {
            case Nil => ""
            case _   => " (${printOptions(opts)})"
        };
        let sql = "COPY ${tableSpec#schema_name}.${tableSpec#table_name} TO '${file_name}'${opts1};";
        run {
            BasicDuckDB.DuckDBDriver.execInMemoryDuckDBConnection(conn -> {
                BasicDuckDB.DuckDBConnection.runDuckDBConnection(conn, () -> {
                    BasicDuckDB.DuckDBConnection.execStatement(stmt -> {
                        BasicDuckDB.JDBCStatement.runJDBCStatement(stmt, () -> {
                            discard JDBCStatement.execute(tableSpec#create_table)
                        })
                    });
                    BasicDuckDB.DuckDBConnection.execDuckDBAppender(
                        tableSpec#schema_name, 
                        tableSpec#table_name, 
                        () -> foreach (item <- t) appender(item) 
                    );
                    BasicDuckDB.DuckDBConnection.execStatement(stmt -> {
                        BasicDuckDB.JDBCStatement.runJDBCStatement(stmt, () -> {
                            discard JDBCStatement.execute(sql)
                        })
                    })
                })
            })
        } with BasicDuckDB.DuckDBDriver.runDuckDBDriver


}
