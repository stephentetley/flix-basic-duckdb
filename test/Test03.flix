// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test03 {
    use Assert.{assertEq}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.RowAppender.AppendRow
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.RowReader.ReadRow
    use BasicDuckDB.JDBC.Statement.{Statement}
    
    use Fs.FileWrite
    use Fs.WriteFile
    

    // needs a rewrite, not very compelling
    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = run {
            forM (
                dir <- FileWrite.mkTempDir("flix_test03");
                url <- Ok("jdbc:duckdb:${dir}/test03_db.duckdb");
                _ <- run {
                        BasicDuckDB.DuckDBDriver.execDuckDBConnection(url, () -> {
                            BasicDuckDB.DuckDBConnection.execStatement(() -> {
                                discard Statement.executeUpdate("CREATE SCHEMA IF NOT EXISTS facts;");
                                discard Statement.executeUpdate("CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));")
                            });
                            BasicDuckDB.DuckDBConnection.execRowAppender("facts", 
                                "databases", 
                                xy -> { let (x, y) = xy; appender(x, y) }, 
                                List#{("DuckDB", 2019), ("SQLite", 2000)});
                            BasicDuckDB.DuckDBConnection.queryFold(acc -> { let i = rowReader(); Int32.max(acc, i) }, 0, "SELECT * FROM facts.databases;") |> println
                        })
                } with BasicDuckDB.DuckDBDriver.runWithIOAndFail 
            ) yield true
        } with FileWrite.runWithIO;
        assertEq(expected = Ok(true), answer)


    def rowReader(): Int32 \ ReadRowWithAlt = 
        EffectExtras.Alt.withDefault(_ -> ReadRow.getInt32ByName("year"), 1970)
    
    def appender(name: String, year: Int32): Unit \ AppendRow = {
        AppendRow.appendString(name);
        AppendRow.appendInt32(year)
    }

}


    
