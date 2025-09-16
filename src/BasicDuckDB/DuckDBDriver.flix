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

    use BasicDuckDB.DuckDBConnectionHandle

    pub eff DuckDBDriver {
        def connect(url: String): DuckDBConnectionHandle
        def acceptsURL(url: String): Bool
        def jdbcCompliant(): Bool
        def getMajorVersion(): Int32
        def getMinorVersion(): Int32
    }

}

mod BasicDuckDB.DuckDBDriver {
    

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBConnectionHandle.DuckDBConnectionHandle
    use IoError.ErrorKind
    use IoError.IoError

    import java.sql.SQLException
    import java.util.{Properties => JProperties}
    import org.duckdb.{DuckDBDriver => JDuckDBDriver}
    import org.duckdb.{DuckDBConnection => JDuckDBConnection}

    pub def handle(f: a -> b \ ef): a -> Result[IoError, b] \ (ef - DuckDBDriver + IO) =
        x -> {
            let jdriver = new JDuckDBDriver();
            run {
                Ok(f(x))
            } with handler DuckDBDriver {
            
                def connect(url, k) = try {
                    let props = new JProperties();
                    let ans = jdriver.connect(url, props);
                    let ans1 = unchecked_cast(ans as JDuckDBConnection);
                    let ans2 = DuckDBConnectionHandle(ans1);
                    k(ans2)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def acceptsURL(url, k) = try {
                    let ans = jdriver.acceptsURL(url);
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def jdbcCompliant(k) = try {
                    let ans = jdriver.jdbcCompliant();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def getMajorVersion(k) = try {
                    let ans = jdriver.getMajorVersion();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def getMinorVersion(k) = try {
                    let ans = jdriver.getMinorVersion();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

            }
        }

    pub def runWithIO(f: Unit -> a \ ef): Result[IoError, a] \ (ef - DuckDBDriver) + {IO} =
        handle(f)()

    pub def execDuckDBConnection(url: String, f: Unit -> a \ ef): Result[IoError, a] \ (ef + DuckDBDriver - DuckDBConnection) + {IO} = 
        let conn = DuckDBDriver.connect(url);
        let ans = run {
            let ans1 = f();
            DuckDBConnection.close();
            ans1
        } with DuckDBConnection.runWithIO(conn);
        ans

}
