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



pub mod BasicDuckDB.RowAppender {

    use BasicDuckDB.Base.Fail.Fail
    use BasicDuckDB.DuckDBAppender.{DuckDBAppenderHandle}

    import java.sql.{SQLException => JSQLException}
    import java.lang.Throwable
    

    pub eff AppendRow {
        def appendNull(): Unit
        def appendBool(value: Bool): Unit
        def appendInt8(value: Int8): Unit
        def appendInt16(value: Int16): Unit
        def appendInt32(value: Int32): Unit
        def appendInt64(value: Int64): Unit
        def appendBigInt(value: BigInt): Unit
        def appendFloat32(value: Int32): Unit
        def appendFloat64(value: Int64): Unit
        def appendBigDecimal(value: BigDecimal): Unit
        def appendChar(value: Char): Unit
        def appendString(value: String): Unit
    }

    pub def handle(appender: DuckDBAppenderHandle, f: a -> b \ ef): a -> b \ Fail + ef - AppendRow =
        x -> {
            let DuckDBAppenderHandle.DuckDBAppenderHandle(jappender) = appender;
            run {
                f(x)
            } with handler AppendRow {
                
                def appendNull(k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.appendNull() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendBool(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendInt8(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendInt16(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendInt32(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendInt64(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendBigInt(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendFloat32(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendFloat64(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendBigDecimal(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendChar(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

                def appendString(value, k) = try {
                    unsafe IO as {Fail + ef - AppendRow} { discard jappender.append(value) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            }
        }

    pub def runAppendRow(appender: DuckDBAppenderHandle, 
                        f: Unit -> a \ ef): a \ Fail + ef - AppendRow = 
        handle(appender, f)()

}
