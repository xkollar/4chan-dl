4chan-dl
========

Simple tool for downloading whole threads from [4chan](https://www.4chan.org/).

Usage
-----

* `4chan-dl.sh` -- List of all boards.
* `4chan-dl.sh BOARD` -- List of all threads on the board.
* `4chan-dl.sh BOARD THREAD_ID` -- Download all files (images, webms, ...) into folder `BOARD/THREAD_ID`.

When you re-run download, it will download only new files. (Should download of some file have been interrupted mid-stream,
you might need to delete the corrupt file for it to get re-downloaded.

Requiremetns
------------

* `wget`
* `jq`

Hacking
-------

Patches/pull-requests are welcome `:-)`.
