


pub mod Test03 {
    
    use Assert.{assertEq}
    use EffectExtras.Fail.Fail
    use BasicDuckDB.{ResultSetRow}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.JDBCStatement.JDBCStatement
    use BasicDuckDB.RowReader.RowReader
    
    use Fs.FileWrite
    use Fs.WriteFile
    

    // needs a rewrite, not very compelling
    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer = run {
            BasicDuckDB.DuckDBDriver.execInMemoryDuckDBConnection(conn -> {
                BasicDuckDB.DuckDBConnection.runDuckDBConnection(conn, () -> {
                    BasicDuckDB.DuckDBConnection.execStatement(stmt -> {
                        BasicDuckDB.JDBCStatement.runJDBCStatement(stmt, () -> {
                            discard JDBCStatement.executeUpdate("CREATE SCHEMA IF NOT EXISTS facts;");
                            discard JDBCStatement.executeUpdate("CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));")
                        })
                    });
                    BasicDuckDB.DuckDBConnection.execDuckDBAppender("facts", 
                        "databases", 
                        () -> List.forEach(xy -> { let (x, y) = xy; appender(x, y) }, 
                                List#{("DuckDB", 2019), ("SQLite", 2000)}));
                    BasicDuckDB.DuckDBConnection.foldQuery(
                        "SELECT * FROM facts.databases;",
                        (row, acc) -> { let i = rowReader(row); Int32.max(acc, i) }, 
                        0) |> println
                })
            });
            true
        } with BasicDuckDB.DuckDBDriver.runDuckDBDriver;
        assertEq(expected = Ok(true), answer)


    def rowReader(row: ResultSetRow): Int32 \ Fail = 
        BasicDuckDB.RowReader.runRowReader(row, _ -> {
            EffectExtras.Alt.withDefault(_ -> RowReader.getInt32ByName("year"), 1970)
        })
    
    def appender(name: String, year: Int32): Unit \ DuckDBAppender = {
        DuckDBAppender.beginRow();
        DuckDBAppender.appendString(name);
        DuckDBAppender.appendInt32(year);
        DuckDBAppender.endRow()
    }

}


    
