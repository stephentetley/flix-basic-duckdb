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



pub mod BasicDuckDB.DuckDBPreparedStatement {
    
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSetHandle
    use BasicDuckDB.PreparedStatementSetter
    use BasicDuckDB.PreparedStatementSetter.PreparedStatementSetter
    use BasicDuckDB.PreparedStatementSetter.SetPreparedStatement

    import java.sql.{SQLException, SQLTimeoutException, SQLFeatureNotSupportedException}
    import org.duckdb.{DuckDBResultSet => JDuckDBResultSet}
    import org.duckdb.{DuckDBPreparedStatement => JDuckDBPreparedStatement}
    
    pub enum DuckDBPreparedStatementHandle (JDuckDBPreparedStatement)

    pub eff DuckDBPreparedStatement {
        // `askDuckDBPreparedStatementHandle` should not be used in user code
        // It is a hack until we can run local effects polymorphically
        def askDuckDBPreparedStatementHandle(): DuckDBPreparedStatementHandle
        def close(): Unit
        def execute(): Bool
        def addBatch(): Unit
        def executeBatch(): Unit
        def executeQuery(): DuckDBResultSetHandle
        def executeUpdate(): Int32
        def clearParameters(): Unit
    }

    pub def handle(stmt: DuckDBPreparedStatementHandle, 
                    f: a -> b \ ef): a -> Result[String, b] \ {IO + ef} - DuckDBPreparedStatement =
        x -> {
            let DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(jstmt) = stmt;
            run {
                Ok(f(x))
            } with handler DuckDBPreparedStatement {
                        
                def askDuckDBPreparedStatementHandle(k) = k(stmt)

                def close(k) = try {                    
                    jstmt.close();
                    k()
                } catch {
                    case ex: SQLException => Err(ex.getMessage())
                }

                def execute(k) = try {
                    let ans = jstmt.execute();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(ex.getMessage())
                }

                def addBatch(k) = try {
                    jstmt.addBatch();
                    k()
                } catch {
                    case ex: SQLException => Err(ex.getMessage())
                }

                def executeBatch(k) = try {
                    let _ = jstmt.executeBatch();
                    k()
                } catch {
                    case ex: SQLException => Err(ex.getMessage())
                }

                def executeQuery(k) = try {
                    let ans = jstmt.executeQuery();
                    let ans1 = unchecked_cast(ans as JDuckDBResultSet);
                    let ans2 = DuckDBResultSetHandle.DuckDBResultSetHandle(ans1);
                    k(ans2)
                } catch {
                    case ex: SQLException => Err(ex.getMessage())
                }

                def executeUpdate(k) = try {
                    let ans = jstmt.executeUpdate();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(ex.getMessage())
                }

                def clearParameters(k) = try {
                    jstmt.clearParameters();
                    k()
                } catch {
                    case ex: SQLException => Err(ex.getMessage())
                }
            }
       }

    pub def runWithIO(stmt: DuckDBPreparedStatementHandle, 
                        f: Unit -> a \ ef): Result[String, a] \ {IO + ef} - DuckDBPreparedStatement =
        handle(stmt, f)() 

    pub def execPreparedStatementSetter(setter: PreparedStatementSetter[a, ef]): Result[String, a] \ {IO + ef + DuckDBPreparedStatement} - SetPreparedStatement = 
        let stmt = DuckDBPreparedStatement.askDuckDBPreparedStatementHandle();
        let PreparedStatementSetter.PreparedStatementSetter(f) = setter;
        run {
            f()
        } with BasicDuckDB.PreparedStatementSetter.runWithIO(stmt)

}
