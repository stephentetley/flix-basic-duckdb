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


mod BasicDuckDB {

    
    use BasicDuckDB.DuckDBPreparedStatementHandle
    use BasicDuckDB.JDBC.StatementHandle

    pub eff DuckDBConnection {
        def createStatement(): StatementHandle
        def prepareStatement(sql: String): DuckDBPreparedStatementHandle
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


}

mod BasicDuckDB.DuckDBConnection {

    use BasicDuckDB.DuckDBConnectionHandle
    use BasicDuckDB.DuckDBConnectionHandle.DuckDBConnectionHandle
    use BasicDuckDB.DuckDBPreparedStatementHandle
    use BasicDuckDB.DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle
    use BasicDuckDB.JDBC.StatementHandle
    use BasicDuckDB.JDBC.StatementHandle.StatementHandle
    use BasicDuckDB.DuckDBConnection
    use IoError.ErrorKind
    use IoError.IoError
    
    import java.sql.{Connection => JConnection}
    import java.sql.{Statement => JStatement}
    import java.sql.SQLException
    import org.duckdb.{DuckDBPreparedStatement => JDuckDBPreparedStatement}

    pub def handle(conn: DuckDBConnectionHandle, f: a -> b \ ef): a -> Result[IoError, b] \ (ef - DuckDBConnection + IO) =
        x -> {
            let DuckDBConnectionHandle(jconn) = conn;
            run {
                Ok(f(x))
            } with handler DuckDBConnection {
            
                def createStatement(k) = try {
                    let ans = StatementHandle(jconn.createStatement());
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def prepareStatement(sql, k) = try {
                    let ans = jconn.prepareStatement(sql);
                    let ans1 = unchecked_cast(ans as JDuckDBPreparedStatement);
                    let ans2 = DuckDBPreparedStatementHandle(ans1);
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


    
    pub def runWithIO(conn: DuckDBConnectionHandle, f: Unit -> a \ ef): Result[IoError, a] \ (ef - DuckDBConnection) + {IO} = 
        handle(conn, f)()


}
