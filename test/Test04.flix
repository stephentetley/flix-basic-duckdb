// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


mod Test04 {

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.Shim.Script

    @test
    def test01(): Bool \ IO =
        Result.flatten(run {
            let dir = FileWrite.mkTempDir("flix_test04");
            let url = "jdbc:duckdb:${dir}/test04_db.duckdb";
            let _ = DuckDBDriver.execDuckDBConnection(url, () -> {
                Script.executeFile("./testdata/setup_test04_db.sql")
            });
            true
        } with DuckDBDriver.runWithIO 
          with FileWrite.runWithIO) == Ok(true)


}


    
