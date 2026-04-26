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



pub mod BasicDuckDB.PreparedStatementSetter {
    
    use BasicDuckDB.Base.Fail.Fail
    use BasicDuckDB.DuckDBPreparedStatement.{DuckDBPreparedStatementHandle}


    import java.sql.{SQLException => JSQLException}


    // Note zero-indexed unlike JDBC which is one-indexed


    pub eff SetPreparedStatement {
        def setNull(paramIx: Int32, sqlType: Int32): Unit
        def setBool(paramIx: Int32, value: Bool): Unit
        def setInt8(paramIx: Int32, value: Int8): Unit
        def setInt16(paramIx: Int32, value: Int16): Unit
        def setInt32(paramIx: Int32, value: Int32): Unit
        def setInt64(paramIx: Int32, value: Int64): Unit
        def setFloat32(paramIx: Int32, value: Float32): Unit
        def setFloat64(paramIx: Int32, value: Float64): Unit
        def setBigDecimal(paramIx: Int32, value: BigDecimal): Unit
        def setString(paramIx: Int32, value: String): Unit
    }


    pub def handle(stmt: DuckDBPreparedStatementHandle, 
                    f: a -> b \ ef): a -> b \ Fail + ef - SetPreparedStatement =
        x -> {
            let DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle(jstmt) = stmt;
            run {
                f(x)
            } with handler SetPreparedStatement {
            

                def setNull(paramIx, sqlType, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setNull(paramIx + 1, sqlType) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
                def setBool(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setBoolean(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
                def setInt8(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setByte(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
                def setInt16(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setShort(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
                def setInt32(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setInt(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
                def setInt64(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setLong(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                
                def setFloat32(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setFloat(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
                            
                def setFloat64(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setDouble(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def setBigDecimal(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setBigDecimal(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def setString(paramIx, value, k) = try {
                    unsafe IO as {Fail + ef - SetPreparedStatement} { jstmt.setString(paramIx + 1, value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            }
       }

    pub def runSetPreparedStatement(stmt: DuckDBPreparedStatementHandle, 
                        f: Unit -> a \ ef): a \ Fail + ef - SetPreparedStatement  =
        handle(stmt, f)()

}
