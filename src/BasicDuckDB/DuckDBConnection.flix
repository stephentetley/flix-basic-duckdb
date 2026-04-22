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
    use BasicDuckDB.RowAppender.{RowAppender}
    // use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.RowReader.ReadRow
    use IoError.ErrorKind
    use IoError.IoError
    
    import java.sql.{Connection => JConnection}
    import java.sql.{Statement => JStatement}
    import java.sql.SQLException
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

    pub def handle(conn: DuckDBConnectionHandle, f: a -> b \ ef): a -> Result[IoError, b] \ {IO + ef} - DuckDBConnection =
        x -> {
            let DuckDBConnectionHandle.DuckDBConnectionHandle(jconn) = conn;
            run {
                Ok(f(x))
            } with handler DuckDBConnection {
            
                def createStatement(k) = try {
                    let ans = StatementHandle.StatementHandle(jconn.createStatement());
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def prepareStatement(sql, k) = try {
                    let ans = jconn.prepareStatement(sql);
                    let ans1 = unchecked_cast(ans as JDuckDBPreparedStatement);
                    let ans2 = DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(ans1);
                    k(ans2)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def createAppender(schema, table, k) = try {
                    let ans2 = DuckDBAppenderHandle.DuckDBAppenderHandle(jconn.createAppender(schema, table));
                    k(ans2)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def nativeSQL(sql, k) = try {
                    let ans = jconn.nativeSQL(sql);
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def setAutoCommit(ac, k) = try {
                    jconn.setAutoCommit(ac);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def getAutoCommit(k) = try {
                    let ans = jconn.getAutoCommit();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def commit(k) = try {
                    jconn.commit();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def rollback(k) = try {
                    jconn.rollback();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def close(k) = try {
                    jconn.close();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def isClosed(k) = try {
                    let ans = jconn.isClosed();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def isValid(timeout, k) = try {
                    let ans = jconn.isValid(timeout);
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def isReadOnly(k) = try {
                    let ans = jconn.isReadOnly();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def setReadOnly(ro, k) = try {
                    jconn.setReadOnly(ro);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def getCatalog(k) = try {
                    let ans = jconn.getCatalog();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def setCatalog(c, k) = try {
                    jconn.setCatalog(c);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def getTransactionIsolation(k) = try {
                    let ans = jconn.getTransactionIsolation();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def setTransactionIsolation(l, k) = try {
                    jconn.setTransactionIsolation(l);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
            }
        }


    
    pub def runWithIO(conn: DuckDBConnectionHandle, f: Unit -> a \ ef): Result[IoError, a] \ {IO + ef} - DuckDBConnection = 
        handle(conn, f)()

    
    pub def execStatement(f: Unit -> a \ ef): Result[IoError, a] \ {IO + ef + DuckDBConnection} - Statement = 
        let stmt = DuckDBConnection.createStatement();
        run {
            let ans = f();
            Statement.close();
            ans
        } with BasicDuckDB.JDBC.Statement.runWithIO(stmt)

    pub def execDuckDBPreparedStatement(sql: String, f: Unit -> a \ ef): Result[IoError, a] \ {IO + ef + DuckDBConnection} - DuckDBPreparedStatement = 
        let stmt = DuckDBConnection.prepareStatement(sql);
        run {
            let ans = f();
            DuckDBPreparedStatement.close();
            ans
        } with BasicDuckDB.DuckDBPreparedStatement.runWithIO(stmt)
        

    pub def queryFold(f: a -> a \ ReadRow + ef, s: a, sql: String): Result[IoError, a] \ {IO + ef + DuckDBConnection} - {Statement + DuckDBResultSet}  = 
        let stmt = DuckDBConnection.createStatement();
        Result.flatten(run {
            let results = Statement.executeQuery(sql);
            let results1 = BasicDuckDB.DuckDBResultSet.castResultSetHandle(results);
            let ans = Result.flatten(run {
                def loop(acc, fk, sk) = {
                    let more = DuckDBResultSet.next();
                    if (more) {
                        match BasicDuckDB.DuckDBResultSet.execReadRow(_ -> f(acc)) {
                            case Ok(acc1) => loop(acc1, fk, sk)
                            case Err(err) => fk(err)
                        }
                    } else sk(acc)
                };
                loop(s, e -> Err(e), a -> Ok(a))
            } with BasicDuckDB.DuckDBResultSet.runWithIO(results1));
            Statement.close();
            ans
        } with BasicDuckDB.JDBC.Statement.runWithIO(stmt))


    pub def queryForEach(reader: Unit -> a \ ReadRow + ef, sql: String): Result[IoError, Unit] \ {IO + ef + DuckDBConnection} - {Statement + DuckDBResultSet} = 
        let stmt = DuckDBConnection.createStatement();
        run {
            let results = Statement.executeQuery(sql);
            let results1 = BasicDuckDB.DuckDBResultSet.castResultSetHandle(results);
            let _ = run {
                def loop(fk, sk) = {
                    let more = DuckDBResultSet.next();
                    if (more) {
                        match BasicDuckDB.DuckDBResultSet.execReadRow(reader) {
                            case Ok(_) => loop(fk, sk)
                            case Err(err) => fk(err)
                        }
                    } else sk()
                };
                loop(e -> Err(e), a -> Ok(a))
            } with BasicDuckDB.DuckDBResultSet.runWithIO(results1);
            Statement.close();
            ()
        } with BasicDuckDB.JDBC.Statement.runWithIO(stmt)

    // forEach has a strange effect on the effect signature
    pub def execRowAppender(schema: String, table: String, appendf:  a -> RowAppender[b, ef] \ ef1, t: t): Result[IoError, Unit] \ ({IO + ef + DuckDBConnection} - AppendRow) + {IO + ef1 + DuckDBAppender + DuckDBAppender + DuckDBAppender + ForEach.Aef[t]} - {DuckDBAppender} with ForEach[t] where ForEach.Elm[t] ~ a = 
        let hndl = DuckDBConnection.createAppender(schema, table);
        run { 
            ForEach.forEach(a -> {
                DuckDBAppender.beginRow();
                let _ = BasicDuckDB.DuckDBAppender.execRowAppender(appendf(a));
                DuckDBAppender.endRow()
                }, t);
                DuckDBAppender.close()
        } with BasicDuckDB.DuckDBAppender.runWithIO(hndl)


}
