/*
 * Copyright 2026 Stephen Tetley
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


pub mod BasicDuckDB.DuckDBScalarFunctionBuilder {
    
    use BasicDuckDB.DuckDBFunctions.RegisteredFunction 
    use BasicDuckDB.DuckDBConnection.DuckDBConnectionHandle
    use BasicDuckDB.DuckDBColumnType.ColumnType
    use BasicDuckDB.DuckDBLogicalType.LogicalType

    import org.duckdb.{DuckDBScalarFunctionBuilder => JDuckDBScalarFunctionBuilder}
    import org.duckdb.{DuckDBFunctions => JDuckDBFunctions}
    import org.duckdb.{DuckDBFunctions$RegisteredFunction => JRegisteredFunction}
    import java.sql.{SQLException => JSQLException}
    import java.util.function.{IntUnaryOperator => JIntUnaryOperator}

    pub eff DuckDBScalarFunctionBuilder {
        def withName(s: String): Unit
        def withNullInNullOut(): Unit
        def withParameter(ctype: ColumnType): Unit
        // def withParameterLogicalType(ltype: LogicalType): Unit
        def withReturnType(ctype: ColumnType): Unit
        def withUnaryInt32Function(f: Int32 -> Int32): Unit
    }


    // Produce a DuckDBFunctions$RegisteredFunction ?

    pub def handle(conn: DuckDBConnectionHandle, f: a -> b \ ef): a -> Result[String, (RegisteredFunction, b)] \ (ef - DuckDBScalarFunctionBuilder) = x ->
        region rc {
            handleHelper(rc, conn, f, x)
        }

    pub def handleHelper(_: Region[r], conn: DuckDBConnectionHandle, f: a -> b \ ef): a -> Result[String, (RegisteredFunction, b)] \ {ef - DuckDBScalarFunctionBuilder} + r =
        x -> {
            let builder = unsafe IO as r { JDuckDBFunctions.scalarFunction() };
            let ans = run {
                Ok(f(x))
            } with handler DuckDBScalarFunctionBuilder {
                        
                def withName(s, k) = try {
                    unsafe IO as r { discard builder.withName(s) };
                    k()
                } catch {
                    case ex: JSQLException => Err(ex.getMessage())
                }

                def withNullInNullOut(k) = try {
                    unsafe IO as r { discard builder.withNullInNullOut() };
                    k()
                } catch {
                    case ex: JSQLException => Err(ex.getMessage())
                }
                
                def withParameter(p, k) = try {
                    let jparam = BasicDuckDB.DuckDBColumnType.marshalColumnType(p) ;
                    unsafe IO as r { discard builder.withParameter(jparam) };
                    k()
                } catch {
                    case ex: JSQLException => Err(ex.getMessage())
                }
                
                def withReturnType(p, k) = try {
                    let jparam = BasicDuckDB.DuckDBColumnType.marshalColumnType(p) ;
                    unsafe IO as r { discard builder.withReturnType(jparam) };
                    k()
                } catch {
                    case ex: JSQLException => Err(ex.getMessage())
                }

            def withUnaryInt32Function(fn, k) = try {
                    let jf1: JIntUnaryOperator = makeIntUnaryOperator(fn);
                    unsafe IO as r { discard builder.withIntFunction(jf1) };
                    k()
                } catch {
                    case ex: JSQLException => Err(ex.getMessage())
                }

            };
            match ans {
                case Ok(ans1)    => { 
                    let DuckDBConnectionHandle.DuckDBConnectionHandle(jconn) = conn;
                    let jfun: JRegisteredFunction = unsafe IO { builder.register(jconn) };
                    Ok((RegisteredFunction.RegisteredFunction(jfun), ans1))
                }
                case Err(msg) => Err(msg)
            }
        }

    def makeIntUnaryOperator(f: Int32 -> Int32 \ ef): JIntUnaryOperator =
        i -> unchecked_cast(f(i) as _ \ IO)


}
