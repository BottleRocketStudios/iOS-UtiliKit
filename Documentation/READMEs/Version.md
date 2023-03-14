# Version

Getting version numbers into user facing strings only requires a function call. *Note this function throws an error if the provided version config contains an invalid key.
A simple implementation with examples in comments might look like this:

``` swift
func printVersions() {
    do {
        let versionString = try Bundle.main.versionString()
        let shortVersionString = try Bundle.main.versionString(for: MyVersionConfig(), isShortVersion: true)
        let verboseVersionString = try Bundle.main.verboseVersionString()
        
        print(versionString) // 5.0.1.123
        print(shortVersionString) // 5.0.1
        print(verboseVersionString) // version 5.0.1.123
    } catch {
        // Handle error
    }
}
```
