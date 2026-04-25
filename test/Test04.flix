// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test04 {
    use Assert.assert
    use Assert.{assertEq}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    
    use Fs.FileWrite
    use Fs.WriteFile
    use Fs.FileRead

    // TODO chnage to use ".read '<filename>' inside DuckDB"

    // @Test
    // def test01(): Unit \ {Assert + FileRead + IO} =
    // let ans = run {
    //     forM (
    //             dir <- FileWrite.mkTempDir("flix_test04");
    //             url <- Ok("jdbc:duckdb:${dir}/test04_db.duckdb");
    //             _   <- DuckDBDriver.execDuckDBConnection(url, () -> {
    //                         Script.executeFile("./testdata/setup_test04_db.sql")
    //                     })
    //             ) yield true
    //     } with DuckDBDriver.runWithIO 
    //       with FileWrite.runWithIO;
    //     assertEq(
    //         expected = Ok(true),
    //         ans 
    //     )

}


    
