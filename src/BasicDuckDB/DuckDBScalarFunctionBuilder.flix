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


pub mod BasicDuckDB.DuckDBScalarFunctionBuilder {
    
    use BasicDuckDB.DuckDBFunctions.RegisteredFunction 
    use BasicDuckDB.DuckDBConnection.DuckDBConnectionHandle

    import org.duckdb.{DuckDBScalarFunctionBuilder => JDuckDBScalarFunctionBuilder}
    import org.duckdb.{DuckDBFunctions => JDuckDBFunctions}
    import org.duckdb.{DuckDBFunctions$RegisteredFunction => JRegisteredFunction}
    import java.sql.{SQLException => JSQLException}

    pub eff DuckDBScalarFunctionBuilder {
        def withName(s: String): Unit
        def withNullInNullOut(): Unit
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
}
