# Online Deployment: Railway

This guide publishes the lab through Railway using an osTicket web service, a MySQL database service, and persistent storage. Railway deploys the services separately; it does not run this repository's Compose file as one production stack. See Railway's [Docker Compose deployment guide](https://docs.railway.com/guides/docker-compose).

A Railway account and linked GitHub repository are needed. Check current plan costs before deploying. Use fictional training data only.

## 1. Push the repository to GitHub

Create a repository and push the project files. Confirm that .env is not tracked. Do not publish credentials, real tickets, or screenshots containing personal data.

## 2. Create the database service

In a Railway project, add a MySQL database service. Railway provides these variables in the database service settings:

- MYSQLHOST
- MYSQLPORT
- MYSQLDATABASE
- MYSQLUSER
- MYSQLPASSWORD

The database is private to the project by default. Keep it private; osTicket connects through the private network.

## 3. Create the osTicket web service

Add a service from the GitHub repository. Railway should build the root Dockerfile. In service networking settings, generate a public domain and set its target port to 80.

Attach Railway volumes to the web service with these exact mount paths:

- /var/lib/osticket-config
- /var/www/html/attachments

The container entrypoint creates a persistent configuration file in the first volume. The app code stays in the image. The second volume stores uploaded ticket attachments.

## 4. Install osTicket

Open the generated HTTPS domain followed by /setup/ and run the installer. Use the values from the Railway MySQL service:

- Database host: MYSQLHOST
- Database port: MYSQLPORT
- Database name: MYSQLDATABASE
- Database user: MYSQLUSER
- Database password: MYSQLPASSWORD
- Table prefix: ost_

Create a unique lab administrator account.

After setup succeeds, open the Railway service shell and run:

    rm -rf /var/www/html/setup
    chmod 0444 /var/www/html/include/ost-config.php

The config path is a symlink to the persistent configuration volume. At the next container start, the entrypoint removes the setup directory and makes the config read-only again.

## 5. Check the deployment

- Confirm the app domain uses HTTPS.
- Sign in with the lab admin and submit a fictional ticket.
- Restart or redeploy the web service and confirm the app still loads.
- Verify the database is private and both web volumes are attached.
- Keep a record of the demo URL, but do not publish admin credentials.

## 6. Tear down

Delete the Railway project and its attached storage when the lab is no longer needed. This removes its database and uploaded data. Check the provider dashboard for any remaining resources.

## Notes

- Email delivery is not configured. Use the web portal for exercises.
- osTicket is fetched from its official source tag during the Docker build. Review upstream release notes before changing OSTICKET_REF.
- A public demo can attract unsolicited tickets. Use fictional data, monitor the instance, and remove the deployment after the exercise.
