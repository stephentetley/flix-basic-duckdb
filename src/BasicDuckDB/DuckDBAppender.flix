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



pub mod BasicDuckDB.DuckDBAppender {

    use BasicDuckDB.RowAppender.AppendRow
    use BasicDuckDB.Base.Fail.Fail

    import java.sql.SQLException
    import java.lang.Throwable
    import org.duckdb.{DuckDBAppender => JDuckDBAppender}

    pub enum DuckDBAppenderHandle (JDuckDBAppender)

    pub eff DuckDBAppender {
        // `askDuckDBAppenderHandle` should not be used in user code
        // It is a hack until we can run local effects polymorphically
        def askDuckDBAppenderHandle(): DuckDBAppenderHandle        
        def beginRow(): Unit
        def endRow(): Unit
        def flush(): Unit
        // def finalize(): Unit
        def close(): Unit
    }

    pub def handle(appender: DuckDBAppenderHandle, 
                    f: a -> b \ ef): a -> b \ Fail + ef - DuckDBAppender =
        x -> {
            let DuckDBAppenderHandle.DuckDBAppenderHandle(jappender) = appender;
            run {
                f(x)
            } with handler DuckDBAppender {

                def askDuckDBAppenderHandle(k) = k(appender)

                def beginRow(k) = try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.beginRow() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }
                
                def endRow(k) = try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.endRow() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }
                
                def flush(k) = try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.flush() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }
                
                // def finalize(k) = try {
                //     let _ = jappender.finalize();
                //     k()
                // } catch {
                //     case ex: Throwable => Fail.report(ex.getMessage())
                // }

                def close(k) = try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { jappender.close() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            }
        }

    pub def runDuckDBAppender(appender: DuckDBAppenderHandle, 
                        f: Unit -> a \ ef):  a \ Fail + ef - DuckDBAppender = 
        handle(appender, f)()

    pub def execRowAppender(appender: Unit -> a \ ef): a \ {Fail + ef + DuckDBAppender} - {AppendRow} = 
        let hndl = DuckDBAppender.askDuckDBAppenderHandle();
        run {
            appender()
        } with BasicDuckDB.RowAppender.runAppendRow(hndl)


}
