// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


mod Test02 {

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection


    @test
    def test01(): Bool \ IO =
        Result.flatten(run {
            let dir = FileWrite.mkTempDir("flix");
            let url = "jdbc:duckdb:${dir}/test-db-12345.duckdb";
            let conn = DuckDBDriver.connect(url);
            let _ = run {DuckDBConnection.close()} with DuckDBConnection.runWithIO(conn);
            true
        } with DuckDBDriver.runWithIO 
          with FileWrite.runWithIO) == Ok(true)


}

    
