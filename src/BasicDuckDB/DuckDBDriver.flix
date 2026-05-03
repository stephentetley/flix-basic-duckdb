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


pub mod BasicDuckDB.DuckDBDriver {
    use BasicDuckDB.DuckDBDriver.DuckDBDriver
    
    use EffectExtras.Fail.Fail
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBConnection.DuckDBConnectionHandle
    use IoError.ErrorKind
    use IoError.IoError
    
    import java.sql.{SQLException => JSQLException}
    import java.util.{Properties => JProperties}
    import org.duckdb.{DuckDBDriver => JDuckDBDriver}
    import org.duckdb.{DuckDBConnection => JDuckDBConnection}

    pub eff DuckDBDriver {
        def connect(url: String): DuckDBConnectionHandle
        def closeConnection(conn: DuckDBConnectionHandle): Unit
        def acceptsURL(url: String): Bool
        def jdbcCompliant(): Bool
        def getMajorVersion(): Int32
        def getMinorVersion(): Int32
    }

    pub def handle(f: a -> b \ ef): a -> b \ {IO + Fail + ef} - DuckDBDriver = x -> {
        let jdriver = new JDuckDBDriver();
        run {
            f(x)
        } with handler DuckDBDriver {
        
            def connect(url, k) = 
                try {
                    let props = new JProperties();
                    let ans = jdriver.connect(url, props);
                    let ans1 = unchecked_cast(ans as JDuckDBConnection);
                    let ans2 = DuckDBConnectionHandle.DuckDBConnectionHandle(ans1);
                    k(ans2)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def closeConnection(conn, k) = 
                try {
                    let DuckDBConnectionHandle.DuckDBConnectionHandle(jconn) = conn;
                    jconn.close();
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def acceptsURL(url, k) = 
                try {
                    let ans = jdriver.acceptsURL(url);
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def jdbcCompliant(k) = 
                try {
                    let ans = jdriver.jdbcCompliant();
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def getMajorVersion(k) = 
                try {
                    let ans = jdriver.getMajorVersion();
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def getMinorVersion(k) = 
                try {
                    let ans = jdriver.getMinorVersion();
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

        }
    }


    pub def runWithIO(f: Unit -> a \ ef): a \ {IO + Fail + ef} - DuckDBDriver =
        handle(f)()

    pub def runWithIOAndFail(f: Unit -> a \ ef): Result[IoError, a] \ {IO + ef} - DuckDBDriver - Fail =
        run {
             runWithIO(f)
        } with EffectExtras.Fail.runWithResultOfIoError

    pub def execDuckDBConnection(url: String, 
                                f: Unit -> a \ DuckDBConnection + ef): a \ {Fail + ef + DuckDBDriver} - DuckDBConnection = 
        let conn = DuckDBDriver.connect(url);
        let ans = run {
            f()
        } with BasicDuckDB.DuckDBConnection.runDuckDBConnection(conn);
        DuckDBDriver.closeConnection(conn);
        ans

        
    pub def execInMemoryDuckDBConnection(f: Unit -> a \ DuckDBConnection + ef): a \ {Fail + ef + DuckDBDriver} - DuckDBConnection = 
        execDuckDBConnection("jdbc:duckdb:", f)

    pub def execfileBackedDuckDBConnection(filePath: String, f: Unit -> a \ DuckDBConnection + ef): a \ {Fail + ef + DuckDBDriver} - DuckDBConnection = 
        execDuckDBConnection("jdbc:duckdb:${filePath}", f)

}
