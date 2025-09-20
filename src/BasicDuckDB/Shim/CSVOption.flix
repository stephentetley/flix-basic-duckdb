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
    use BasicDuckDB.Shim.Internal.Utils.{argument, varchar, boolean, bigint, 
        listOfVarchar, structOfVarchar, listOfTypename, argList}

    pub enum CSVOption {
        case AllVarchar(Bool)
        case AllowQuotedNulls(Bool)
        case AutoDetect(Bool)
        case AutoTypeCandidates(List[String])
        case BufferSize(BigInt)
        case Columns(List[(String, String)])
        case Comment(String)
        case Compression(String)
        case DateFormat(String)
        case DecimalSeparator(String)
        case Delim(String)
        case Escape(String)
        case Encoding(String)
        case Filename(Bool)
        case Header(Bool)
        case ForceNotNull(List[String])
        case HivePartitioning(Bool)
        case IgnoreErrors(Bool)
        case MaxLineSize(BigInt)
        case Names(List[String])
        case NewLine(String)
        case NormalizeNames(Bool)
        case NullPadding(Bool)
        case Nullstr(List[String])
        case Parallel(Bool)
        case Quote(String)
        case RejectsScan(String)
        case RejectsTable(String)
        case RejectsLimit(BigInt)
        case SampleSize(BigInt)
        case Sep(String)
        case Skip(BigInt)
        case StoreRejects(Bool)
        case StrictMode(Bool)
        case Thousands(String)
        case TimestampFormat(String)
        case Types(List[String])
        case UnionByName(Bool)
    }

    instance Pretty[CSVOption] {
        pub override def pPrint(o: CSVOption): Doc = match o {
            case CSVOption.AllVarchar(b) => argument("all_varchar", boolean(b))
            case CSVOption.AllowQuotedNulls(b) => argument("allow_quoted_nulls", boolean(b))
            case CSVOption.AutoDetect(b) => argument("auto_detect", boolean(b))
            case CSVOption.AutoTypeCandidates(xs) => argument("auto_type_candidates", listOfTypename(xs))
            case CSVOption.BufferSize(i) => argument("buffer_size", bigint(i))
            case CSVOption.Columns(xs) => argument("columns", structOfVarchar(xs))
            case CSVOption.Comment(s) => argument("comment", varchar(s))
            case CSVOption.Compression(s) => argument("compression", varchar(s))
            case CSVOption.DateFormat(s) => argument("date_format", varchar(s))
            case CSVOption.DecimalSeparator(s) => argument("decimal_separator", varchar(s))
            case CSVOption.Delim(s) => argument("delim", varchar(s))
            case CSVOption.Encoding(s) => argument("encoding", varchar(s))
            case CSVOption.Escape(s) => argument("escape", varchar(s))
            case CSVOption.Filename(b) => argument("filename", boolean(b))
            case CSVOption.ForceNotNull(xs) => argument("force_not_null", listOfVarchar(xs))
            case CSVOption.Header(b) => argument("header", boolean(b))
            case CSVOption.HivePartitioning(b) => argument("hive_partitioning", boolean(b))
            case CSVOption.IgnoreErrors(b) => argument("ignore_errors", boolean(b))
            case CSVOption.MaxLineSize(i) => argument("max_line_size", bigint(i))
            case CSVOption.Names(xs) => argument("names", listOfVarchar(xs))
            case CSVOption.NewLine(s) => argument("new_line", varchar(s))
            case CSVOption.NormalizeNames(b) => argument("normalize_names", boolean(b))
            case CSVOption.NullPadding(b) => argument("null_padding", boolean(b))
            case CSVOption.Nullstr(xs) => argument("nullstr", listOfVarchar(xs))
            case CSVOption.Parallel(b) => argument("parallel", boolean(b))
            case CSVOption.Quote(s) => argument("quote", varchar(s))
            case CSVOption.RejectsScan(s) => argument("rejects_scan", varchar(s))
            case CSVOption.RejectsTable(s) => argument("rejects_table", varchar(s))
            case CSVOption.RejectsLimit(i) => argument("rejects_limit", bigint(i))
            case CSVOption.SampleSize(i) => argument("sample_size", bigint(i))
            case CSVOption.Sep(s) => argument("sep", varchar(s))
            case CSVOption.Skip(i) => argument("skip", bigint(i))
            case CSVOption.StoreRejects(b) => argument("store_rejects", boolean(b))
            case CSVOption.StrictMode(b) => argument("strict_mode", boolean(b))
            case CSVOption.Thousands(s) => argument("thousands", varchar(s))
            case CSVOption.TimestampFormat(s) => argument("timestamp_format", varchar(s))
            case CSVOption.Types(xs) => argument("types", listOfVarchar(xs))
            case CSVOption.UnionByName(b) => argument("union_by_name", boolean(b))
        }
        
        pub override def pPrintList(l: PrettyLevel, xs: List[CSVOption]) : Doc = argList(l, xs)
            
    }


}

mod BasicDuckDB.Shim.CSVOption {

    use BasicDuckDB.Shim.CSVOption


    pub def all_varchar(b: Bool): CSVOption = CSVOption.AllVarchar(b)

    pub def allow_quoted_nulls(b: Bool): CSVOption = CSVOption.AllowQuotedNulls(b)

    pub def auto_detect(b: Bool): CSVOption = CSVOption.AutoDetect(b)

    pub def auto_type_candidates(xs: List[String]): CSVOption = CSVOption.AutoTypeCandidates(xs)

    pub def buffer_size(i: BigInt): CSVOption = CSVOption.BufferSize(i)

    pub def columns(xs: List[(String, String)]): CSVOption = CSVOption.Columns(xs)

    pub def comment(s: String): CSVOption = CSVOption.Comment(s)

    pub def compression(s: String): CSVOption = CSVOption.Compression(s)

    pub def date_format(s: String): CSVOption = CSVOption.DateFormat(s)

    pub def decimal_separator(s: String): CSVOption = CSVOption.DecimalSeparator(s)

    pub def delim(s: String): CSVOption = CSVOption.Delim(s)

    pub def escape(s: String): CSVOption = CSVOption.Escape(s)

    pub def encoding(s: String): CSVOption = CSVOption.Encoding(s)

    pub def filename(b: Bool): CSVOption = CSVOption.Filename(b)

    pub def force_not_null(xs: List[String]): CSVOption = CSVOption.ForceNotNull(xs)

    pub def header(b: Bool): CSVOption = CSVOption.Header(b)

    pub def hive_partitioning(b: Bool): CSVOption = CSVOption.HivePartitioning(b)

    pub def ignore_errors(b: Bool): CSVOption = CSVOption.IgnoreErrors(b)

    pub def max_line_size(i: BigInt): CSVOption = CSVOption.MaxLineSize(i)

    pub def names(xs: List[String]): CSVOption = CSVOption.Names(xs)

    pub def new_line(s: String): CSVOption = CSVOption.NewLine(s)

    pub def normalize_names(b: Bool): CSVOption = CSVOption.NormalizeNames(b)

    pub def null_padding(b: Bool): CSVOption = CSVOption.NullPadding(b)

    pub def nullstr(xs: List[String]): CSVOption = CSVOption.Nullstr(xs)

    pub def parallel(b: Bool): CSVOption = CSVOption.Parallel(b)

    pub def quote(s: String): CSVOption = CSVOption.Quote(s)

    pub def rejects_scan(s: String): CSVOption = CSVOption.RejectsScan(s)

    pub def rejects_table(s: String): CSVOption = CSVOption.RejectsTable(s)

    pub def rejects_limit(i: BigInt): CSVOption = CSVOption.RejectsLimit(i)

    pub def sample_size(i: BigInt): CSVOption = CSVOption.SampleSize(i)

    pub def sep(s: String): CSVOption = CSVOption.Sep(s)

    pub def skip(i: BigInt): CSVOption = CSVOption.Skip(i)

    pub def store_rejects(b: Bool): CSVOption = CSVOption.StoreRejects(b)

    pub def strict_mode(b: Bool): CSVOption = CSVOption.StrictMode(b)

    pub def thousands(s: String): CSVOption = CSVOption.Thousands(s)

    pub def timestamp_format(s: String): CSVOption = CSVOption.TimestampFormat(s)

    // List of types by position, for by name use columns
    pub def types(xs: List[String]): CSVOption = CSVOption.Types(xs)

    pub def union_by_name(b: Bool): CSVOption = CSVOption.UnionByName(b)



}
