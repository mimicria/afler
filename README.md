[![forthebadge](https://forthebadge.com/images/badges/it-works-why.svg)](https://forthebadge.com)

## Usage:
```
docker run -it mimicria/afler:ub2204 /bin/bash
```
> `/bin/sh` in Alpine

Usable utilities inside:
- [afl-fuzz](https://github.com/AFLplusplus/AFLplusplus)
- [afl-cov](https://github.com/mrash/afl-cov)
- [afl-collect](https://gitlab.com/rc0r/afl-utils)
- [fuzzman](https://github.com/fuzzah/fuzzaide)
- [casr](https://github.com/ispras/casr)
- [afltriage](https://github.com/quic/AFLTriage)

|OS				|GCC version|Clang version	|Image size (compressed)|
|---------------|-----------|---------------|-----------------------|
|Alpine			|12.2.1		|15.0.5			|533.72 MB				|
|Alt			|10.3.1		|14.0.6			|1.61 GB				|
|Ubuntu 22.04	|11.3		|14.0			|733.72 MB				|
|Ubuntu 20.04	|9.4.0		|10.0.0			|429.48 MB				|
|Ubuntu 18.04	|7.5.0		|6.0.0			|443.48 MB				|
|OpenSUSE 15.4	|7.5.0		|13.0.1			|662.18 MB				|
|OpenSUSE 15.5	|7.5.0		|15.0.7			|647.36 MB				|
|Centos 7		|10.2.1		|14.0.6			|2.14 GB					|
|Centos 7 g4	|4.8.5		|-				|344.82 MB				|
|Centos 8		|8.5.0		|14.0.6			|1.91 GB				|

## Extra
By default in `Centos 7` GCC 4.8.5. 

To enable GCC 10.2.1 enter `source scl_source enable devtoolset-10` before building.
