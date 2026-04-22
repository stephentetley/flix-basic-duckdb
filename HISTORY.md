### v0.5.0
   Added UDFs.
   Removed `RowReader` enum.

### v0.4.0
   Updated to work with Flix 0.70.0.

### v0.3.1
   Updated to work with `flix-pretty` dependency.
   Updated DuckDB dependency.
   
### v0.3.0
   Updated to work with `flix-pretty` 0.10.0.
   Exposed modules as `pub` and pushed datatypes down one layer 
   into their respective module.
   Updated tests to use `Assert` effect.

### v0.2.1
   Updated to work with Flix 0.67.0
   
### v0.2.0
   Added `Shim` modules for simplified CSV, Xlsx access.
   Wrapped `RowReader` with a constructor (the effect is now called `ReadRow`).
   `RowAppender` and `PreparedStatementSetter` are also wrapper with constructors.

### v0.1.0
   First release - should be considered a "preview". APIs will change.
