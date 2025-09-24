// Previously this needed running with classpath pointing to the 
// sqlite / duckdb jars, but it seems that is unnecessary now we
// call `Class.forName("org.duckdb.DuckDBDriver");` in the run 
// function. However we can avoid a warning by enabling native access: 
// 
// > java --enable-native-access=ALL-UNNAMED -jar ../bin/flix-0.62.0.jar test


mod Test02 {

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBPreparedStatement
    use BasicDuckDB.AppendRow
    use BasicDuckDB.RowAppender
    use BasicDuckDB.RowAppender.RowAppender
    use BasicDuckDB.RowReader
    use BasicDuckDB.RowReader.RowReader
    use BasicDuckDB.ReadRow
    use BasicDuckDB.JDBC.Statement

    @test
    def test01(): Bool \ IO =
        Result.flatten(run {
            let dir = FileWrite.mkTempDir("flix_test02");
            let url = "jdbc:duckdb:${dir}/test02_db.duckdb";
            let _ = DuckDBDriver.execDuckDBConnection(url, () -> {
                let _ = DuckDBConnection.execStatement(() -> {
                    Statement.executeUpdate("CREATE SCHEMA IF NOT EXISTS facts;");
                    Statement.executeUpdate("CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));")
                });
                let _ = DuckDBConnection.execRowAppender("facts", "databases", 
                            xy -> xy ||> appender,
                            List#{("DuckDB", 2019), ("SQLite", 2000)});
                DuckDBConnection.queryForEach(dbReader(), "SELECT * FROM facts.databases;")
            });
            true
        } with DuckDBDriver.runWithIO 
          with FileWrite.runWithIO) == Ok(true)

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


    
