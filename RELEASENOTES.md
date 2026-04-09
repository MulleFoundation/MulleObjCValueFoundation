## 0.25.0











feature: add UTF-16 string support and improve data/string robustness

* Add UTF-16 creation helpers: mulleInitWithUTF16String: and `_MulleObjCNewASCIIStringWithUTF16Characters` / MulleObjCNewASCIIStringWithUTF16Characters for creating NSStrings from UTF‑16 input
* Prevent NULL dereference in NSData hashing and suppress unused-owner warning in NSMutableData
* Add memmem implementation on Windows to improve cross-platform string search behavior
* **BREAKING** rename MulleObjCLoader(MulleObjCValueFoundation) → MulleObjCDeps(MulleObjCValueFoundation); update any callers referencing the old category/type
