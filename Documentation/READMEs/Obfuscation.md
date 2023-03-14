# Obfuscation

By using an `ObfuscatedKey`, you can build a human-readable key that will not appear simply by running "strings" against your compiled code, and will even not appear as a string within your source code.
Simply create an `ObfuscatedKey` and use the builder variables to encode your key.

``` swift
let key = ObfuscatedKey().T.h.i.s.underscore.I.s.underscore.O.b.f.u.s.c.a.t.e.d.value // This_Is_Obfuscated
let key = ObfuscatedKey().e.x.a.m.p.l.e.dash.n1.n2.n3.n4.n5.value // example-12345
```
