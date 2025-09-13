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


mod BasicJDBC {

    import java.sql.{Struct => JStruct}
    
    pub enum StructHandle (JStruct)

}

mod BasicJDBC.StructHandle {

    use BasicJDBC.StructHandle
    use BasicJDBC.StructHandle.StructHandle

    pub def getSQLTypeName(s: StructHandle): String = 
        let StructHandle(s1) = s;
        unsafe s1.getSQLTypeName()

}