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
    

    import java.sql.{SQLException => JSQLException}
    import org.duckdb.{DuckDBResultSet => JDuckDBResultSet}
    import org.duckdb.{DuckDBPreparedStatement => JDuckDBPreparedStatement}
    
    pub enum DuckDBPreparedStatementHandle (JDuckDBPreparedStatement)

    pub eff DuckDBPreparedStatement {
        // `askDuckDBPreparedStatementHandle` should not be used in user code
        // It is a hack until we can run local effects polymorphically
        def askDuckDBPreparedStatementHandle(): DuckDBPreparedStatementHandle
        def execute(): Bool
        def addBatch(): Unit
        def executeBatch(): Unit
        def executeQuery(): DuckDBResultSetHandle
        def executeUpdate(): Int32
        def clearParameters(): Unit
        def setNull(index: {index = Int32}, sqlType: Int32): Unit
        def setBool(index: {index = Int32}, b: Bool): Unit
        def setInt8(index: {index = Int32}, i: Int8): Unit
        def setInt16(index: {index = Int32}, i: Int16): Unit
        def setInt32(index: {index = Int32}, i: Int32): Unit
        def setInt64(index: {index = Int32}, i: Int64): Unit
        def setFloat32(index: {index = Int32}, d: Float32): Unit
        def setFloat64(index: {index = Int32}, d: Float64): Unit
        def setBigDecimal(index: {index = Int32}, d: BigDecimal): Unit
        def setString(index: {index = Int32}, s: String): Unit        
    }

    pub def handle(stmt: DuckDBPreparedStatementHandle, 
                    f: a -> b \ ef): a -> b \ Fail + ef - DuckDBPreparedStatement = x -> {
        let DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(jstmt) = stmt;
        run {
            f(x)
        } with handler DuckDBPreparedStatement {
                    
            def askDuckDBPreparedStatementHandle(k) = k(stmt)


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

            def setNull(ix, sqlType, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setNull(ix#index, sqlType) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def setBool(ix, b, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setBoolean(ix#index, b) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def setInt8(ix, i, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setByte(ix#index, i) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def setInt16(ix, i, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setShort(ix#index, i) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def setInt32(ix, i, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setInt(ix#index, i) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def setInt64(ix, i, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setLong(ix#index, i) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
            def setFloat32(ix, d, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setFloat(ix#index, d) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                        
            def setFloat64(ix, d, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setDouble(ix#index, d) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setBigDecimal(ix, d, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setBigDecimal(ix#index, d) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setString(ix, s, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBPreparedStatement} { jstmt.setString(ix#index, s) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }


        }
    }

    pub def runDuckDBPreparedStatement(stmt: DuckDBPreparedStatementHandle, 
                                        f: Unit -> a \ ef): a \ Fail + ef - DuckDBPreparedStatement =
        handle(stmt, f)() 

    // pub def execPreparedStatementSetter(setter: PreparedStatementSetter[a, ef]): Result[String, a] \ {IO + ef + DuckDBPreparedStatement} - DuckDBPreparedStatement = 
    //     let stmt = DuckDBPreparedStatement.askDuckDBPreparedStatementHandle();
    //     let PreparedStatementSetter.PreparedStatementSetter(f) = setter;
    //     run {
    //         f()
    //     } with BasicDuckDB.PreparedStatementSetter.runWithIO(stmt)

}
