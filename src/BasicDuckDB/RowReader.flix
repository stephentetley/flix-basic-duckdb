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


pub mod BasicDuckDB.RowReader {
    import java.io.IOError

    use IoError.ErrorKind
    use IoError.IoError

    use BasicDuckDB.Base.Alt.Alt
    use BasicDuckDB.DuckDBResultSet.{DuckDBResultSetHandle}
    use BasicDuckDB.JDBC.Struct.{StructHandle}


    import java.sql.SQLException


    pub eff ReadRow {
        def getStringByIndex(ix: Int32): String
        def getStringByName(name: String): String
        def getBoolByIndex(ix: Int32): Bool
        def getBoolByName(name: String): Bool
        def getInt8ByIndex(ix: Int32): Int8
        def getInt8ByName(name: String): Int8
        def getInt16ByIndex(ix: Int32): Int16
        def getInt16ByName(name: String): Int16
        def getInt32ByIndex(ix: Int32): Int32
        def getInt32ByName(name: String): Int32
        def getInt64ByIndex(ix: Int32): Int64
        def getInt64ByName(name: String): Int64
        def getBigIntByIndex(ix: Int32): BigInt
        def getFloat32ByIndex(ix: Int32): Float32
        def getFloat32ByName(name: String): Float32
        def getFloat64ByIndex(ix: Int32): Float64
        def getFloat64ByName(name: String): Float64
        def getBigDecimalByIndex(ix: Int32): BigDecimal
        def getBigDecimalByName(name: String): BigDecimal
        def getStructByIndex(ix: Int32): StructHandle
    }

    pub type alias ReadRowWithAlt = ReadRow + Alt


    pub def handle(results: DuckDBResultSetHandle, 
                    f: a -> b \ ef): a -> Result[String, b] \ ((ef + IO)- ReadRowWithAlt) = x -> {
        let DuckDBResultSetHandle.DuckDBResultSetHandle(jresults) = results;
        run {
            Ok(f(x))
        } with handler ReadRow {
        
            def getStringByIndex(ix, k) = try {
                let ans = jresults.getString(ix + 1);
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getStringByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getString(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }
            
            def getBoolByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getBoolean(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }
            
            def getBoolByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getBoolean(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }


            def getInt8ByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getByte(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getInt8ByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getByte(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getInt16ByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getShort(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getInt16ByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getShort(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getInt32ByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getInt(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getInt32ByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getInt(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getInt64ByIndex(ix, k) = try {
                let ans = unsafe IO as {} {  jresults.getLong(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getInt64ByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getLong(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getBigIntByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getHugeint(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getFloat32ByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getFloat(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getFloat32ByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getFloat(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getFloat64ByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getDouble(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getFloat64ByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getDouble(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getBigDecimalByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getBigDecimal(ix + 1) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getBigDecimalByName(name, k) = try {
                let ans = unsafe IO as {} { jresults.getBigDecimal(name) };
                k(ans)
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }

            def getStructByIndex(ix, k) = try {
                let ans = unsafe IO as {} { jresults.getStruct(ix) };
                k(StructHandle.StructHandle(ans))
            } catch {
                case ex: SQLException => Alt.failure(ex.getMessage())
            }
        
        } with handler Alt {

            def alternative(k) =  match k(true) {
                case Ok(ans) => Ok(ans)
                case Err(_) => k(false)
            }

            def failure(e, _) = Err(e)
    
        }

    }

    pub def runWithIO(rset: DuckDBResultSetHandle, f: Unit -> a \ ef): Result[IoError, a] \ (ef + IO) - ReadRowWithAlt = 
        handle(rset, f)() |> Result.mapErr(s -> IoError(ErrorKind.Other, s))

}
