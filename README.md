## Usage:
```
docker run -it mimicria/afler:ub2204 /bin/bash
```
> `/bin/sh` in Alpine

Usable utilities inside:
- afl-fuzz
- afl-cov
- afl-collect
- fuzzman

|OS				|GCC version|Clang version	|Image size (compressed)|
|---------------|-----------|---------------|-----------------------|
|Alpine			|12.2.1		|15.0.5			|491.43 MB				|
|Ubuntu 22.04	|11.3		|14.0			|494.46 MB				|
|Ubuntu 20.04	|9.4.0		|10.0.0			|834.6 MB				|
|Ubuntu 18.04	|7.5.0		|6.0.0			|847.11 MB				|
|Centos 7		|10.2.1		|16.0.0			|2.1 GB					|
|Centos 7 g4	|4.8.5		|-				|344.82 MB				|

## Extra
By default in `Centos 7` GCC 4.8.5. 

To enable 10.2.1 enter `source scl_source enable devtoolset-10` before building.
