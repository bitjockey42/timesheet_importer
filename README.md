# README

For some reason, you cannot, as a regular user, import CSVs of a timesheet into the Harvest web UI.

So I wrote a script that takes a CSV file with the format specified below to import my time tracked for work.

## CSV Format

The CSV must include these columns:

* Date - "%d-%m-%Y" (example: "05/10/1999" for 5 October, 1999)
* Client - the name of the client
* Project - the name of the project
* Task - the name of the task
* Notes - any notes you may have
* Hours - the hours in decimal form (example: 8 and a half hours == 8.5)

## NOTE

I wrote this within the space of about 2 hours or so, so it is probably not that fantastic. With that said, it may not work that great so I'd be careful if you want to use it.
