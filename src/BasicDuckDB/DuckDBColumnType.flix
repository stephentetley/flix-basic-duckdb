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

    pub def marshalMonth(x: ColumnType): JDuckDBColumnType =
        match x {
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

    def primEquals(x: JDuckDBColumnType, y: JDuckDBColumnType): Bool =
        unsafe IO { x.equals(y) }

    pub def unmarshalMonth(x: JDuckDBColumnType): ColumnType =
        match x {
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.ARRAY })                    => ColumnType.ARRAY
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.BIGINT })                   => ColumnType.BIGINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.BIT })                      => ColumnType.BIT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.BLOB })                     => ColumnType.BLOB
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.BOOLEAN })                  => ColumnType.BOOLEAN
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.DATE })                     => ColumnType.DATE
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.DECIMAL })                  => ColumnType.DECIMAL
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.DOUBLE })                   => ColumnType.DOUBLE
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.ENUM })                     => ColumnType.ENUM
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.FLOAT })                    => ColumnType.FLOAT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.GEOMETRY })                 => ColumnType.GEOMETRY
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.HUGEINT })                  => ColumnType.HUGEINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.INTEGER })                  => ColumnType.INTEGER
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.INTERVAL })                 => ColumnType.INTERVAL
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.JSON })                     => ColumnType.JSON
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.LIST })                     => ColumnType.LIST
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.MAP })                      => ColumnType.MAP
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.SMALLINT })                 => ColumnType.SMALLINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.STRUCT })                   => ColumnType.STRUCT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIME })                     => ColumnType.TIME
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIME_NS })                  => ColumnType.TIME_NS
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIME_WITH_TIME_ZONE })      => ColumnType.TIME_WITH_TIME_ZONE
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIMESTAMP })                => ColumnType.TIMESTAMP
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIMESTAMP_MS })             => ColumnType.TIMESTAMP_MS
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIMESTAMP_NS })             => ColumnType.TIMESTAMP_NS
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIMESTAMP_S })              => ColumnType.TIMESTAMP_S
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TIMESTAMP_WITH_TIME_ZONE }) => ColumnType.TIMESTAMP_WITH_TIME_ZONE
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.TINYINT })                  => ColumnType.TINYINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.UBIGINT })                  => ColumnType.UBIGINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.UHUGEINT })                 => ColumnType.UHUGEINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.UINTEGER })                 => ColumnType.UINTEGER
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.UNION })                    => ColumnType.UNION
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.UNKNOWN })                  => ColumnType.UNKNOWN
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.USMALLINT })                => ColumnType.USMALLINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.UTINYINT })                 => ColumnType.UTINYINT
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.UUID })                     => ColumnType.UUID
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.VARCHAR })                  => ColumnType.VARCHAR
            case x1 if primEquals(x1, unsafe IO { JDuckDBColumnType.VARIANT })                  => ColumnType.VARIANT
            case _                                                                              => bug!("unmarshalColumnType")
        }



}
