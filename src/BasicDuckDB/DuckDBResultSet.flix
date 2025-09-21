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

    use BasicDuckDB.DuckDBResultSetHandle

    pub eff DuckDBResultSet {
        // `askDuckDBResultSetHandle` should not be used in user code
        // It is a hack until we can run local effects polymorphically
        def askDuckDBResultSetHandle(): DuckDBResultSetHandle
        def close(): Unit
        def next(): Bool
        def wasNull(): Bool
        def findColumn(label: String): Int32
        def isBeforeFirst(): Bool
        def isAfterLast(): Bool
        def isFirst(): Bool
        def isLast(): Bool
        def first(): Unit
        def last(): Unit
        def getRow(): Int32
        def absolute(row: Int32): Bool
        def relative(rows: Int32): Bool
        def setFetchSize(rows: Int32): Unit
        def getFetchSize(): Int32
    }


}

mod BasicDuckDB.DuckDBResultSet {


    use BasicDuckDB.DuckDBResultSetHandle
    use BasicDuckDB.DuckDBResultSetHandle.DuckDBResultSetHandle
    use BasicDuckDB.DuckDBResultSet
    use BasicDuckDB.RowReader
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.ReadRow
    use IoError.ErrorKind
    use IoError.IoError
    
    import java.sql.{Connection => JConnection}
    import java.sql.{Statement => JStatement}
    import java.sql.SQLException


    pub def handle(results: DuckDBResultSetHandle, f: a -> b \ ef): a -> Result[IoError, b] \ (ef - DuckDBResultSet + IO) =
        x -> {
            let DuckDBResultSetHandle(jresults) = results;
            run {
                Ok(f(x))
            } with handler DuckDBResultSet {
            
                def askDuckDBResultSetHandle(k) = k(results)

                def close(k) = try {
                    jresults.close();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def next(k) = try {
                    let ans = jresults.next();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def wasNull(k) = try {
                    let ans = jresults.wasNull();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def findColumn(label, k) = try {
                    let ans = jresults.findColumn(label);
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def isBeforeFirst(k) = try {
                    let ans = jresults.isBeforeFirst();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def isAfterLast(k) = try {
                    let ans = jresults.isAfterLast();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def isFirst(k) = try {
                    let ans = jresults.isFirst();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def isLast(k) = try {
                    let ans = jresults.isLast();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def first(k) = try {
                    jresults.first();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def last(k) = try {
                    jresults.last();
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def getRow(k) = try {
                    let ans = jresults.getRow();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def absolute(row, k) = try {
                    let ans = jresults.absolute(row);
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def relative(rows, k) = try {
                    let ans = jresults.relative(rows);
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

                def setFetchSize(rows, k) = try {
                    jresults.setFetchSize(rows);
                    k()
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }
                
                def getFetchSize(k) = try {
                    let ans = jresults.getFetchSize();
                    k(ans)
                } catch {
                    case ex: SQLException => Err(IoError(ErrorKind.Other, ex.getMessage()))
                }

            }
        }


    
    pub def runWithIO(results: DuckDBResultSetHandle, f: Unit -> a \ ef): Result[IoError, a] \ (ef - DuckDBResultSet) + {IO} =
        handle(results, f)()


    pub def execRowReader(reader: RowReader[a, ef]): Result[IoError, a] \ (ef - ReadRow + DuckDBResultSet) + {IO} = 
        let results = DuckDBResultSet.askDuckDBResultSetHandle();
        let RowReader(f) = reader;
        run {
            f()
        } with RowReader.runWithIO(results)


}
