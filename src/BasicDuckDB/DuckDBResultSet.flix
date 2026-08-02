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




pub mod BasicDuckDB.DuckDBResultSet {
    use BasicDuckDB.RowReader
    

    use EffectExtras.Fail.Fail
    use EffectExtras.Alt.Alt
    use BasicDuckDB.{ResultSet, ResultSetRow}
    use BasicDuckDB.JDBC.ResultSet.{ResultSetHandle}


    
    import java.sql.{Connection => JConnection}
    import java.sql.{Statement => JStatement}
    import java.sql.{SQLException => JSQLException}
    import org.duckdb.{DuckDBResultSet => JDuckDBResultSet}
    

    pub eff DuckDBResultSet {
        def next(): Bool
        def getResultSetRow(): ResultSetRow
        def wasNull(): Bool
        def findColumn(label: String): Int32
        def isBeforeFirst(): Bool
        def isAfterLast(): Bool
        def isFirst(): Bool
        def isLast(): Bool
        def first(): Bool
        def last(): Bool
        def getRow(): Int32
        def absolute(row: Int32): Bool
        def relative(rows: Int32): Bool
        def setFetchSize(rows: Int32): Unit
        def getFetchSize(): Int32
    }


        
    pub def handle(results: ResultSet, 
                    f: a -> b \ ef): a -> b \ ef + Fail - DuckDBResultSet = x -> {
        let jresults = ToJava.toJava(results);
        run {
            f(x)
        } with handler DuckDBResultSet {
        
            def next(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.next() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def getResultSetRow(k) = k(ToFlix.toFlix(jresults))

            def wasNull(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.wasNull() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def findColumn(label, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.findColumn(label) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isBeforeFirst(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.isBeforeFirst() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isAfterLast(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.isAfterLast() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isFirst(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.isFirst() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def isLast(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.isLast() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def first(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.first() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def last(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.last() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def getRow(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.getRow() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def absolute(row, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.absolute(row) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def relative(rows, k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.relative(rows) };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def setFetchSize(rows, k) = 
                try {
                    unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.setFetchSize(rows) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def getFetchSize(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.getFetchSize() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

        }
    }


    
    pub def runDuckDBResultSet(results: ResultSet, 
                                f: Unit -> a \ ef): a \ {ef + Fail} - DuckDBResultSet =
        handle(results, f)()


    pub def execReadRow(reader: Unit -> a \ ef): a \ ef + Fail + DuckDBResultSet - RowReader - Alt = 
        let row = DuckDBResultSet.getResultSetRow();
        run {
            reader()
        } with BasicDuckDB.RowReader.runRowReader(row)



    // Note - doesn't close resultset even though it will be exhausted
    // TODO - there is no failure detection so we can't short circuit...
    pub def forEachRow(f: ResultSetRow -> Unit \ ef, results: ResultSet): Unit \ ef + Fail - DuckDBResultSet =
        @Tailrec
        def loop() = {
            let more = DuckDBResultSet.next();
            if (more) {
                let row = DuckDBResultSet.getResultSetRow();
                f(row);
                loop()
            } else ()
        };
        runDuckDBResultSet(results, loop)

    // fold
    pub def fold(f: ResultSetRow -> s -> s \ ef, st: s, results: ResultSet): s \ ef + Fail - DuckDBResultSet =
        def loop(acc) = {
            let more = DuckDBResultSet.next();
            if (more) {
                let row = DuckDBResultSet.getResultSetRow();
                let acc1 = f(row, acc);
                loop(acc1)
            } else acc
        };
        runDuckDBResultSet(results, _ -> loop(st))

    pub def firstResult(f: ResultSetRow -> a \ ef, results: ResultSet): a \ ef + Fail - DuckDBResultSet = 
        runDuckDBResultSet(results, _ -> {
            let more = DuckDBResultSet.next();
            if (more) {
                let row = DuckDBResultSet.getResultSetRow();
                f(row)
            } else Fail.report("firstResult - empty resultset")
        })
}
