# Online Deployment: Railway

This guide publishes the lab through Railway as two services: an osTicket web service and a private MySQL database. Railway deploys Compose services separately; it does not run this repository's Compose file as one production stack. See Railway's [Docker Compose deployment guide](https://docs.railway.com/guides/docker-compose).

A Railway account and a linked GitHub repository are required. Check your plan and current usage before deploying because hosting can use credits or incur charges. Use fictional training data only.

## 1. Push the repository to GitHub

Push the project files and confirm that `.env` is not tracked. Never publish credentials, real tickets, or screenshots containing personal data.

## 2. Create the database service

Add a Railway MySQL service to the project and keep its database private. The osTicket installer uses these variables from the MySQL service:

- `MYSQLHOST`
- `MYSQLPORT`
- `MYSQLDATABASE`
- `MYSQLUSER`
- `MYSQLPASSWORD`

The web service connects to the database through Railway's private network. Do not create a public database endpoint.

## 3. Create the osTicket web service

Add a service from this GitHub repository. Railway should build the root `Dockerfile`. Generate a Railway HTTPS domain for the service and set its target port to `80`.

Railway allows one volume per service. Attach one persistent volume to the web service at `/var/lib/osticket-config`. The container stores `ost-config.php` there and, on Railway, keeps uploaded attachments in its `attachments/` subdirectory. The entrypoint links that subdirectory to osTicket's expected `/var/www/html/attachments` path. The database service has its own persistent storage.

## 4. Install osTicket

Open the generated HTTPS domain followed by `/setup/` and run the installer. In the Railway dashboard, open the MySQL service's Variables panel and use:

- Database host: `MYSQLHOST`
- Database port: `MYSQLPORT`
- Database name: `MYSQLDATABASE`
- Database user: `MYSQLUSER`
- Database password: `MYSQLPASSWORD`
- Table prefix: `ost_`

Create a unique lab administrator account. Do not reuse a personal or work password.

After setup succeeds, open the Railway web service shell and run:

    rm -rf /var/www/html/setup
    chmod 0444 /var/www/html/include/ost-config.php

The config path is a symlink to the persistent volume. At the next container start, the entrypoint removes the setup directory and makes the config read-only again.

## 5. Check the deployment

- Confirm the app domain uses HTTPS.
- Sign in with the lab admin and submit a fictional ticket.
- Restart or redeploy the web service and confirm the app still loads.
- Verify the database is private and the web volume is attached at `/var/lib/osticket-config`.
- Keep a record of the demo URL, but do not publish admin credentials.

## 6. Tear down

Delete the Railway project and its attached storage when the lab is no longer needed. This removes its database, configuration, and uploaded data. Check the provider dashboard for any remaining resources.

## Notes

- Email delivery is not configured. Use the web portal for exercises.
- osTicket is fetched from its official source tag during the Docker build. Review upstream release notes before changing `OSTICKET_REF`.
- A public demo can attract unsolicited tickets. Use fictional data, monitor the instance, and remove the deployment after the exercise.

