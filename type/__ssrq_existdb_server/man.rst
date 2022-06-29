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
   The maximum amount of memory to use for database page buffers.

   The cache size should typically not be more than half of the size of the JVM
   heap size (set by the JVM ``-Xmx`` parameter). It can be larger if you have a
   large-memory JVM (usually a 64bit JVM).

   e.g. ``128M``
java-home
   Path to the JVM to use for eXist-db.

   | If ``--java-home`` is set, this type will not manage the system JVM and just use what you specified.
   | If not, this type will install the default JVM for the given OS.
java-opts
   Additional options to pass to the JVM.

   You may prefix the value to this argument with a :literal:` ` (space) character if
   the string would otherwise start with a ``-`` and thus confusing cdist's
   argument parser.
   The first space will be removed from the value by this type.

   Examples

   * | set the maximum Java heap size:
     | ``-Xmx1024m``
   * | change the HTTP port Jetty/eXist-db listens on:
     | ``-Djetty.port=8080``
   * | change the HTTPS port Jetty/eXist-db listens on:
     | ``-Djetty.ssl.port=8443``
page-size
   The size of one page on the disk.

   This is the smallest unit transferred from and to the database files. Should
   be a multiple of the file system's page size.

   Must *not* be larger than 32767.

   **NB:** the database needs to be reinitialised (i.e. remove all files from data
   directory) if this value is changed after installation.
sync-period
   Defines how often (in milliseconds) the database will flush its internal buffers to disk.
   The sync thread will interrupt normal database operation.
xquery-submission
   Determines who is allowed to submit and execute XQuery to the
   ``EXistServlet``.

   For example the REST server allows submission via ``GET`` using the
   ``_query`` query parameter and via ``POST`` using an XML document with a
   ``<query/>`` document element.

   Acceptable values:
   ``disabled``
      Does not allow anyone to submit XQuery for execution.
   ``enabled``
      Allows anyone to submit XQuery for execution.
   ``authenticated``
      Allows any authenticated (non-guest) user to submit XQuery for execution.
xupdate-submission
   Configure who is allowed to submit and execute XUpdate scripts to the
   ``EXistServlet``.

   Acceptable values:
   ``disabled``
      Does not allow anyone to submit XUpdate for execution.
   ``enabled``
      Allows anyone to submit XUpdate for execution.
   ``authenticated``
      Allows any authenticated (non-guest) user to submit XUpdate for execution.


BOOLEAN PARAMETERS
------------------
disable-guest-xmlrpc
   Prohibit the guest user from accessing the XML RPC API.

   By default, if no user is specified in an XML RPC request,
   the guest user account will be used.
disable-rest-interface
   Disable the REST interface, i.e. only requests coming from the URL rewriting
   will be processed.
no-sync-on-commit
   Do not sync the journal to disk when a database transaction is commited.

   Disabling ``sync-on-commit`` (i.e. using this option) will improve the
   performance, albeit at the risk that some transactions might be lost when the
   system suddenly fails (e.g. interrupted power).

   *NB:* This argument must be used on all "currently known" eXist-db versions
   because the feature is broken.
xquery-hide-errors
   Omit the error description in XQuery error responses.


EXAMPLES
--------

.. code-block:: sh

    # Install a eXist-db server
    __ssrq_existdb_server --version 5.3.1 --no-sync-on-commit


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
