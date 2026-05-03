// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


pub mod Test03 {
    use Assert.{assertEq}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.RowReader.ReadRowWithAlt
    use BasicDuckDB.RowReader.ReadRow
    use BasicDuckDB.JDBC.Statement.{Statement}
    
    use Fs.FileWrite
    use Fs.WriteFile
    

    // needs a rewrite, not very compelling
    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = run {
            BasicDuckDB.DuckDBDriver.execInMemoryDuckDBConnection(() -> {
                BasicDuckDB.DuckDBConnection.execStatement(() -> {
                    discard Statement.executeUpdate("CREATE SCHEMA IF NOT EXISTS facts;");
                    discard Statement.executeUpdate("CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));")
                });
                BasicDuckDB.DuckDBConnection.execDuckDBAppender("facts", 
                    "databases", 
                    () -> List.forEach(xy -> { let (x, y) = xy; appender(x, y) }, 
                            List#{("DuckDB", 2019), ("SQLite", 2000)}));
                BasicDuckDB.DuckDBConnection.queryFold(acc -> { let i = rowReader(); Int32.max(acc, i) }, 0, "SELECT * FROM facts.databases;") |> println
            });
            true
        } with BasicDuckDB.DuckDBDriver.runWithIOAndFail;
        assertEq(expected = Ok(true), answer)


    def rowReader(): Int32 \ ReadRowWithAlt = 
        EffectExtras.Alt.withDefault(_ -> ReadRow.getInt32ByName("year"), 1970)
    
    def appender(name: String, year: Int32): Unit \ DuckDBAppender = {
        DuckDBAppender.beginRow();
        DuckDBAppender.appendString(name);
        DuckDBAppender.appendInt32(year);
        DuckDBAppender.endRow()
    }

}


    
