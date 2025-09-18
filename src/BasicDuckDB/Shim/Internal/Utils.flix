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

mod BasicDuckDB.Shim.Internal.Utils {

    use Text.Pretty
    use Text.PrettyLevel
    use Text.PrettyPrint.{Doc, <<>>, intersperse, text, empty, squotes, equals, comma}

    pub def argument(name: String, body: Doc): Doc = text(name) <<>> equals() <<>> body
    pub def boolean(b: Bool): Doc = text(if (b) "true" else "false")
    pub def varchar(s: String): Doc = squotes(text(s))

    pub def argList(l: PrettyLevel, xs: List[t]) : Doc with Pretty[t] = match xs {
        case Nil => empty()
        case _ => comma() <<>> intersperse(text(", "), List.map(Pretty.pPrintPrec(l, 0), xs))
    }

    pub def printOptions(opts: List[t]): String with Pretty[t] =
        Text.PrettyPrint.render(100, Text.Pretty.pPrintList(Text.prettyNormal(), opts))

}

