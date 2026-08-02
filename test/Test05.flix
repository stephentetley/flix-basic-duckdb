// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test05 {
    
    use Assert.{assertEq}
    use EffectExtras.Fail.Fail
    use BasicDuckDB.{ResultSetRow}
    use BasicDuckDB.RowReader.RowReaderWithAlt
    use BasicDuckDB.RowReader.RowReader



    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = BasicDuckDB.Shim.SQLite.forEach(rowReader, 
                        "./testdata/countries.sqlite", 
                        table_name="country");
        assertEq(expected = Ok(), answer)

    def rowReader(row: ResultSetRow): Unit \ IO + Fail = 
        BasicDuckDB.RowReader.runRowReader(row, _ -> {
            let country = RowReader.getStringByIndex(0);
            let capital = RowReader.getStringByIndex(1);
            let pop = EffectExtras.Alt.withDefault(() -> RowReader.getFloat64ByIndex(2), 0.0f64);
            println("Test05.test01 ${country}, capital city: ${capital}, population in millions: ${pop}")
        })

}


    
