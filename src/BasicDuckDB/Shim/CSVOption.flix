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
    use BasicDuckDB.Shim.Internal.Utils.{argument, varchar, boolean, argList}

    pub enum CSVOption {
        case AllVarchar(Bool)
        case Delim(String)
        case Header(Bool)
        case IgnoreErrors(Bool)
        case Quote(String)
    }

    instance Pretty[CSVOption] {
        pub override def pPrint(o: CSVOption): Doc = match o {
            case CSVOption.AllVarchar(b) => argument("all_varchar", boolean(b))
            case CSVOption.Delim(s) => argument("delim", varchar(s))
            case CSVOption.Header(b) => argument("header", boolean(b))
            case CSVOption.IgnoreErrors(b) => argument("ignore_errors", boolean(b))
            case CSVOption.Quote(s) => argument("quote", varchar(s))
        }
        
        pub override def pPrintList(l: PrettyLevel, xs: List[CSVOption]) : Doc = argList(l, xs)
            
    }


}

mod BasicDuckDB.Shim.CSVOption {

    use BasicDuckDB.Shim.CSVOption


    pub def all_varchar(b: Bool): CSVOption = CSVOption.AllVarchar(b)

    pub def delim(s: String): CSVOption = CSVOption.Delim(s)

    pub def header(b: Bool): CSVOption = CSVOption.Header(b)

    pub def ignore_errors(b: Bool): CSVOption = CSVOption.IgnoreErrors(b)

    pub def quote(s: String): CSVOption = CSVOption.Quote(s)

}
