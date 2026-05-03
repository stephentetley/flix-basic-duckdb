// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test02 {
    
    
    
    use Fs.FileWrite
    use Fs.WriteFile
    
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.RowReader.ReadRow
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.JDBC.Statement.{Statement}

    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer:Result[IoError, Bool] = run {
            BasicDuckDB.DuckDBDriver.execInMemoryDuckDBConnection(() -> {
                BasicDuckDB.DuckDBConnection.execStatement(() -> {
                    let a1 = Statement.execute("CREATE SCHEMA IF NOT EXISTS facts;CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));");
                    println("Tables created: ${a1}")
                });
                BasicDuckDB.DuckDBConnection.execDuckDBAppender("facts", "databases", 
                    () -> List.forEach(xy -> { let (x, y) = xy; appender(x, y) }, 
                                        List#{("DuckDB", 2019), ("SQLite", 2000)})
                );
                BasicDuckDB.DuckDBConnection.queryForEach(_ -> rowReader(), 
                                                            "SELECT * FROM facts.databases;");
                true
            })
        } with BasicDuckDB.DuckDBDriver.runWithIOAndFail;            
        Assert.assertEq(expected = Ok(true), answer)
        

    def appender(name: String, year: Int32): Unit \ DuckDBAppender = {
        DuckDBAppender.beginRow();
        DuckDBAppender.appendString(name);
        DuckDBAppender.appendInt32(year);
        DuckDBAppender.endRow()
    }


    def rowReader(): Unit \ ReadRowWithAlt + IO = checked_ecast({
        let name = ReadRow.getStringByName("name");
        let year = ReadRow.getInt32ByName("year");
        println("Test02 - Database: ${name}, Year: ${year}")
    })

}


    
