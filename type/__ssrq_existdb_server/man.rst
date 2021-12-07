cdist-type__ssrq_existdb_server(7)
==================================

NAME
----
cdist-type__ssrq_existdb_server - Install and configure eXist Native XML
Database and Application Platform


DESCRIPTION
-----------
This space intentionally left blank.


REQUIRED PARAMETERS
-------------------
version
   The version number of eXist-db to install.


OPTIONAL PARAMETERS
-------------------
cache-size
   maximum amount of memory to use for database page buffers.

   The cache size should typically not be more than half of the size of the JVM
   heap size (set by the JVM ``-Xmx`` parameter). It can be larger if you have a
   large-memory JVM (usually a 64bit JVM).

   e.g. ``128M``
page-size
   The size of one page on the disk.

   This is the smallest unit transferred from and to the database files. Should
   be a multiple of the file system's page size.

   Must not be larger than 32767.
sync-period
   Defines how often (in milliseconds) the database will flush its internal buffers to disk.
   The sync thread will interrupt normal database operation.


BOOLEAN PARAMETERS
------------------
no-sync-on-commit
   Do not sync the journal to disk when a database transaction is commited.

   Disabling ``sync-on-commit`` (i.e. using this option) will improve the
   performance, albeit at the risk that some transactions might be lost when the
   system suddenly fails (e.g. interrupted power).


EXAMPLES
--------

.. code-block:: sh

    # Install a default eXist-db server
    __ssrq_existdb_server main


SEE ALSO
--------
* `<http://exist-db.org>`__


AUTHORS
-------
Dennis Camera <dennis.camera--@--ssrq-sds-fds.ch>


COPYING
-------
Copyright \(C) 2021 Dennis Camera.
You can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.
