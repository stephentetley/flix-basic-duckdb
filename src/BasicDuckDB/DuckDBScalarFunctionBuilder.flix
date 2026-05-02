/*
 * Copyright 2026 Stephen Tetley
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
    
    use EffectExtras.Fail.Fail
    use BasicDuckDB.DuckDBFunctions.RegisteredFunction 
    use BasicDuckDB.DuckDBConnection.DuckDBConnectionHandle
    use BasicDuckDB.DuckDBColumnType.ColumnType
    use BasicDuckDB.DuckDBLogicalType.LogicalType

    import org.duckdb.{DuckDBScalarFunctionBuilder => JDuckDBScalarFunctionBuilder}
    import org.duckdb.{DuckDBFunctions => JDuckDBFunctions}
    import org.duckdb.{DuckDBFunctions$RegisteredFunction => JRegisteredFunction}
    import java.sql.{SQLException => JSQLException}
    import java.util.function.{IntUnaryOperator => JIntUnaryOperator,
        IntBinaryOperator => JIntBinaryOperator,
        LongUnaryOperator => JLongUnaryOperator,
        LongBinaryOperator => JLongBinaryOperator,
        DoubleUnaryOperator => JDoubleUnaryOperator,
        DoubleBinaryOperator => JDoubleBinaryOperator}
    import java.util.function.{Supplier => JSupplier}

    import java.lang.{Integer => JInteger}


    pub enum DuckDBScalarFunctionBuilderHandle (JDuckDBScalarFunctionBuilder)


    pub eff DuckDBScalarFunctionBuilder {
        // `askDuckDBScalarFunctionBuilderHandle` should not be used in user code
        // It is a hack until we can run local effects polymorphically
        def askDuckDBScalarFunctionBuilderHandle(): DuckDBScalarFunctionBuilderHandle    
        def withName(s: String): Unit
        def withNullInNullOut(): Unit
        def withParameter(ctype: ColumnType): Unit
        // def withParameterLogicalType(ltype: LogicalType): Unit
        def withReturnType(ctype: ColumnType): Unit
        def withUnaryInt32Function(f: Int32 -> Int32): Unit
        def withBinaryInt32Function(f: Int32 -> Int32 -> Int32): Unit
        def withUnaryInt64Function(f: Int64 -> Int64): Unit
        def withBinaryInt64Function(f: Int64 -> Int64 -> Int64): Unit
        def withUnaryFloat64Function(f: Float64 -> Float64): Unit
        def withBinaryFloat64Function(f: Float64 -> Float64 -> Float64): Unit
        def withVolatile(): Unit
    }


    // Registers the function - doesn't need to return it
    pub def handle(conn: DuckDBConnectionHandle, 
                    f: a -> b \ ef): a -> b \ Fail + ef - DuckDBScalarFunctionBuilder = x -> {
        let builder = unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { JDuckDBFunctions.scalarFunction() };
        let ans = run {
            f(x)
        } with handler DuckDBScalarFunctionBuilder {
                        
            def askDuckDBScalarFunctionBuilderHandle(k) = 
                k(DuckDBScalarFunctionBuilderHandle.DuckDBScalarFunctionBuilderHandle(builder))

            def withName(s, k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withName(s) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withNullInNullOut(k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withNullInNullOut() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def withParameter(p, k) = 
                try {
                    let jparam = BasicDuckDB.DuckDBColumnType.marshalColumnType(p) ;
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withParameter(jparam) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }
            
            def withReturnType(p, k) = 
                try {
                    let jparam = BasicDuckDB.DuckDBColumnType.marshalColumnType(p) ;
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withReturnType(jparam) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withUnaryInt32Function(fn, k) = 
                try {
                    let jf1: JIntUnaryOperator = makeIntUnaryOperator(fn);
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withIntFunction(jf1) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withBinaryInt32Function(fn, k) = 
                try {
                    let jf1: JIntBinaryOperator = makeIntBinaryOperator(fn);
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withIntFunction(jf1) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withUnaryInt64Function(fn, k) = 
                try {
                    let jf1: JLongUnaryOperator = makeLongUnaryOperator(fn);
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withLongFunction(jf1) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withBinaryInt64Function(fn, k) = 
                try {
                    let jf1: JLongBinaryOperator = makeLongBinaryOperator(fn);
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withLongFunction(jf1) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withUnaryFloat64Function(fn, k) = 
                try {
                    let jf1: JDoubleUnaryOperator = makeDoubleUnaryOperator(fn);
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withDoubleFunction(jf1) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withBinaryFloat64Function(fn, k) = 
                try {
                    let jf1: JDoubleBinaryOperator = makeDoubleBinaryOperator(fn);
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withDoubleFunction(jf1) };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

            def withVolatile(k) = 
                try {
                    unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { discard builder.withVolatile() };
                    k()
                } catch {
                    case ex: JSQLException => Fail.report(ex.getMessage())
                }

        };
        let DuckDBConnectionHandle.DuckDBConnectionHandle(jconn) = conn;
        discard unsafe IO as {Fail + ef - DuckDBScalarFunctionBuilder} { builder.register(jconn) };
        ans
    }

    def makeIntUnaryOperator(f: Int32 -> Int32 \ ef): JIntUnaryOperator =
        i -> unchecked_cast(f(i) as _ \ IO)

    def makeIntBinaryOperator(f: (Int32, Int32) -> Int32 \ ef): JIntBinaryOperator =
        unsafe IO { 
            new JIntBinaryOperator {
                def applyAsInt(_this: JIntBinaryOperator, u: Int32, v: Int32): Int32 \ ef = 
                    f(u, v)
            }
        }
        
    def makeLongUnaryOperator(f: Int64 -> Int64 \ ef): JLongUnaryOperator =
        i -> unchecked_cast(f(i) as _ \ IO)

    def makeLongBinaryOperator(f: (Int64, Int64) -> Int64 \ ef): JLongBinaryOperator =
        unsafe IO { 
            new JLongBinaryOperator {
                def applyAsLong(_this: JLongBinaryOperator, u: Int64, v: Int64): Int64 \ ef = 
                    f(u, v)
            }
        }

    def makeDoubleUnaryOperator(f: Float64 -> Float64 \ ef): JDoubleUnaryOperator =
        i -> unchecked_cast(f(i) as _ \ IO)

    def makeDoubleBinaryOperator(f: (Float64, Float64) -> Float64 \ ef): JDoubleBinaryOperator =
        unsafe IO { 
            new JDoubleBinaryOperator {
                def applyAsDouble(_this: JDoubleBinaryOperator, u: Float64, v: Float64): Float64 \ ef = 
                    f(u, v)
            }
        }

    def makeSupplier(f: Unit -> a \ ef): JSupplier[a] =
        unsafe IO { 
            new JSupplier[a] {
                def get(_this: JSupplier[a]): a \ ef = 
                    f()
            }
        }

    // `a` must be an object
    pub def withSupplier(f: Unit -> a \ ef): Unit \ DuckDBScalarFunctionBuilder + ef =
        let DuckDBScalarFunctionBuilderHandle.DuckDBScalarFunctionBuilderHandle(jbuilder) = DuckDBScalarFunctionBuilder.askDuckDBScalarFunctionBuilderHandle();
        let supplier = makeSupplier(f);
        unsafe IO as {DuckDBScalarFunctionBuilder + ef } { discard jbuilder.withFunction(supplier)}


    // // This doesn't work - probably needs the DuckDB JNI to add methods that take IntSupplier, LongSupplier, DoubleSupplier
    // pub def withInt32Supplier(f: Unit -> Int32 \ ef): Unit \ DuckDBScalarFunctionBuilder + ef =
    //     let DuckDBScalarFunctionBuilderHandle.DuckDBScalarFunctionBuilderHandle(jbuilder) = DuckDBScalarFunctionBuilder.askDuckDBScalarFunctionBuilderHandle();
    //     def f1(): JInteger = unsafe IO { JInteger.valueOf(f()) };
    //     let supplier = makeSupplier(f1);
    //     unsafe IO as {DuckDBScalarFunctionBuilder + ef } { discard jbuilder.withFunction(supplier)}


    /// This takes care of registering the function
    pub def runDuckDBScalarFunctionBuilder(conn: DuckDBConnectionHandle, 
                        f: Unit -> a \ ef): a \ Fail + ef - DuckDBScalarFunctionBuilder = 
        handle(conn, f)()


}
