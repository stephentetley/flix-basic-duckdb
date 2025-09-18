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
    use Text.PrettyPrint.{Doc, <<>>, intersperse, text, empty, squotes, equals, comma}
    use BasicDuckDB.Shim.Internal.Utils.{argument, varchar, boolean, argList}

    pub enum XLSXOption {
        case Header(Bool)
        case Sheet(String)
        case AllVarchar(Bool)
        case IgnoreErrors(Bool)
        case Range(String)
        case StopAtEmpty(Bool)
        case EmptyAsVarchar(Bool)
    }

    instance Pretty[XLSXOption] {
        pub override def pPrint(o: XLSXOption): Doc = match o {
            case XLSXOption.Header(b) => argument("header", boolean(b))
            case XLSXOption.Sheet(s) => argument("sheet", varchar(s))
            case XLSXOption.AllVarchar(b) => argument("all_varchar", boolean(b))
            case XLSXOption.IgnoreErrors(b) => argument("ignore_errors", boolean(b))
            case XLSXOption.Range(s) => argument("range", varchar(s))
            case XLSXOption.StopAtEmpty(b) => argument("stop_at_empty", boolean(b))
            case XLSXOption.EmptyAsVarchar(b) => argument("empty_as_varchar", boolean(b))
        }
        
        pub override def pPrintList(l: PrettyLevel, xs: List[XLSXOption]) : Doc = argList(l, xs)
            
    }


}

mod BasicDuckDB.Shim.XLSXOption {

    use BasicDuckDB.Shim.XLSXOption

    pub def header(b: Bool): XLSXOption = XLSXOption.Header(b)

    pub def sheet(s: String): XLSXOption = XLSXOption.Sheet(s)

    pub def all_varchar(b: Bool): XLSXOption = XLSXOption.AllVarchar(b)

    pub def ignore_errors(b: Bool): XLSXOption = XLSXOption.IgnoreErrors(b)

    pub def range(s: String): XLSXOption = XLSXOption.Range(s)

    pub def stop_at_empty(b: Bool): XLSXOption = XLSXOption.StopAtEmpty(b)
    
    pub def empty_as_varchar(b: Bool): XLSXOption =  XLSXOption.EmptyAsVarchar(b)

}
