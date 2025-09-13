// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


mod Test01 {


    use BasicDuckDB.DuckDBDriver


    @test
    def test01(): Bool \ IO =
        (run {
            let mjr = DuckDBDriver.getMajorVersion();
            let mnr = DuckDBDriver.getMinorVersion();
            println("${mjr}.${mnr}");
            true
        } with DuckDBDriver.runWithIO) == Ok(true)


}

    
