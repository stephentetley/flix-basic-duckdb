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

}