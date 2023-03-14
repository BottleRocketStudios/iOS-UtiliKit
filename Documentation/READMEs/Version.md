# Version

Getting version numbers into user facing strings only requires a function call. *Note this function throws an error if the provided version config contains an invalid key.
A simple implementation might look like this:

``` swift
func printVersions() {
    do {
        let customVersionString = try Bundle.main.versionString(for: MyVersionConfig(), isShortVersion: false)
        let verboseVersionString = try Bundle.main.verboseVersionString()
        let versionString = try Bundle.main.versionString()

        print(customVersionString)
        print(verboseVersionString)
        print(versionString)
    } catch {
        print(error)
    }
}
```
