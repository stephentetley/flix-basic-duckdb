


pub mod Test06 {
    use Assert.{assertEq}

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.JDBC.Statement.Statement
    use BasicDuckDB.RowReader.RowReaderWithAlt
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.DuckDBScalarFunctionBuilder.DuckDBScalarFunctionBuilder
    use BasicDuckDB.DuckDBColumnType.ColumnType
    
    // https://github.com/duckdb/duckdb-java/blob/main/UDF.MD


    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = 
            forM (
                url <- Ok("jdbc:duckdb:");
                _   <- run { 
                        BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                            BasicDuckDB.DuckDBConnection.execDuckDBScalarFunctionBuilder(buildFun1);
                            BasicDuckDB.DuckDBConnection.execDuckDBScalarFunctionBuilder(buildFun2);
                            BasicDuckDB.DuckDBConnection.execDuckDBScalarFunctionBuilder(buildFun3);
                            BasicDuckDB.DuckDBConnection.forEachQuery(
                                "SELECT flix_add_one(42);", 
                                () -> { let i = rowReader(); println("Test06: ${i} ") }) |> println;
                            BasicDuckDB.DuckDBConnection.forEachQuery(
                                "SELECT flix_add_n(42, 100);",
                                () -> { let i = rowReader(); println("Test06: ${i} ") }) |> println;
                            BasicDuckDB.DuckDBConnection.forEachQuery(
                                "SELECT flix_get_ten();",
                                () -> { let s = rowReaderS(); println("Test06 (ten): ${s} ") }) |> println
                        })
                    } with BasicDuckDB.DuckDBDriver.runWithIOAndFail 
            ) yield true;
        assertEq(expected = Ok(true), answer)


    def rowReader(): Int32 \ RowReaderWithAlt = 
        EffectExtras.Alt.withDefault(_ -> RowReader.getInt32ByIndex(0), 0)

    def rowReaderS(): String \ RowReaderWithAlt = 
        EffectExtras.Alt.withDefault(_ -> RowReader.getStringByIndex(0), "")


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


    
