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
    
    use EffectExtras.Fail.Fail
    use BasicDuckDB.DuckDBResultSet.DuckDBResultSetHandle
    use BasicDuckDB.PreparedStatementSetter
    use BasicDuckDB.PreparedStatementSetter.SetPreparedStatement

    import java.sql.{SQLException => JSQLException}
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
                    f: a -> b \ ef): a -> b \ Fail + ef - DuckDBPreparedStatement = x -> {
        let DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(jstmt) = stmt;
        run {
            f(x)
        } with handler DuckDBPreparedStatement {
                    
            def askDuckDBPreparedStatementHandle(k) = k(stmt)

            def close(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBPreparedStatement } { jstmt.close() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def execute(k) = 
                try {
                    let ans = unsafe IO as { Fail + ef - DuckDBPreparedStatement } { jstmt.execute() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def addBatch(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBPreparedStatement } { jstmt.addBatch() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def executeBatch(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBPreparedStatement } { discard jstmt.executeBatch() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def executeQuery(k) = 
                try {
                    let ans = unsafe IO as { Fail + ef - DuckDBPreparedStatement } { jstmt.executeQuery() };
                    let ans1 = unchecked_cast(ans as JDuckDBResultSet);
                    k(DuckDBResultSetHandle.DuckDBResultSetHandle(ans1))
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def executeUpdate(k) = 
                try {
                    let ans = unsafe IO as { Fail + ef - DuckDBPreparedStatement } { jstmt.executeUpdate() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def clearParameters(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBPreparedStatement } { jstmt.clearParameters() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
        }
    }

    pub def runDuckDBPreparedStatement(stmt: DuckDBPreparedStatementHandle, 
                                        f: Unit -> a \ ef): a \ Fail + ef - DuckDBPreparedStatement =
        handle(stmt, f)() 

    // pub def execPreparedStatementSetter(setter: PreparedStatementSetter[a, ef]): Result[String, a] \ {IO + ef + DuckDBPreparedStatement} - SetPreparedStatement = 
    //     let stmt = DuckDBPreparedStatement.askDuckDBPreparedStatementHandle();
    //     let PreparedStatementSetter.PreparedStatementSetter(f) = setter;
    //     run {
    //         f()
    //     } with BasicDuckDB.PreparedStatementSetter.runWithIO(stmt)

}
