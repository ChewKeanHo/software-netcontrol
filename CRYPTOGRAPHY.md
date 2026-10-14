# Cryptography Policies

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This document houses the entire program's cryptography deployment, technologies,
and policies in order for the application to function properly.




## Dependencies

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following external dependencies for its full
cryptography operations:

* **OpenSSL (`openssl`)** - all cryptography tools covering checksum digest,
  password hashing, and encryption operations.
* **Tarball (`tar`)** - for directory archiving operation.
* **XZ Compressor (`xz`)** - for data compression operation.
* **GUNZIP Compressor (`gunzip`)** - for data compression operation.




## Methods

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following methods for its cryptography operations:

* **Encryption-then-MAC (`EtM`)** - Using
  *`ARGON2ID` + `CHACHA20` <-> `HMAC-SHA256`* for encryption purpose.




## Passwords

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following algorithm for its password hashing
operations:

* **Argon2id**
  * Minimum characters: `32`
  * Must have **at least ONE(1) `A-Z`**
  * Must have **at least ONE(1) `a-z`**
  * Must have **at least ONE(1) `0-9`**
  * Must have **at least ONE(1) Symbol**
  * Salt:
    * minimum length: `32`
    * default length: `32`
    * length nature: `even number (dividable by 2)`
  * Hash Iteration:
    * minimum: `2` (OWASP)
    * default: `3`
  * Memory Size' in kB:
    * minimum: `19456` (19 * 1024) (OWASP)
    * default: `26624` (26 * 1024)
  * Parallelism:
    * minimum: 1 (OWASP)
    * default: 1

Anything below the minimum and default requirements
**MUST BE STRICTLY REJECTED JUDICIOUSLY**.




## Encryption

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following algorithms for its encryption operations:

* **ChaCha20** - for state-of-the-art performance without hardware restriction
  (e.g. works on everywhere).




## MAC

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following algorithms for its hash-based message
authentication code (HMAC) operations:

* **HMAC-SHA256** (default) - using `SHA-256` hash algorithm.
* **HMAC-SHA512** - using `SHA-512` hash algorithm.
* **HMAC-SHA512-256** - using `SHA512-256` hash algorithm




## Checksum

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following algorithms for its checksum hashing
operations:

* **SHA256** (default)
* **SHA512**
* **SHA512-256**




## Archive

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following algorithms for its archive operations:

* **Tarball (`tar`)** (default)




## Compression

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This program employs the following algorithms for its compression operations:

* **XZ Compressor (`xz`)** (default)
* **GUNZIP Compressor (`gunzip`)**




## Encapsulation

This program employs the following format for its encapsulation operations:

```
-----BEGIN PRIVATE PAYLOAD SIGNATURE-----\n
Method: <HMAC type>\n
\n
\n
<HMAC digest>\n
-----END PRIVATE PAYLOAD SIGNATURE-----\n
-----BEGIN PRIVATE PAYLOAD-----\n
Method: <ID>\n
Encryption: <ID>\n
Salt: <hex>\n
Iteration: <number>\n
Memory-Size: <number>\n
Parallelism: <number>\n
...
\n
\n
<base64 ciphertext>\n
-----END PRIVATE PAYLOAD-----\n
```

Note:

1. Format is **ALWAYS** favor decryption needs.
2. All data **MUST** be Base64 encoded when needed.
3. `HMAC digest` **MUST** be UPPERCASE with colon separator (e.g. `AA:BB:CC:...`).
4. `SIGNATURE` section is optional. Should it be available, it **MUST** be the
   first section.
5. Standards are based on OpenPGP ASCII Armor (RFC 4880 §6) wearing PEM's
   delimiters.




# Epilogue

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

That is all for this document. Thank you for your time.
