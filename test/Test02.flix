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
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.RowAppender.AppendRow
    use BasicDuckDB.RowReader.ReadRow
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.JDBC.Statement.{Statement}

    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer:Result[IoError, Bool] = run {
            forM (
                dir <- FileWrite.mkTempDir("flix_test02");
                url <- Ok("jdbc:duckdb:${dir}/test02_db.duckdb");
                _ <- run { 
                        DuckDBDriver.execDuckDBConnection(url, () -> {
                            DuckDBConnection.execStatement(() -> {
                                discard Statement.executeUpdate("CREATE SCHEMA IF NOT EXISTS facts;");
                                discard Statement.executeUpdate("CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));")
                            });
                            DuckDBConnection.execRowAppender("facts", "databases", 
                                        xy -> { let (x, y) = xy; appender(x, y) }, 
                                    List#{("DuckDB", 2019), ("SQLite", 2000)});
                            DuckDBConnection.queryForEach(rowReader(), "SELECT * FROM facts.databases;")
                        })
                    } with BasicDuckDB.DuckDBDriver.runWithIOAndFail
            ) yield true
        } with FileWrite.runWithIO;
        Assert.assertEq(expected = Ok(true), answer)
        

    def appender(name: String, year: Int32): Unit \ AppendRow = {
        AppendRow.appendString(name);
        AppendRow.appendInt32(year)
    }


    def rowReader(): Unit -> Unit \ ReadRowWithAlt + IO = () -> checked_ecast({
        let name = ReadRow.getStringByName("name");
        let year = ReadRow.getInt32ByName("year");
        println("Database: ${name}, Year: ${year}")
    })

}


    
