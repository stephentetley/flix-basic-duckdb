/*
 * Copyright 2025 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


mod BasicDuckDB.Shim.Script {

    use BasicDuckDB.DuckDBDriver
    use BasicDuckDB.DuckDBConnection
    use BasicDuckDB.DuckDBResultSet
    use BasicDuckDB.RowReader
    use BasicDuckDB.JDBC.Statement
    
    pub def executeFile(file_name: String): Result[IoError, Bool] \ {IO + DuckDBConnection} =
        run {
            match FileReadWithResult.read(file_name) {
                case Ok(sql) =>
                    DuckDBConnection.execStatement(() -> {
                        Statement.execute(sql)
                    })
                case Err(e) => Err(e)
            }
        } with FileReadWithResult.runWithIO

    pub def executeUpdate(sql: String): Result[IoError, Bool] \ {IO + DuckDBConnection} =
        DuckDBConnection.execStatement(() -> {
            Statement.execute(sql)
        })
        
        
}
