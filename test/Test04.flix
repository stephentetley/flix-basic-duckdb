// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test04 {
    use Assert.{assertEq}

    use EffectExtras.Alt.Alt
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.RowReader.RowReader

    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = run { 
            BasicDuckDB.DuckDBDriver.execInMemoryDuckDBConnection(() -> {
                BasicDuckDB.DuckDBConnection.scalarQuery(
                    "SELECT 42;",
                    () -> { let i = rowReader(); println("Test04: ${i} ") }) |> println
                });
                true
        } with BasicDuckDB.DuckDBDriver.runDuckDBDriver;
        assertEq(expected = Ok(true), answer)


    def rowReader(): Int32 \ RowReader + Alt = 
        EffectExtras.Alt.withDefault(_ -> RowReader.getInt32ByIndex(0), 0)

}


    
