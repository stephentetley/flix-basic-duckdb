// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test05 {
    use Assert.{assertEq}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.RowReader
    use BasicDuckDB.RowReader.ReadRow
    use BasicDuckDB.RowReader.ReadRowWithAlt
    // use BasicDuckDB.Shim.SQLite


    use BasicDuckDB.JDBC.Statement.{Statement}

    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = run {
            let url = "jdbc:duckdb:";
            DuckDBDriver.execDuckDBConnection(url, () -> {
                    // SQLite.forEach(rowReader(), 
                    //     "./testdata/countries.sqlite", 
                    //     table_name="country")
                    DuckDBConnection.execStatement(() -> {
                        let command = "SELECT 42;";
                        discard Statement.executeQuery(command)
                    })                    
                })
        } with BasicDuckDB.DuckDBDriver.runWithIOAndFail;
        assertEq(expected = Ok(), answer)

    // def rowReader(): Unit -> Unit \ ReadRowWithAlt + IO = () -> checked_ecast({
    //     let country = ReadRow.getStringByIndex(0);
    //     let capital = ReadRow.getStringByIndex(1);
    //     let pop = ReadRow.getFloat64ByIndex(2);
    //     println("${country}, capital city: ${capital}, population in millions: ${pop}")
    // })

}


    
