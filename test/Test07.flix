
pub mod Test07 {
    use Assert.{assertEq}
    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.DuckDBAppender.DuckDBAppender
    use BasicDuckDB.RowReader.RowReaderWithAlt
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.JDBC.Statement.Statement
    
    def makeTableSpec(): {create_table = String, schema_name = String, table_name = String} = 
        {create_table = "CREATE OR REPLACE TABLE main.t1(database VARCHAR, year INTEGER);", 
            schema_name = "main", 
            table_name = "t1"}
    

    // needs a rewrite, not very compelling
    @Test
    def test01(): Unit \ {Assert + IO} =
        let answer =
            BasicDuckDB.Shim.CSV.exportCSV(
                makeTableSpec(),
                "./testdata/output1.csv",
                List#{},
                xy -> match xy { case (db, yyyy) => appender(db, yyyy) },
                List#{("DuckDB", 2019), ("SQLite", 2000)}
            ) |> Result.map(_ -> true);
        assertEq(expected = Ok(true), answer)

    
    def appender(name: String, year: Int32): Unit \ DuckDBAppender = {
        DuckDBAppender.beginRow();
        DuckDBAppender.appendString(name);
        DuckDBAppender.appendInt32(year);
        DuckDBAppender.endRow()
    }

}


    
