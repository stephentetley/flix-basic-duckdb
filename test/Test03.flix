


pub mod Test03 {
    use Assert.{assertEq}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.RowReader.RowReaderWithAlt
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.JDBC.Statement.Statement
    
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
                BasicDuckDB.DuckDBConnection.foldQuery(
                    "SELECT * FROM facts.databases;",
                    acc -> { let i = rowReader(); Int32.max(acc, i) }, 
                    0) |> println
            });
            true
        } with BasicDuckDB.DuckDBDriver.runWithIOAndFail;
        assertEq(expected = Ok(true), answer)


    def rowReader(): Int32 \ RowReaderWithAlt = 
        EffectExtras.Alt.withDefault(_ -> RowReader.getInt32ByName("year"), 1970)
    
    def appender(name: String, year: Int32): Unit \ DuckDBAppender = {
        DuckDBAppender.beginRow();
        DuckDBAppender.appendString(name);
        DuckDBAppender.appendInt32(year);
        DuckDBAppender.endRow()
    }

}


    
