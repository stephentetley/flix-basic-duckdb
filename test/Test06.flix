


pub mod Test06 {
    use Assert.{assertEq}

    use EffectExtras.Fail.Fail
    use BasicDuckDB.{ResultSetRow}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.DuckDBScalarFunctionBuilder.DuckDBScalarFunctionBuilder
    use BasicDuckDB.DuckDBColumnType.ColumnType
    
    // https://github.com/duckdb/duckdb-java/blob/main/UDF.MD


    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = run { 
            BasicDuckDB.DuckDBConnection.execDuckDBScalarFunctionBuilder(buildFun1);
            BasicDuckDB.DuckDBConnection.execDuckDBScalarFunctionBuilder(buildFun2);
            BasicDuckDB.DuckDBConnection.execDuckDBScalarFunctionBuilder(buildFun3);
            BasicDuckDB.JDBCStatement.forEachQuery(
                    "SELECT flix_add_one(42);", 
                    row -> { let i = rowReaderI(row); println("Test06: ${i} ") }) |> println;
            BasicDuckDB.JDBCStatement.forEachQuery(
                    "SELECT flix_add_n(42, 100);",
                    row -> { let i = rowReaderI(row); println("Test06: ${i} ") }) |> println;
            BasicDuckDB.JDBCStatement.forEachQuery(
                    "SELECT flix_get_ten();",
                    row -> { let s = rowReaderS(row); println("Test06 (ten): ${s} ") }) |> println;
            true
        } with BasicDuckDB.JDBCStatement.runJDBCStatement1
          with BasicDuckDB.DuckDBConnection.runInMemoryDuckDBConnection
          with BasicDuckDB.DuckDBDriver.runDuckDBDriver;
        assertEq(expected = Ok(true), answer)


    def rowReaderI(row: ResultSetRow): Int32 \ Fail = 
        BasicDuckDB.RowReader.runRowReader(row, _ -> {
            EffectExtras.Alt.withDefault(_ -> RowReader.getInt32ByIndex(0), 0)
        })

    def rowReaderS(row: ResultSetRow): String  \ Fail = 
        BasicDuckDB.RowReader.runRowReader(row, _ -> {
            EffectExtras.Alt.withDefault(_ -> RowReader.getStringByIndex(0), "")
        })


    def buildFun1(): Unit \ DuckDBScalarFunctionBuilder = {
        DuckDBScalarFunctionBuilder.withName("flix_add_one");
        DuckDBScalarFunctionBuilder.withParameter(ColumnType.INTEGER);
        DuckDBScalarFunctionBuilder.withReturnType(ColumnType.INTEGER);
        DuckDBScalarFunctionBuilder.withUnaryInt32Function(i -> i + 1)
    }

    def buildFun2(): Unit \ DuckDBScalarFunctionBuilder = {
        DuckDBScalarFunctionBuilder.withName("flix_add_n");
        DuckDBScalarFunctionBuilder.withParameter(ColumnType.INTEGER);
        DuckDBScalarFunctionBuilder.withParameter(ColumnType.INTEGER);
        DuckDBScalarFunctionBuilder.withReturnType(ColumnType.INTEGER);
        DuckDBScalarFunctionBuilder.withBinaryInt32Function((i, j) -> i + j)
    }

    def buildFun3(): Unit \ DuckDBScalarFunctionBuilder = {
        DuckDBScalarFunctionBuilder.withName("flix_get_ten");
        DuckDBScalarFunctionBuilder.withReturnType(ColumnType.VARCHAR);
        BasicDuckDB.DuckDBScalarFunctionBuilder.withSupplier(() -> "ten")
    }

    // def buildFun4(): Unit \ DuckDBScalarFunctionBuilder = {
    //     DuckDBScalarFunctionBuilder.withName("flix_get_10");
    //     DuckDBScalarFunctionBuilder.withReturnType(ColumnType.INTEGER);
    //     BasicDuckDB.DuckDBScalarFunctionBuilder.withSupplier(() -> 10)
    // }

}


    
