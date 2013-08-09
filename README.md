![Screenshot](http://download.penck.de/i/BrowserReload.png)

What does it do?
================

* Watch changes in a folder
* Execute a shell script on change
* Reload a browser tab on change

Why?
====

If you're developing web stuff on your local machine you could auto reload the
browser when you change files in your project.

Or you could rsync your project to a remote server when a file changes and 
then reload your browser with the page on the remote server.

Precedence
==========

The reload will be triggered if there's no script configured or the
defined script has been executed.