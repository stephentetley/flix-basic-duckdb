// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test04 {
    use Assert.{assertEq}

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.JDBC.Statement.{Statement}
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.RowReader.ReadRow
    
    

    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = 
            forM (
                url <- Ok("jdbc:duckdb:");
                _   <- run { 
                        BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                            BasicDuckDB.DuckDBConnection.queryForEach(() -> { let i = rowReader(); println("Test04: ${i} ") }, "SELECT 42;") |> println
                        })
                    } with BasicDuckDB.DuckDBDriver.runWithIOAndFail 
            ) yield true;
        assertEq(expected = Ok(true), answer)


    def rowReader(): Int32 \ ReadRowWithAlt = 
        EffectExtras.Alt.withDefault(_ -> ReadRow.getInt32ByIndex(0), 0)

}


    
