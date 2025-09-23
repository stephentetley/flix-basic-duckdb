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
}

mod BasicDuckDB.DuckDBAppender {

    use BasicDuckDB.DuckDBAppenderHandle
    use BasicDuckDB.DuckDBAppenderHandle.DuckDBAppenderHandle
    use BasicDuckDB.DuckDBAppender
    use BasicDuckDB.RowAppender
    use BasicDuckDB.RowAppender.RowAppender
    use BasicDuckDB.AppendRow
    use IoError.ErrorKind
    use IoError.IoError

    import java.sql.SQLException
    import java.lang.Throwable

    pub def handle(appender: DuckDBAppenderHandle, f: a -> b \ ef): a -> Result[IoError, b] \ (ef - DuckDBAppender + IO) =
        x -> {
            let DuckDBAppenderHandle(jappender) = appender;
            run {
                Ok(f(x))
            } with handler DuckDBAppender {

                def askDuckDBAppenderHandle(k) = k(appender)

                def beginRow(k) = try {
                    let _ = jappender.beginRow();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def endRow(k) = try {
                    let _ = jappender.endRow();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def flush(k) = try {
                    let _ = jappender.flush();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                


                // def finalize(k) = try {
                //     let _ = jappender.finalize();
                //     k()
                // } catch {
                //     case ex: Throwable => Err(IoError(ErrorKind.Other, ex.getMessage()))
                // }

                def close(k) = try {
                    let _ = jappender.close();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

            }
        }

    pub def runWithIO(appender: DuckDBAppenderHandle, f: Unit -> a \ ef): Result[IoError, a] \ (ef - DuckDBAppender) + {IO} = 
        handle(appender, f)()

    pub def execRowAppender(appender: RowAppender[a, ef]): Result[IoError, a] \ (ef - AppendRow + DuckDBAppender) + {IO} = 
        let hndl = DuckDBAppender.askDuckDBAppenderHandle();
        let RowAppender(f) = appender;
        run {
            f()
        } with RowAppender.runWithIO(hndl)


}
