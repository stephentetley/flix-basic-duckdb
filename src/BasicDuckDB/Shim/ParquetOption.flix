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

mod BasicDuckDB.Shim {

    use Text.Pretty
    use Text.PrettyLevel
    use Text.PrettyPrint.{Doc}
    use BasicDuckDB.Shim.Internal.Utils.{argument, varchar, boolean, structOfVarchar, 
        argList}

    pub enum ParquetOption {
        case BinaryAsString(Bool)
        case EncryptionConfig(List[(String, String)])
        case Filename(Bool)
        case FileRowNumber(Bool)
        case HivePartitioning(Bool)
        case UnionByName(Bool)
    }

    instance Pretty[ParquetOption] {
        pub override def pPrint(o: ParquetOption): Doc = match o {
            case ParquetOption.BinaryAsString(b) => argument("binary_as_string", boolean(b))
            case ParquetOption.EncryptionConfig(xs) => argument("encryption_config", structOfVarchar(xs))
            case ParquetOption.Filename(b) => argument("filename", boolean(b))
            case ParquetOption.FileRowNumber(b) => argument("file_row_number", boolean(b))
            case ParquetOption.HivePartitioning(b) => argument("hive_partitioning", boolean(b))
            case ParquetOption.UnionByName(b) => argument("union_by_name", boolean(b))
        }
        
        pub override def pPrintList(l: PrettyLevel, xs: List[ParquetOption]) : Doc = argList(l, xs)
            
    }


}

mod BasicDuckDB.Shim.ParquetOption {

    use BasicDuckDB.Shim.ParquetOption

    pub def binary_as_string(b: Bool): ParquetOption = ParquetOption.BinaryAsString(b)

    pub def encryption_config(xs: List[(String, String)]): ParquetOption = ParquetOption.EncryptionConfig(xs)

    pub def filename(b: Bool): ParquetOption = ParquetOption.Filename(b)

    pub def file_row_number(b: Bool): ParquetOption = ParquetOption.FileRowNumber(b)

    pub def hive_partitioning(b: Bool): ParquetOption = ParquetOption.HivePartitioning(b)

    pub def union_by_name(b: Bool): ParquetOption = ParquetOption.UnionByName(b)

}
