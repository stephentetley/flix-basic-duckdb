// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test01 {

    use Assert.{assertEq}
    use BasicDuckDB.DuckDBDriver.{DuckDBDriver}


    @Test
    def test01(): Unit \ {Assert + IO} =
        assertEq(
            expected = Ok(true), 
            (run {
                let major = DuckDBDriver.getMajorVersion();
                let minor = DuckDBDriver.getMinorVersion();
                println("${major}.${minor}");
                true
            } with BasicDuckDB.DuckDBDriver.runWithIO)
        )


}

    
