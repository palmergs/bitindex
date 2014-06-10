# Bitindex [![Build Status](https://secure.travis-ci.org/palmergs/bitindex.png?branch=master)](http://travis-ci.org/palmergs/bitindex)

Bitindex is a simple gem for writing binary files where the position of a 1 in the bits of the file indicates a true value and 0 indicates a false.  The default is to read from left to right so that a file that consists of `1000 1000` could be read to return true for the value 0 and the value 4 and false for all other integer values.

```ruby
require 'bitindex'

file = 'example.bits'
size_in_bytes = 1024
w = Bitindex::Writer.new file, size_in_bytes
w.write [1,2,3,8000]

r = Bitindex::Reader.new file
r.set? 8000   # true
r.set? 8001   # false
r.set? 2**32  # false
r.all_set(0..10) # [1,2,3]

```


# Install

```ruby
require 'bitindex'
```

# Specifics

A project I was working was given a file that mapped the 32bit address space into a 530MB file where bits set to 1 indicated integer values that were set.  I decided to expand the library to handle both the reading and writing of these files.  Creating files of that size on my desktop (few year old MacBook Pro) takes about 10 minutes.  But reading from the file is fairly quick.  

Future enhancements:
* compressing and decompressing the file
* <del>optimizing the Writer so that it faster for index files with long sequences of 1s or 0s</del> A `block_size` option has been added to enable long blocks of zeros.  On my laptop, the creation of a 530M index with index values went from 10 minutes to about a minute using `{block_size: 1024*1024}`.
* allowing the Writer to set and unset individual bits

# Limitations

This library ignores the potential difference of hardware, bit ordering and all that stuff and relys on the ruby implementation to handle those details.  It is suitable for creating and using files under a common platform and operating system.  
