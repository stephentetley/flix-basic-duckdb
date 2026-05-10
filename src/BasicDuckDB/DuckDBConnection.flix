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



pub mod BasicDuckDB.DuckDBConnection {
    use BasicDuckDB.DuckDBConnection

    use EffectExtras.Fail.Fail
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.DuckDBAppender.DuckDBAppenderHandle
    use BasicDuckDB.DuckDBPreparedStatement.DuckDBPreparedStatement
    use BasicDuckDB.DuckDBPreparedStatement.DuckDBPreparedStatementHandle
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSet
    use BasicDuckDB.JDBC.Statement.Statement
    use BasicDuckDB.JDBC.Statement.StatementHandle
    use BasicDuckDB.RowReader.RowReaderWithAlt
    use BasicDuckDB.DuckDBScalarFunctionBuilder.DuckDBScalarFunctionBuilder

    import java.sql.{Connection => JConnection}
    import java.sql.{Statement => JStatement}
    import java.sql.{SQLException => JSQLException}
    import org.duckdb.{DuckDBPreparedStatement => JDuckDBPreparedStatement}
    import org.duckdb.{DuckDBConnection => JDuckDBConnection}
    


    pub eff DuckDBConnection {
        // `DuckDBConnectionHandle` should not be used in user code
        // It is a hack until we can run local effects polymorphically
        def askDuckDBConnectionHandle(): DuckDBConnectionHandle        
        def createStatement(): StatementHandle
        def closeStatement(stmt: StatementHandle): Unit
        def prepareStatement(sql: String): DuckDBPreparedStatementHandle
        def closePreparedStatement(stmt: DuckDBPreparedStatementHandle): Unit
        def createAppender(schemaName: String, tableName: String): DuckDBAppenderHandle
        def closeAppender(appender: DuckDBAppenderHandle): Unit
        def nativeSQL(sql: String): String
        def setAutoCommit(autoCommit: Bool): Unit
        def getAutoCommit(): Bool
        def commit(): Unit
        def rollback(): Unit
        def isClosed(): Bool
        def isValid(timeout: Int32): Bool
        def isReadOnly(): Bool
        def setReadOnly(readOnly: Bool): Unit
        def getCatalog(): String
        def setCatalog(catalog: String): Unit
        def getTransactionIsolation(): Int32
        def setTransactionIsolation(level: Int32): Unit
    }

    pub enum DuckDBConnectionHandle(JDuckDBConnection)
    
    pub def handle(conn: DuckDBConnectionHandle, 
                    f: a -> b \ ef): a -> b \ ef + Fail - DuckDBConnection = x -> {
        let DuckDBConnectionHandle.DuckDBConnectionHandle(jconn) = conn;
        run {
            f(x)
        } with handler DuckDBConnection {
        
            def askDuckDBConnectionHandle(k) = k(conn)

            def createStatement(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.createStatement() };
                    k(StatementHandle.StatementHandle(ans))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
            def closeStatement(stmt, k) = 
                try {
                    let StatementHandle.StatementHandle(jstmt) = stmt;
                    unsafe IO as {ef + Fail - DuckDBConnection} { jstmt.close() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def prepareStatement(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.prepareStatement(sql) };
                    let ans1 = unchecked_cast(ans as JDuckDBPreparedStatement);
                    k(DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(ans1))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def closePreparedStatement(stmt, k) = 
                try {
                    let DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(jstmt) = stmt;
                    unsafe IO as {ef + Fail - DuckDBConnection} { jstmt.close() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }


            def createAppender(schema, table, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.createAppender(schema, table) };
                    k(DuckDBAppenderHandle.DuckDBAppenderHandle(ans))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def closeAppender(appender, k) = 
                try {
                    let DuckDBAppenderHandle.DuckDBAppenderHandle(jappender) = appender;
                    unsafe IO as {ef + Fail - DuckDBConnection} { jappender.close() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }


            def nativeSQL(sql, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.nativeSQL(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setAutoCommit(ac, k) = 
                try {
                    unsafe IO as {ef + Fail - DuckDBConnection} { jconn.setAutoCommit(ac) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def getAutoCommit(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.getAutoCommit() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def commit(k) = 
                try {
                    unsafe IO as {ef + Fail - DuckDBConnection} { jconn.commit() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def rollback(k) = 
                try {
                    unsafe IO as {ef + Fail - DuckDBConnection} { jconn.rollback() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isClosed(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.isClosed() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isValid(timeout, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.isValid(timeout) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isReadOnly(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.isReadOnly() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setReadOnly(ro, k) = 
                try {
                    unsafe IO as {ef + Fail - DuckDBConnection} { jconn.setReadOnly(ro) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def getCatalog(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.getCatalog() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setCatalog(c, k) = 
                try {
                    unsafe IO as {ef + Fail - DuckDBConnection} { jconn.setCatalog(c) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def getTransactionIsolation(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBConnection} { jconn.getTransactionIsolation() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setTransactionIsolation(l, k) = 
                try {
                    unsafe IO as {ef + Fail - DuckDBConnection} { jconn.setTransactionIsolation(l) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

        }

    }
    
    pub def runDuckDBConnection(conn: DuckDBConnectionHandle, 
                                f: Unit -> a \ ef): a \ ef + Fail - DuckDBConnection = 
        handle(conn, f)()

    
    pub def execStatement(f: Unit -> a \ ef): a \ {ef + Fail + DuckDBConnection} - Statement = 
        let stmt = DuckDBConnection.createStatement();
        let ans = run { 
            f() 
        } with BasicDuckDB.JDBC.Statement.runStatement(stmt);
        DuckDBConnection.closeStatement(stmt);
        ans

    pub def execDuckDBPreparedStatement(sql: String, 
                                        f: Unit -> a \ ef): a \ {ef + Fail + DuckDBConnection} - DuckDBPreparedStatement = 
        let stmt = DuckDBConnection.prepareStatement(sql);
        let ans = run {
            f()
        } with BasicDuckDB.DuckDBPreparedStatement.runDuckDBPreparedStatement(stmt);
        DuckDBConnection.closePreparedStatement(stmt);
        ans


    pub def execDuckDBAppender(schema: String, 
                                table: String, 
                                f: Unit -> a \ ef): a \ {ef + Fail + DuckDBConnection} - DuckDBAppender = 
        let app = DuckDBConnection.createAppender(schema, table);
        let ans = BasicDuckDB.DuckDBAppender.runDuckDBAppender(app, f);
        DuckDBConnection.closeAppender(app);
        ans 

    
    pub def execDuckDBScalarFunctionBuilder(f: Unit -> a \ ef): a \ {ef + Fail + DuckDBConnection} - DuckDBScalarFunctionBuilder= 
        let conn = DuckDBConnection.askDuckDBConnectionHandle();
        BasicDuckDB.DuckDBScalarFunctionBuilder.runDuckDBScalarFunctionBuilder(conn, f)
        
    pub def scalarQuery(sql: String, f: Unit -> a \ ef): a \ {ef + Fail + DuckDBConnection} - RowReaderWithAlt - Statement - DuckDBResultSet  = 
        execStatement(_ -> BasicDuckDB.JDBC.Statement.scalarQuery(sql, f))

    // cf. ```f: (<row>, a) -> a``` but <row> is implicit
    pub def foldQuery(sql: String, f: a -> a \ ef, s: a): a \ {ef + Fail + DuckDBConnection} - RowReaderWithAlt - Statement - DuckDBResultSet  = 
        execStatement(_ -> BasicDuckDB.JDBC.Statement.foldQuery(sql, f, s))


    pub def forEachQuery(sql: String, f: Unit -> Unit \ ef): Unit \ {ef + Fail + DuckDBConnection} - RowReaderWithAlt - Statement - DuckDBResultSet  = 
        execStatement(_ -> BasicDuckDB.JDBC.Statement.forEachQuery(sql, f))

    

}

