md5db
======

Creates a database of md5 hashes from a word list. My purpose behind creating this was
I needed a list of md5 hashes from a word file. 

### Building

First configure it, build then run.

    $ cabal configure
    $ cabal build
    $ cabal run
     
or to run it without cabal

    $ ./dist/build/md5b/md5b

### Word lists
Put each word on its own line.

### MD5 DB
This will later be moved over to sqlite, but for now the file is a csv saved in the format
of "string,md5" with a new line separating each one.
