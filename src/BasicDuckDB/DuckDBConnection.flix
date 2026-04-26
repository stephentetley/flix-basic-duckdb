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
    

    use BasicDuckDB.DuckDBAppender.{DuckDBAppender}
    use BasicDuckDB.DuckDBAppender.{DuckDBAppenderHandle}
    use BasicDuckDB.DuckDBPreparedStatement.{DuckDBPreparedStatement}
    use BasicDuckDB.DuckDBPreparedStatement.{DuckDBPreparedStatementHandle}
    use BasicDuckDB.DuckDBResultSet.{DuckDBResultSet}
    use BasicDuckDB.JDBC.Statement.{Statement}
    use BasicDuckDB.JDBC.Statement.StatementHandle
    use BasicDuckDB.RowAppender.AppendRow
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.Base.Fail.Fail

    import java.sql.{Connection => JConnection}
    import java.sql.{Statement => JStatement}
    import java.sql.{SQLException => JSQLException}
    import org.duckdb.{DuckDBPreparedStatement => JDuckDBPreparedStatement}
    import org.duckdb.{DuckDBConnection => JDuckDBConnection}
    
    pub enum DuckDBConnectionHandle(JDuckDBConnection)


    pub eff DuckDBConnection {
        def createStatement(): StatementHandle
        def prepareStatement(sql: String): DuckDBPreparedStatementHandle
        def createAppender(schemaName: String, tableName: String): DuckDBAppenderHandle
        def nativeSQL(sql: String): String
        def setAutoCommit(autoCommit: Bool): Unit
        def getAutoCommit(): Bool
        def commit(): Unit
        def rollback(): Unit
        def close(): Unit
        def isClosed(): Bool
        def isValid(timeout: Int32): Bool
        def isReadOnly(): Bool
        def setReadOnly(readOnly: Bool): Unit
        def getCatalog(): String
        def setCatalog(catalog: String): Unit
        def getTransactionIsolation(): Int32
        def setTransactionIsolation(level: Int32): Unit
    }

    pub def handle(conn: DuckDBConnectionHandle, f: a -> b \ ef): a -> b \ Fail + ef - DuckDBConnection =
        x -> {
            let DuckDBConnectionHandle.DuckDBConnectionHandle(jconn) = conn;
            run {
                f(x)
            } with handler DuckDBConnection {
            
                def createStatement(k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.createStatement() };
                    k(StatementHandle.StatementHandle(ans))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def prepareStatement(sql, k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.prepareStatement(sql) };
                    let ans1 = unchecked_cast(ans as JDuckDBPreparedStatement);
                    k(DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(ans1))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def createAppender(schema, table, k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.createAppender(schema, table) };
                    k(DuckDBAppenderHandle.DuckDBAppenderHandle(ans))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def nativeSQL(sql, k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.nativeSQL(sql) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def setAutoCommit(ac, k) = try {
                    unsafe IO as {Fail + ef - DuckDBConnection} { jconn.setAutoCommit(ac) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def getAutoCommit(k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.getAutoCommit() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def commit(k) = try {
                    unsafe IO as {Fail + ef - DuckDBConnection} { jconn.commit() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def rollback(k) = try {
                    unsafe IO as {Fail + ef - DuckDBConnection} { jconn.rollback() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def close(k) = try {
                    unsafe IO as {Fail + ef - DuckDBConnection} { jconn.close() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def isClosed(k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.isClosed() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def isValid(timeout, k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.isValid(timeout) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def isReadOnly(k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.isReadOnly() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def setReadOnly(ro, k) = try {
                    unsafe IO as {Fail + ef - DuckDBConnection} { jconn.setReadOnly(ro) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def getCatalog(k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.getCatalog() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def setCatalog(c, k) = try {
                    unsafe IO as {Fail + ef - DuckDBConnection} { jconn.setCatalog(c) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def getTransactionIsolation(k) = try {
                    let ans = unsafe IO as {Fail + ef - DuckDBConnection} { jconn.getTransactionIsolation() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def setTransactionIsolation(l, k) = try {
                    unsafe IO as {Fail + ef - DuckDBConnection} { jconn.setTransactionIsolation(l) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            }

        }
    
    pub def runDuckDBConnection(conn: DuckDBConnectionHandle, 
                        f: Unit -> a \ ef): a \ Fail + ef - DuckDBConnection = 
        handle(conn, f)()

    
    pub def execStatement(f: Unit -> a \ ef): a \ {Fail + ef + DuckDBConnection} - Statement = 
        let stmt = DuckDBConnection.createStatement();
        run {
            let ans = f();
            Statement.close();
            ans
        } with BasicDuckDB.JDBC.Statement.runStatement(stmt)

    pub def execDuckDBPreparedStatement(sql: String, f: Unit -> a \ ef): a \ {Fail + ef + DuckDBConnection} - DuckDBPreparedStatement = 
        let stmt = DuckDBConnection.prepareStatement(sql);
        run {
            let ans = f();
            DuckDBPreparedStatement.close();
            ans
        } with BasicDuckDB.DuckDBPreparedStatement.runDuckDBPreparedStatement(stmt)

    // forEach has a strange effect on the effect signature
    pub def execRowAppender(schema: String, 
                            table: String, 
                            appendf: a -> Unit \ ef, t: t): Unit \ ({Fail + ef + DuckDBConnection} - AppendRow) + {DuckDBAppender + DuckDBAppender + DuckDBAppender + ForEach.Aef[t]} - {DuckDBAppender} with ForEach[t] where ForEach.Elm[t] ~ a = 
        let hndl = DuckDBConnection.createAppender(schema, table);
        run { 
            ForEach.forEach(a -> {
                    DuckDBAppender.beginRow();
                    BasicDuckDB.DuckDBAppender.execRowAppender(_ -> appendf(a));
                    DuckDBAppender.endRow()
                }, 
                t);
                DuckDBAppender.close()
        } with BasicDuckDB.DuckDBAppender.runDuckDBAppender(hndl)

    
    // cf. ```f: (<row>, a) -> a``` but <row> is implicit
    pub def queryFold(f: a -> a \ ReadRowWithAlt + ef, s: a, sql: String): a \ {Fail + ef + DuckDBConnection} - {Statement + DuckDBResultSet}  = 
        let stmt = DuckDBConnection.createStatement();
        run {
            let results = Statement.executeQuery(sql);
            let results1 = BasicDuckDB.DuckDBResultSet.castResultSetHandle(results);
            let ans = run {
                def loop(acc, sk) = {
                    let more = DuckDBResultSet.next();
                    if (more) {
                        let rowAnswer = BasicDuckDB.Base.Fail.handleAsResult(_ -> BasicDuckDB.DuckDBResultSet.execReadRow(_ -> f(acc)))();
                        match rowAnswer {
                            case Ok(acc1) => loop(acc1, sk)
                            case Err(err) => Fail.report(err)
                        }
                    } else sk(acc)
                };
                loop(s, a -> a)
            } with BasicDuckDB.DuckDBResultSet.runDuckDBResultSet(results1);
            Statement.close();
            ans
        } with BasicDuckDB.JDBC.Statement.runStatement(stmt)


    pub def queryForEach(reader: Unit -> Unit \ ReadRowWithAlt + ef, sql: String): Unit \ {Fail + ef + DuckDBConnection} - {Statement + DuckDBResultSet} = 
        let stmt = DuckDBConnection.createStatement();
        run {
            let results = Statement.executeQuery(sql);
            let results1 = BasicDuckDB.DuckDBResultSet.castResultSetHandle(results);
            let _ = run {
                def loop(fk, sk) = {
                    let more = DuckDBResultSet.next();
                    if (more) {
                        let rowAnswer = BasicDuckDB.Base.Fail.handleAsResult(_ -> BasicDuckDB.DuckDBResultSet.execReadRow(reader))();
                        match rowAnswer {
                            case Ok() => loop(fk, sk)
                            case Err(err) => fk(err)
                        }
                    } else sk()
                };
                loop(e -> Err(e), a -> Ok(a))
            } with BasicDuckDB.DuckDBResultSet.runDuckDBResultSet(results1);
            Statement.close();
            ()
        } with BasicDuckDB.JDBC.Statement.runStatement(stmt)

    

}

