// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test04 {
    use Assert.{assertEq}
    use Fs.FileWrite
    use Fs.WriteFile
    use Fs.FileRead

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.JDBC.Statement.{Statement}
    
    

    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = 
            forM (
                url <- Ok("jdbc:duckdb:");
                _   <- run { 
                        BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                            BasicDuckDB.DuckDBConnection.execStatement(() -> {
                                let command = "SELECT 42;";
                                discard Statement.executeQuery(command)
                            })
                        })
                    } with BasicDuckDB.DuckDBDriver.runWithIOAndFail 
            ) yield true;
        assertEq(expected = Ok(true), answer)

}


    
