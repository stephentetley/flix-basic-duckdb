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




pub mod BasicDuckDB.JDBCStatement {
    use BasicDuckDB.JDBCStatement
    use BasicDuckDB.JDBC.ResultSet
    
    use EffectExtras.Fail.Fail
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.{ResultSet, ResultSetRow, Statement}

    import java.sql.{SQLException => JSQLException}
    import java.sql.{Statement => JStatement}
    import org.duckdb.{DuckDBResultSet => JDuckDBResultSet}


    pub eff JDBCStatement {
        def getMaxRows(): Int32
        def setMaxRows(maxRows: Int32): Unit
        def cancel(): Unit
        def execute(sql: String): Bool
        def executeUpdate(sql: String): Int32
        def executeLargeUpdate(sql: String): Int64
        def executeQuery(sql: String): ResultSet
        def closeResultSet(results: ResultSet): Unit
        // def getResultSet(): ResultSetHandle
        def enquoteLiteral(sql: String): String
        def isClosed(): Bool
        def isCloseOnCompletion(): Bool
    }

    
    pub def handle(stmt: Statement, 
                    f: a -> b \ ef): a -> b \ {ef + Fail} - JDBCStatement = x -> {
        let jstmt = ToJava.toJava(stmt); 
        run {
            f(x)
        } with handler JDBCStatement {
        

            def getMaxRows(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.getMaxRows() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setMaxRows(maxRows, k) = 
                try {
                    unsafe IO as {ef + Fail - JDBCStatement} { jstmt.setMaxRows(maxRows) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def cancel(k) = 
                try {
                    unsafe IO as {ef + Fail - JDBCStatement} { jstmt.cancel() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def execute(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.execute(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def executeUpdate(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.executeUpdate(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def executeLargeUpdate(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.executeLargeUpdate(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def executeQuery(sql, k) = 
                try {
                    let jdbcResults = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.executeQuery(sql) };
                    let results = unchecked_cast(jdbcResults as JDuckDBResultSet);
                    k(ToFlix.toFlix(results))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def closeResultSet(results, k) = 
                try {
                    let jresults = ToJava.toJava(results);
                    unsafe IO as {ef + Fail - JDBCStatement} { jresults.close() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def enquoteLiteral(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.enquoteLiteral(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isClosed(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.isClosed() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isCloseOnCompletion(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - JDBCStatement} { jstmt.isCloseOnCompletion() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
        }
    }

    pub def runJDBCStatement(stmt: Statement, f: Unit -> a \ ef): a \ {ef + Fail} - JDBCStatement = 
        handle(stmt, f)()

    pub def scalarQuery(sql: String, 
                            f: ResultSetRow -> a \ ef): a \ ef + Fail + JDBCStatement - DuckDBResultSet = 
        let results = JDBCStatement.executeQuery(sql);
        let ans = BasicDuckDB.DuckDBResultSet.firstResult(f, results);
        JDBCStatement.closeResultSet(results);
        ans

    pub def forEachQuery(sql: String, 
                            f: ResultSetRow -> Unit \ ef): Unit \ ef + Fail + JDBCStatement - DuckDBResultSet = 
        let results = JDBCStatement.executeQuery(sql);
        let ans = BasicDuckDB.DuckDBResultSet.forEachRow(f, results);
        JDBCStatement.closeResultSet(results);
        ans

    pub def foldQuery(sql: String, f: ResultSetRow -> s -> s \ ef, st: s): s \ ef + Fail + JDBCStatement - DuckDBResultSet = 
        let results = JDBCStatement.executeQuery(sql);
        let ans = BasicDuckDB.DuckDBResultSet.fold(f, st, results);
        JDBCStatement.closeResultSet(results);
        ans

}
