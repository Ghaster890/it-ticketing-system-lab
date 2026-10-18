# IT Ticketing System & Lab

A GitHub-ready osTicket lab for practicing IT support triage and user access request handling. It builds the open-source osTicket application from its official source, runs it with MariaDB, and includes exercises for realistic help-desk workflows.

- **GitHub repository:** https://github.com/Ghaster890/it-ticketing-system-lab
- **Live website:** [https://osticket-web-production.up.railway.app](https://osticket-web-production.up.railway.app). The hosted site currently opens osTicket's one-time installer; follow [the Railway setup guide](docs/DEPLOY-RAILWAY.md) before using the ticket system.

## What you will practice

- Collecting ticket details and categorizing incidents.
- Setting priority from impact and urgency.
- Assigning ownership, communicating updates, and documenting resolution.
- Handling an access request with identity checks, business justification, manager or data-owner approval, least privilege, and an expiry date.
- Keeping an auditable record through internal notes and ticket status changes.

The access workflow is a practice checklist. osTicket does not automatically grant or approve access in this lab.

## Architecture

- osTicket 1.18.4, built from the official osTicket GitHub source.
- PHP 8.3 with Apache.
- MariaDB 10.11.
- Docker Compose for repeatable local setup.
- Local publishing is bound to 127.0.0.1 by default. The database has no published host port.
- Railway deployment instructions are in docs/DEPLOY-RAILWAY.md.

Use fictional identities and sample information only. Never enter real passwords, personal information, production tickets, or confidential access details.

## Run locally

Requirements: Docker Desktop with Linux containers and Docker Compose, plus PowerShell on Windows.

1. Open PowerShell in the repository folder.
2. Generate local database credentials:

       .\scripts\initialize-lab.ps1

   The script writes a local .env file, which Git ignores.
3. Build and start the services:

       docker compose up --build -d
4. Open http://localhost:8080/setup/ and follow the osTicket installer.

In the installer, use these database settings:

- Host: db
- Database: osticket
- Username and password: open the local .env file and use DB_USER and DB_PASSWORD
- Table prefix: ost_

Create a unique lab admin account. Do not reuse a personal or work password.

After the installer reports success, remove the setup page and make the generated configuration read-only:

       docker compose exec web sh -lc "rm -rf /var/www/html/setup && chmod 0444 /var/www/html/include/ost-config.php"

Then sign in at http://localhost:8080/ and complete the exercises in docs/LAB-EXERCISES.md.

## Ticketing exercises

Start with docs/LAB-EXERCISES.md. It contains sample incident tickets and an access request scenario, along with a completion checklist. Use fictional names, devices, and systems throughout.

Suggested ticket lifecycle:

1. Record the requester's name, contact method, affected service, impact, urgency, and a concise description.
2. Categorize and prioritize the ticket. Include the reason for the priority.
3. Assign an owner and add a public update when more information is needed.
4. For access requests, document the requester, target user, system, role, business need, approver, approval evidence, and end date. Keep the request pending until approvals are documented.
5. Add a resolution note, notify the requester, and close the ticket after confirming the outcome.

## Deploy online with Railway

The repository includes a Railway deployment walkthrough at docs/DEPLOY-RAILWAY.md. It uses a Railway web service, a MySQL-compatible database service, and persistent volumes for the osTicket configuration and attachments.

A Railway account and GitHub connection are required. Hosting may incur charges according to your selected plan. Configure access and data retention for a training environment, and never use real support requests.

## Stop and remove local data

Stop the containers and keep tickets and configuration:

       docker compose down

Remove containers and permanently delete the local database, attachments, and osTicket configuration volumes:

       docker compose down --volumes

The second command deletes the lab's saved state. Back up anything you need before running it.

## GitHub checklist

- Commit the Dockerfile, Compose file, scripts, docs, and this README.
- Keep .env untracked; never commit generated credentials.
- Add screenshots of fictional test tickets only after reviewing them for secrets and personal data.
- If you create another deployment, replace the live website URL above with that deployment's address.

## Resume wording

After completing the lab, you can describe it accurately as:

> Deployed an osTicket help-desk lab with Docker Compose and MariaDB; practiced incident triage, ticket prioritization, user communication, and documented least-privilege access request approvals.

If you deploy it online, add the hosting platform and public demo URL. Do not imply that access was provisioned in a real environment.

## Upstream references

- [osTicket official source repository and requirements](https://github.com/osTicket/osTicket)
- [osTicket installation guide](https://docs.osticket.com/en/latest/Getting%20Started/Installation.html)
- [Railway Docker Compose deployment guide](https://docs.railway.com/guides/docker-compose)

