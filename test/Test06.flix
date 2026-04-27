


pub mod Test06 {
    use Assert.{assertEq}

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.JDBC.Statement.{Statement}
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.RowReader.ReadRow
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
                            BasicDuckDB.DuckDBConnection.queryForEach(() -> { let i = rowReader(); println("Test06: ${i} ") }, "SELECT flix_add_one(42);") |> println;
                            BasicDuckDB.DuckDBConnection.queryForEach(() -> { let i = rowReader(); println("Test06: ${i} ") }, "SELECT flix_add_n(42, 100);") |> println
                        })
                    } with BasicDuckDB.DuckDBDriver.runWithIOAndFail 
            ) yield true;
        assertEq(expected = Ok(true), answer)


    def rowReader(): Int32 \ ReadRowWithAlt = 
        BasicDuckDB.Base.Alt.withDefault(_ -> ReadRow.getInt32ByIndex(0), 0)

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

}


    
