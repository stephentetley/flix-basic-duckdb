// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test02 {
    
    use Assert.{assertEq}
    
    use Fs.FileWrite
    use Fs.WriteFile
    
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.RowAppender
    use BasicDuckDB.RowAppender.{AppendRow}
    use BasicDuckDB.RowAppender.RowAppender
    use BasicDuckDB.RowAppender.RowAppender.{RowAppender}
    use BasicDuckDB.RowReader
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.RowReader.RowReader.{RowReader}
    use BasicDuckDB.RowReader.ReadRow
    use BasicDuckDB.JDBC.Statement.{Statement}

    @Test
    def test01(): Unit \ {Assert + IO} =
        assertEq(
            expected = Ok(true),
            Result.flatten(run {
                forM (
                    dir <- FileWrite.mkTempDir("flix_test02");
                    url <- Ok("jdbc:duckdb:${dir}/test02_db.duckdb");
                    _   <- DuckDBDriver.execDuckDBConnection(url, () -> {
                        let _ = DuckDBConnection.execStatement(() -> {
                            discard Statement.executeUpdate("CREATE SCHEMA IF NOT EXISTS facts;");
                            Statement.executeUpdate("CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));")
                        });
                        let _ = DuckDBConnection.execRowAppender("facts", "databases", 
                                    xy -> xy ||> appender,
                                    List#{("DuckDB", 2019), ("SQLite", 2000)});
                        DuckDBConnection.queryForEach(dbReader(), "SELECT * FROM facts.databases;")
                    })) yield true
            } with BasicDuckDB.DuckDBDriver.runWithIO 
            with FileWrite.runWithIO) 
        )

    def appender(name: String, year: Int32): RowAppender[Unit, {}] = RowAppender(() -> {
        AppendRow.appendString(name);
        AppendRow.appendInt32(year)
    })


    def dbReader(): RowReader[Unit, IO] = RowReader(() -> {
        let name = ReadRow.getStringByName("name");
        let year = ReadRow.getInt32ByName("year");
        println("Database: ${name}, Year: ${year}")
    })

}


    
