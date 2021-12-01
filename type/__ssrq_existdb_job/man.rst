cdist-type__ssrq_existdb_job(7)
===============================

NAME
----
cdist-type__ssrq_existdb_job - Manage eXist-db jobs


DESCRIPTION
-----------
This space intentionally left blank.


REQUIRED PARAMETERS
-------------------
type
   the type of this job.

   Must be one of:

   ``system``
      require the database to be in a consistent state to be executed.
      All database operations will be stopped until the job finishes (successfully or not).
      Any exception will be caught and a warning will be written to the log.
   ``user``
      may be scheduled at any time and may be mutually exclusive or
      non-exclusive
version
   the version of the installed eXist-db server for which this job should be
   managed.

   cf. :strong:`cdist-type__ssrq_existdb_server`\ (7)


OPTIONAL PARAMETERS
-------------------
class
   the fully-qualified name of the Java class if this job is implemented in Java.
   The Java class should extend either ``org.exist.storage.SystemTask`` or
   ``org.exist.scheduler.UserJavaJob``.

   This parameter is mutually exclusive with ``--xquery``.
cron
   the cron specification when this job should be executed.
parameter
   | A parameter to set for this job (refer to the documentation for acceptable parameters).
   | The value must me of the form ``key=value``.

   This parameter can be used multiple times.
state
   Must be one of:

   ``present``
      the job is defined in the eXist config file
   ``absent``
      the job is not defined in the eXist config file
xquery
   the path to the XQuery file stored in the database that implements this job,
   e.g. ``/db/myCollection/myJob.xql``.

   Using ``--xquery`` is not suitable for system jobs (``--type system``).

   XQuery jobs will be running under the guest account, but may switch to
   another user via ``xmldb:login()``.


BOOLEAN PARAMETERS
------------------
unschedule-on-exception
   when an exception is encountered during execution of a job then the job is
   unscheduled until the DB is restarted


EXAMPLES
--------

.. code-block:: sh

   # Create a job for periodic backups
   __ssrq_existdb_job periodic-backups \
      --version 5.3.0 \
      --type system \
      --class org.exist.storage.ConsistencyCheckTask \
      --cron '0 0 * * * ?' \
      --parameter output=export \
      --parameter backup=yes \
      --parameter incremental=no \
      --parameter incremental-check=no \
      --parameter max=2


SEE ALSO
--------
:strong:`cdist-type__ssrq_existdb_server`\ (7)


AUTHORS
-------
Dennis Camera <dennis.camera--@--ssrq-sds-fds.ch>


COPYING
-------
Copyright \(C) 2021 Dennis Camera. You can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.
