// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


mod Test05 {

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.RowReader
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.ReadRow
    use BasicDuckDB.Shim.SQLite

    @test
    def test01(): Bool \ IO =
        (run {
            let url = "jdbc:duckdb:";
            let _ = DuckDBDriver.execDuckDBConnection(url, () -> {
                SQLite.forEach(rowReader(), 
                    "./testdata/countries.sqlite", 
                    table_name="country")
            });
            true
        } with DuckDBDriver.runWithIO) == Ok(true)

    def rowReader(): RowReader[Unit, IO] = RowReader(() -> {
        let country = ReadRow.getStringByIndex(0);
        let capital = ReadRow.getStringByIndex(1);
        let pop = ReadRow.getFloat64ByIndex(2);
        println("${country}, capital city: ${capital}, population in millions: ${pop}")
    })

}


    
