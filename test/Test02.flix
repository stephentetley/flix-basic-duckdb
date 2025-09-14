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
    use BasicDuckDB.PreparedStatementSetter
    use BasicDuckDB.JDBC.Statement

    @test
    def test01(): Bool \ IO =
        Result.flatten(run {
            let dir = FileWrite.mkTempDir("flix");
            let url = "jdbc:duckdb:${dir}/test-db-12345.duckdb";
            let _ = DuckDBDriver.execDuckDBConnection(url, () -> {
                let _ = DuckDBConnection.execStatement(() -> {
                    Statement.executeUpdate("CREATE SCHEMA IF NOT EXISTS facts;");
                    Statement.executeUpdate("CREATE TABLE IF NOT EXISTS facts.databases (name VARCHAR NOT NULL, year INTEGER, PRIMARY KEY(name));")
                });
                DuckDBConnection.execDuckDBPreparedStatement("INSERT INTO facts.databases (name, year) VALUES (?,?);", () -> {
                    let _ = DuckDBPreparedStatement.execPreparedStatementSetter(dbSetter("SQLite", 2000));
                    DuckDBPreparedStatement.addBatch();
                    let _ = DuckDBPreparedStatement.execPreparedStatementSetter(dbSetter("DuckDB", 2019));
                    DuckDBPreparedStatement.addBatch();
                    DuckDBPreparedStatement.executeBatch()
                })
            });
            true
        } with DuckDBDriver.runWithIO 
          with FileWrite.runWithIO) == Ok(true)

     def dbSetter(name: String, year: Int32): Unit -> Unit \ PreparedStatementSetter = () -> {
        PreparedStatementSetter.setString(0, name);
        PreparedStatementSetter.setInt32(1, year)
     }
}

    
