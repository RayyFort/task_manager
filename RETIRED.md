# Retired

This Flutter app has been replaced by the task calendar inside
**minmax tracker** — <https://minmax.rays.website>
(source: <https://github.com/RayyFort/minmax-tracker>).

## What happened

- All 486 tasks were migrated out of Firestore into minmax tracker's SQLite
  database. Firestore timestamps (UTC) were converted back to the local
  wall-clock times this app originally wrote, using `US/Eastern`.
- `rays.website` now serves a 302 redirect to `https://minmax.rays.website`
  instead of this app.
- The auto-deploy workflows were moved to `.github/disabled-workflows/` so a
  push here can no longer overwrite that redirect.

## Nothing was deleted

- The Firestore `users/{uid}/tasks` collection is untouched and still holds the
  original documents.
- This repository and its history are intact.
- The previous Flutter deploy is still in Firebase Hosting's version history and
  can be rolled back from the Firebase console.

## To bring it back

Restore the workflow files to `.github/workflows/` and push to `main`, or run
`firebase deploy --only hosting` from a checkout of this repo.
