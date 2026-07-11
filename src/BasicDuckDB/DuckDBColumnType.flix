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


pub mod BasicDuckDB.DuckDBColumnType {

    import org.duckdb.{DuckDBColumnType => JDuckDBColumnType}

    pub enum ColumnType with Eq, Order, ToString, Hash {
        case ARRAY
        case BIGINT
        case BIT
        case BLOB
        case BOOLEAN
        case DATE
        case DECIMAL
        case DOUBLE
        case ENUM
        case FLOAT
        case GEOMETRY
        case HUGEINT
        case INTEGER
        case INTERVAL
        case JSON
        case LIST
        case MAP
        case SMALLINT
        case STRUCT
        case TIME
        case TIME_NS
        case TIME_WITH_TIME_ZONE
        case TIMESTAMP
        case TIMESTAMP_MS
        case TIMESTAMP_NS
        case TIMESTAMP_S
        case TIMESTAMP_WITH_TIME_ZONE
        case TINYINT
        case UBIGINT
        case UHUGEINT
        case UINTEGER
        case UNION
        case UNKNOWN
        case USMALLINT
        case UTINYINT
        case UUID
        case VARCHAR
        case VARIANT
    }

    instance ToJava[ColumnType] {
        type Out = JDuckDBColumnType
        pub def toJava(x: ColumnType): JDuckDBColumnType = match x {
            case ColumnType.ARRAY                       => unsafe IO { JDuckDBColumnType.ARRAY }
            case ColumnType.BIGINT                      => unsafe IO { JDuckDBColumnType.BIGINT }
            case ColumnType.BIT                         => unsafe IO { JDuckDBColumnType.BIT }
            case ColumnType.BLOB                        => unsafe IO { JDuckDBColumnType.BLOB }
            case ColumnType.BOOLEAN                     => unsafe IO { JDuckDBColumnType.BOOLEAN }
            case ColumnType.DATE                        => unsafe IO { JDuckDBColumnType.DATE }
            case ColumnType.DECIMAL                     => unsafe IO { JDuckDBColumnType.DECIMAL }
            case ColumnType.DOUBLE                      => unsafe IO { JDuckDBColumnType.DOUBLE }
            case ColumnType.ENUM                        => unsafe IO { JDuckDBColumnType.ENUM }
            case ColumnType.FLOAT                       => unsafe IO { JDuckDBColumnType.FLOAT }
            case ColumnType.GEOMETRY                    => unsafe IO { JDuckDBColumnType.GEOMETRY }
            case ColumnType.HUGEINT                     => unsafe IO { JDuckDBColumnType.HUGEINT }
            case ColumnType.INTEGER                     => unsafe IO { JDuckDBColumnType.INTEGER }
            case ColumnType.INTERVAL                    => unsafe IO { JDuckDBColumnType.INTERVAL }
            case ColumnType.JSON                        => unsafe IO { JDuckDBColumnType.JSON }
            case ColumnType.LIST                        => unsafe IO { JDuckDBColumnType.LIST }
            case ColumnType.MAP                         => unsafe IO { JDuckDBColumnType.MAP }
            case ColumnType.SMALLINT                    => unsafe IO { JDuckDBColumnType.SMALLINT }
            case ColumnType.STRUCT                      => unsafe IO { JDuckDBColumnType.STRUCT }
            case ColumnType.TIME                        => unsafe IO { JDuckDBColumnType.TIME }
            case ColumnType.TIME_NS                     => unsafe IO { JDuckDBColumnType.TIME_NS }
            case ColumnType.TIME_WITH_TIME_ZONE         => unsafe IO { JDuckDBColumnType.TIME_WITH_TIME_ZONE }
            case ColumnType.TIMESTAMP                   => unsafe IO { JDuckDBColumnType.TIMESTAMP }
            case ColumnType.TIMESTAMP_MS                => unsafe IO { JDuckDBColumnType.TIMESTAMP_MS }
            case ColumnType.TIMESTAMP_NS                => unsafe IO { JDuckDBColumnType.TIMESTAMP_NS }
            case ColumnType.TIMESTAMP_S                 => unsafe IO { JDuckDBColumnType.TIMESTAMP_S }
            case ColumnType.TIMESTAMP_WITH_TIME_ZONE    => unsafe IO { JDuckDBColumnType.TIMESTAMP_WITH_TIME_ZONE }
            case ColumnType.TINYINT                     => unsafe IO { JDuckDBColumnType.TINYINT }
            case ColumnType.UBIGINT                     => unsafe IO { JDuckDBColumnType.UBIGINT }
            case ColumnType.UHUGEINT                    => unsafe IO { JDuckDBColumnType.UHUGEINT }
            case ColumnType.UINTEGER                    => unsafe IO { JDuckDBColumnType.UINTEGER }
            case ColumnType.UNION                       => unsafe IO { JDuckDBColumnType.UNION }
            case ColumnType.UNKNOWN                     => unsafe IO { JDuckDBColumnType.UNKNOWN }
            case ColumnType.USMALLINT                   => unsafe IO { JDuckDBColumnType.USMALLINT }
            case ColumnType.UTINYINT                    => unsafe IO { JDuckDBColumnType.UTINYINT }
            case ColumnType.UUID                        => unsafe IO { JDuckDBColumnType.UUID }
            case ColumnType.VARCHAR                     => unsafe IO { JDuckDBColumnType.VARCHAR }
            case ColumnType.VARIANT                     => unsafe IO { JDuckDBColumnType.VARIANT }
        }
    }

    instance ToFlix[ColumnType] {
        type In = JDuckDBColumnType
        pub def toFlix(x: JDuckDBColumnType): ColumnType = unsafe IO {
            if (x.equals(JDuckDBColumnType.ARRAY))                      ColumnType.ARRAY
            else if (x.equals(JDuckDBColumnType.BIGINT))                ColumnType.BIGINT
            else if (x.equals(JDuckDBColumnType.BIT))                   ColumnType.BIT
            else if (x.equals(JDuckDBColumnType.BLOB))                  ColumnType.BLOB
            else if (x.equals(JDuckDBColumnType.BOOLEAN))               ColumnType.BOOLEAN
            else if (x.equals(JDuckDBColumnType.DATE))                  ColumnType.DATE
            else if (x.equals(JDuckDBColumnType.DECIMAL))               ColumnType.DECIMAL
            else if (x.equals(JDuckDBColumnType.DOUBLE))                ColumnType.DOUBLE
            else if (x.equals(JDuckDBColumnType.ENUM))                  ColumnType.ENUM
            else if (x.equals(JDuckDBColumnType.FLOAT))                 ColumnType.FLOAT
            else if (x.equals(JDuckDBColumnType.GEOMETRY))              ColumnType.GEOMETRY
            else if (x.equals(JDuckDBColumnType.HUGEINT))               ColumnType.HUGEINT
            else if (x.equals(JDuckDBColumnType.INTEGER))               ColumnType.INTEGER
            else if (x.equals(JDuckDBColumnType.INTERVAL))              ColumnType.INTERVAL
            else if (x.equals(JDuckDBColumnType.JSON))                  ColumnType.JSON
            else if (x.equals(JDuckDBColumnType.LIST))                  ColumnType.LIST
            else if (x.equals(JDuckDBColumnType.MAP))                   ColumnType.MAP
            else if (x.equals(JDuckDBColumnType.SMALLINT))              ColumnType.SMALLINT
            else if (x.equals(JDuckDBColumnType.STRUCT))                ColumnType.STRUCT
            else if (x.equals(JDuckDBColumnType.TIME))                  ColumnType.TIME
            else if (x.equals(JDuckDBColumnType.TIME_NS))               ColumnType.TIME_NS
            else if (x.equals(JDuckDBColumnType.TIME_WITH_TIME_ZONE))   ColumnType.TIME_WITH_TIME_ZONE
            else if (x.equals(JDuckDBColumnType.TIMESTAMP))             ColumnType.TIMESTAMP
            else if (x.equals(JDuckDBColumnType.TIMESTAMP_MS))          ColumnType.TIMESTAMP_MS
            else if (x.equals(JDuckDBColumnType.TIMESTAMP_NS))          ColumnType.TIMESTAMP_NS
            else if (x.equals(JDuckDBColumnType.TIMESTAMP_S))           ColumnType.TIMESTAMP_S
            else if (x.equals(JDuckDBColumnType.TIMESTAMP_WITH_TIME_ZONE))  ColumnType.TIMESTAMP_WITH_TIME_ZONE
            else if (x.equals(JDuckDBColumnType.TINYINT))               ColumnType.TINYINT
            else if (x.equals(JDuckDBColumnType.UBIGINT))               ColumnType.UBIGINT
            else if (x.equals(JDuckDBColumnType.UHUGEINT))              ColumnType.UHUGEINT
            else if (x.equals(JDuckDBColumnType.UINTEGER))              ColumnType.UINTEGER
            else if (x.equals(JDuckDBColumnType.UNION))                 ColumnType.UNION
            else if (x.equals(JDuckDBColumnType.UNKNOWN))               ColumnType.UNKNOWN
            else if (x.equals(JDuckDBColumnType.USMALLINT))             ColumnType.USMALLINT
            else if (x.equals(JDuckDBColumnType.UTINYINT))              ColumnType.UTINYINT
            else if (x.equals(JDuckDBColumnType.UUID))                  ColumnType.UUID
            else if (x.equals(JDuckDBColumnType.VARCHAR))               ColumnType.VARCHAR
            else if (x.equals(JDuckDBColumnType.VARIANT))               ColumnType.VARIANT
            else bug!("toFlix[ColumnType]")
        }
    }



}
