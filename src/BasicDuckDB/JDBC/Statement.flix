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




pub mod BasicDuckDB.JDBC.Statement {
    
    use EffectExtras.Fail.Fail
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSetHandle
    use BasicDuckDB.RowReader.RowReaderWithAlt

    import java.sql.{SQLException => JSQLException}
    import java.sql.{Statement => JStatement}
    import org.duckdb.{DuckDBResultSet => JDuckDBResultSet}


    pub eff Statement {
        def getMaxRows(): Int32
        def setMaxRows(maxRows: Int32): Unit
        def cancel(): Unit
        def execute(sql: String): Bool
        def executeUpdate(sql: String): Int32
        def executeLargeUpdate(sql: String): Int64
        def executeQuery(sql: String): DuckDBResultSetHandle
        def closeResultSet(results: DuckDBResultSetHandle): Unit
        // def getResultSet(): ResultSetHandle
        def enquoteLiteral(sql: String): String
        def isClosed(): Bool
        def isCloseOnCompletion(): Bool
    }

    pub enum StatementHandle (JStatement)
    
    pub def handle(stmt: StatementHandle, 
                    f: a -> b \ ef): a -> b \ {ef + Fail} - Statement = x -> {
        let StatementHandle.StatementHandle(jstmt) = stmt; 
        run {
            f(x)
        } with handler Statement {
        

            def getMaxRows(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - Statement} { jstmt.getMaxRows() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setMaxRows(maxRows, k) = 
                try {
                    unsafe IO as {ef + Fail - Statement} { jstmt.setMaxRows(maxRows) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def cancel(k) = 
                try {
                    unsafe IO as {ef + Fail - Statement} { jstmt.cancel() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def execute(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - Statement} { jstmt.execute(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def executeUpdate(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - Statement} { jstmt.executeUpdate(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def executeLargeUpdate(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - Statement} { jstmt.executeLargeUpdate(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def executeQuery(sql, k) = 
                try {
                    let jdbcResults = unsafe IO as {ef + Fail - Statement} { jstmt.executeQuery(sql) };
                    let results = unchecked_cast(jdbcResults as JDuckDBResultSet);
                    k(DuckDBResultSetHandle.DuckDBResultSetHandle(results))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def closeResultSet(results, k) = 
                try {
                    let DuckDBResultSetHandle.DuckDBResultSetHandle(jresults) = results;
                    unsafe IO as {ef + Fail - Statement} { jresults.close() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def enquoteLiteral(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - Statement} { jstmt.enquoteLiteral(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isClosed(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - Statement} { jstmt.isClosed() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isCloseOnCompletion(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - Statement} { jstmt.isCloseOnCompletion() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
        }
    }

    pub def runStatement(stmt: StatementHandle, f: Unit -> a \ ef): a \ {ef + Fail} - Statement = 
        handle(stmt, f)()

    pub def scalarQuery(sql: String, 
                            f: Unit -> a \ ef): a \ {ef + Fail + Statement} - DuckDBResultSet - RowReaderWithAlt = 
        let results = Statement.executeQuery(sql);
        let ans = BasicDuckDB.DuckDBResultSet.runDuckDBResultSet(results, _ -> BasicDuckDB.DuckDBResultSet.execReadRow(f));
        Statement.closeResultSet(results);
        ans

    pub def forEachQuery(sql: String, 
                            f: Unit -> Unit \ ef): Unit \ {ef + Fail + Statement} - DuckDBResultSet - RowReaderWithAlt = 
        let results = Statement.executeQuery(sql);
        let ans = BasicDuckDB.DuckDBResultSet.runDuckDBResultSet(results, _ -> BasicDuckDB.DuckDBResultSet.forEach(f));
        Statement.closeResultSet(results);
        ans

    pub def foldQuery(sql: String, f: s -> s \ ef, st: s): s \ {ef + Fail + Statement} - DuckDBResultSet - RowReaderWithAlt = 
        let results = Statement.executeQuery(sql);
        let ans = BasicDuckDB.DuckDBResultSet.runDuckDBResultSet(results, _ -> BasicDuckDB.DuckDBResultSet.fold(f, st));
        Statement.closeResultSet(results);
        ans

}
