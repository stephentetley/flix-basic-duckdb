/*
 * Copyright 2026 Stephen Tetley
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


pub mod BasicDuckDB { 

    import org.duckdb.{DuckDBConnection => JDuckDBConnection}
    import org.duckdb.{DuckDBAppender => JDuckDBAppender}
    import org.duckdb.{DuckDBPreparedStatement => JDuckDBPreparedStatement}
    import java.sql.{Statement => JStatement}
    import org.duckdb.{DuckDBResultSet => JDuckDBResultSet}


    pub enum Connection(JDuckDBConnection)


    instance ToJava[Connection] {
        type Out = JDuckDBConnection
        pub def toJava(x: Connection): JDuckDBConnection =
            let Connection.Connection(x1) = x;
            x1
    }

    instance ToFlix[Connection] {
        type In = JDuckDBConnection
        pub def toFlix(x: JDuckDBConnection): Connection = Connection.Connection(x)
    }

    pub enum Appender (JDuckDBAppender)
    
    instance ToJava[Appender] {
        type Out = JDuckDBAppender
        pub def toJava(x: Appender): JDuckDBAppender =
            let Appender.Appender(x1) = x;
            x1
    }

    instance ToFlix[Appender] {
        type In = JDuckDBAppender
        pub def toFlix(x: JDuckDBAppender): Appender = Appender.Appender(x)
    }


    pub enum PreparedStatement (JDuckDBPreparedStatement)

    instance ToJava[PreparedStatement] {
        type Out = JDuckDBPreparedStatement
        pub def toJava(x: PreparedStatement): JDuckDBPreparedStatement =
            let PreparedStatement.PreparedStatement(x1) = x;
            x1
    }

    instance ToFlix[PreparedStatement] {
        type In = JDuckDBPreparedStatement
        pub def toFlix(x: JDuckDBPreparedStatement): PreparedStatement = PreparedStatement.PreparedStatement(x)
    }

    pub enum Statement(JStatement)

    instance ToJava[Statement] {
        type Out = JStatement
        pub def toJava(x: Statement): JStatement =
            let Statement.Statement(x1) = x;
            x1
    }

    instance ToFlix[Statement] {
        type In = JStatement
        pub def toFlix(x: JStatement): Statement = Statement.Statement(x)
    }


    pub enum ResultSet(JDuckDBResultSet)

    instance ToJava[ResultSet] {
        type Out = JDuckDBResultSet
        pub def toJava(x: ResultSet): JDuckDBResultSet =
            let ResultSet.ResultSet(x1) = x;
            x1
    }

    instance ToFlix[ResultSet] {
        type In = JDuckDBResultSet
        pub def toFlix(x: JDuckDBResultSet): ResultSet = ResultSet.ResultSet(x)
    }

    pub enum ResultSetRow(JDuckDBResultSet)

    instance ToJava[ResultSetRow] {
        type Out = JDuckDBResultSet
        pub def toJava(x: ResultSetRow): JDuckDBResultSet =
            let ResultSetRow.ResultSetRow(x1) = x;
            x1
    }

    instance ToFlix[ResultSetRow] {
        type In = JDuckDBResultSet
        pub def toFlix(x: JDuckDBResultSet): ResultSetRow = ResultSetRow.ResultSetRow(x)
    }

    

}