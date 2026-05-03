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

    use EffectExtras.Fail.Fail
    

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
        def beginStruct(): Unit
        def endStruct(): Unit
        def beginUnion(tag: String): Unit
        def endUnion(): Unit
        def appendNull(): Unit
        def appendBool(b: Bool): Unit
        def appendInt8(i: Int8): Unit
        def appendInt16(i: Int16): Unit
        def appendInt32(i: Int32): Unit
        def appendInt64(i: Int64): Unit
        def appendBigInt(d: BigInt): Unit  
        def appendFloat32(d: Float32): Unit
        def appendFloat64(d: Float64): Unit
        def appendBigDecimal(d: BigDecimal): Unit  
        def appendChar(c: Char): Unit      
        def appendString(s: String): Unit
        def flush(): Unit
        // def finalize(): Unit
    }

    pub def handle(appender: DuckDBAppenderHandle, 
                    f: a -> b \ ef): a -> b \ Fail + ef - DuckDBAppender = x -> {
        let DuckDBAppenderHandle.DuckDBAppenderHandle(jappender) = appender;
        run {
            f(x)
        } with handler DuckDBAppender {

            def askDuckDBAppenderHandle(k) = k(appender)

            def beginRow(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.beginRow() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }
            
            def endRow(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.endRow() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def beginStruct(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.beginStruct() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }
            
            def endStruct(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.endStruct() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def beginUnion(tag, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.beginUnion(tag) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }
            
            def endUnion(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.endUnion() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendNull(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.appendNull() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }


            def appendBool(b, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(b) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }


            def appendInt8(i, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(i) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendInt16(i, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(i) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendInt32(i, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(i) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendInt64(i, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(i) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendBigInt(i, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(i) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendFloat32(d, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(d) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendFloat64(d, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(d) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendBigDecimal(d, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(d) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }


            def appendChar(c, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(c) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def appendString(s, k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.append(s) };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }

            def flush(k) = 
                try {
                    unsafe IO as { Fail + ef - DuckDBAppender } { discard jappender.flush() };
                    k()
                } catch {
                    case ex: SQLException => Fail.report(ex.getMessage())
                }
            


        }
    }

    pub def runDuckDBAppender(appender: DuckDBAppenderHandle, 
                                f: Unit -> a \ ef):  a \ Fail + ef - DuckDBAppender = 
        handle(appender, f)()



}
