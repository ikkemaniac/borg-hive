What is Borg Hive?
------------------

Borg Hive is a management interface for borgbackup repositories.

The main goal of Borg Hive is to provide a easy management of borg repositories and ssh keys and provide notifications if there is a stale backup. Optionally, it collects some events and statistics what's happening.

I backup my peripherals at home with borgbackup, which works nice on my servers, android phones, laptops, worktsations and so on.
To keep the overview over my backups and which device haven't done one in a while I decided to write a dashboard for it. The focus is for backups at home, but Borghive should also work in the cloud.

.. warning:: **This is under active development. It's Alpha!**

Features
--------
* Repository Managment
* Repository Statistics
* SSH-Key Management
* Notifications of stale backups
* Partially Repository Events

What it should also have in the Future / Todo
----------------------------------------------
* More Notification Types

  * GET/POST Webhooks
  * Pushover
  * https://github.com/jazzband/django-push-notifications

* Permission Modeling (Multiple Users Access to same Keys and Repos)
* REST API (Django Rest Framework)
* Send Logs from borg client / borgmatic to API