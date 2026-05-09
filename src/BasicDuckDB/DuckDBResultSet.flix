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

    use EffectExtras.Fail.Fail
    use BasicDuckDB.RowReader.RowReaderWithAlt
    use BasicDuckDB.JDBC.ResultSet.{ResultSetHandle}


    
    import java.sql.{Connection => JConnection}
    import java.sql.{Statement => JStatement}
    import java.sql.{SQLException => JSQLException}
    import org.duckdb.{DuckDBResultSet => JDuckDBResultSet}
    

    pub eff DuckDBResultSet {
        // `askDuckDBResultSetHandle` should not be used in user code
        // It is a hack until we can run local effects polymorphically
        def askDuckDBResultSetHandle(): DuckDBResultSetHandle
        def next(): Bool
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

    pub enum DuckDBResultSetHandle(JDuckDBResultSet)

    pub def castResultSetHandle(results: ResultSetHandle): DuckDBResultSetHandle = 
        let ResultSetHandle.ResultSetHandle(results1) = results;
        let results2 = unchecked_cast(results1 as JDuckDBResultSet);
        DuckDBResultSetHandle.DuckDBResultSetHandle(results2)

        
    pub def handle(results: DuckDBResultSetHandle, 
                    f: a -> b \ ef): a -> b \ ef + Fail - DuckDBResultSet = x -> {
        let DuckDBResultSetHandle.DuckDBResultSetHandle(jresults) = results;
        run {
            f(x)
        } with handler DuckDBResultSet {
        
            def askDuckDBResultSetHandle(k) = k(results)


            def next(k) = 
                try {
                    let ans = unsafe IO as {ef + Fail - DuckDBResultSet} { jresults.next() };
                    k(ans)
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
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


    
    pub def runDuckDBResultSet(results: DuckDBResultSetHandle, 
                                f: Unit -> a \ ef): a \ {ef + Fail} - DuckDBResultSet =
        handle(results, f)()


    pub def execReadRow(reader: Unit -> a \ ef): a \ {ef + Fail + DuckDBResultSet} - RowReaderWithAlt = 
        let row = DuckDBResultSet.askDuckDBResultSetHandle();
        run {
            reader()
        } with BasicDuckDB.RowReader.runRowReader(row)

    // Note - doesn't close resultset even though it will be exhausted
    pub def forEach(f: Unit -> Unit \ ef): Unit \ {ef + Fail + DuckDBResultSet} - RowReaderWithAlt =
        def loop(fk, sk) = {
            let more = DuckDBResultSet.next();
            if (more) {
                let rowAnswer = EffectExtras.Fail.runWithResult(_ -> execReadRow(f));
                match rowAnswer {
                    case Ok()     => loop(fk, sk)
                    case Err(err) => fk(err)
                }
            } else sk()
        };
        loop(e -> Fail.report(e), a -> a)

    // fold
    pub def fold(f: s -> s \ ef, st: s): s \ {ef + Fail + DuckDBResultSet} - RowReaderWithAlt =
        def loop(acc, fk, sk) = {
            let more = DuckDBResultSet.next();
            if (more) {
                let rowAnswer = EffectExtras.Fail.runWithResult(_ -> execReadRow(_ -> f(acc)));
                match rowAnswer {
                    case Ok(acc1) => loop(acc1, fk, sk)
                    case Err(err) => fk(err)
                }
            } else sk(acc)
        };
        loop(st, e -> Fail.report(e), a -> a)

}
