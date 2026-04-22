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


pub mod BasicDuckDB.DuckDBLogicalType {

    use BasicDuckDB.DuckDBColumnType.ColumnType

    import org.duckdb.{DuckDBLogicalType => JDuckDBLogicalType}

    pub enum LogicalType(JDuckDBLogicalType)

    pub def decimal(width: {width = Int32}, scale: {scale = Int32}): LogicalType = 
        let jtype = unsafe IO { JDuckDBLogicalType.decimal(width#width, scale#scale) };
        LogicalType.LogicalType(jtype)

    pub def logicalType(colType: ColumnType): LogicalType = 
        let jctype = BasicDuckDB.DuckDBColumnType.marshalColumnType(colType);
        let jltype = unsafe IO { JDuckDBLogicalType.of(jctype) };
        LogicalType.LogicalType(jltype)

}
