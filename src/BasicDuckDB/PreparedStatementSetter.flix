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



    // Note zero-indexed unlike JDBC which is one-indexed

    pub enum PreparedStatementSetter[a:Type, ef: Eff](Unit -> a \ {SetPreparedStatement + ef})
    
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

}

mod BasicDuckDB.PreparedStatementSetter {
    
    use BasicDuckDB.DuckDBPreparedStatementHandle
    use BasicDuckDB.DuckDBPreparedStatementHandle.DuckDBPreparedStatementHandle
    use BasicDuckDB.SetPreparedStatement
    use IoError.ErrorKind
    use IoError.IoError

    import java.sql.{SQLException, SQLTimeoutException, SQLFeatureNotSupportedException}

    pub def handle(stmt: DuckDBPreparedStatementHandle, f: a -> b \ ef): a -> Result[IoError, b] \ {IO + ef} - SetPreparedStatement =
        x -> {
            let DuckDBPreparedStatementHandle(jstmt) = stmt;
            run {
                Ok(f(x))
            } with handler SetPreparedStatement {
            

                def setNull(paramIx, sqlType, k) = try {
                    jstmt.setNull(paramIx + 1, sqlType);
                    k()
                } catch {
                    case ex: SQLFeatureNotSupportedException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def setBool(paramIx, value, k) = try {
                    jstmt.setBoolean(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def setInt8(paramIx, value, k) = try {
                    jstmt.setByte(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def setInt16(paramIx, value, k) = try {
                    jstmt.setShort(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def setInt32(paramIx, value, k) = try {
                    jstmt.setInt(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def setInt64(paramIx, value, k) = try {
                    jstmt.setLong(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def setFloat32(paramIx, value, k) = try {
                    jstmt.setFloat(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                            
                def setFloat64(paramIx, value, k) = try {
                    jstmt.setDouble(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def setBigDecimal(paramIx, value, k) = try {
                    jstmt.setBigDecimal(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def setString(paramIx, value, k) = try {
                    jstmt.setString(paramIx + 1, value);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

            }
       }

    pub def runWithIO(stmt: DuckDBPreparedStatementHandle, f: Unit -> a \ ef): Result[IoError, a] \ {IO + ef} - SetPreparedStatement  =
        handle(stmt, f)()

}
