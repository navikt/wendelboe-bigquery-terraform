# wendelboe-bigquery-terraform

Terraform-scipts for å opprette BigQuery-ressurser for Team Wendelboe i Seksjon Pensjon og Uføre.

## Hvordan kjøre Terraform lokalt

Dersom terraform allerede er satt opp og initiert for repo slik at bygg på GA fungerer, og du kun ønsker å inspisere hva terraform finner og rapporterer av endringer:

Følg oppskriften under fra og med pkt. 4 (Installer Terraform lokalt) til pkt. 6 (Kjør kode lokalt).

## Hvordan sette opp repo med Terraform første gang

Opprettelse av bucket og bruk av denne for terraform state må gjøres i to separate steg. Dette må gjøres lokalt fordi uten terraform state i bucketen så vil ikke GitHub Actions ha mulighet til å ta vare på state mellom kjøringer. Hvis vi prøver å gjøre dette via GitHub Actions vil bruk av bucket for terraform state feile da den i tillegg vil forsøke å opprette bucketen på nytt, fordi staten ikke har spor av opprettelsen av bucketen.

1. Opprett service account i GCP med permissions:

   - BigQuery Data Owner
   - Editor
   - Secret Manager Secret Accessor

   I dette repoet er det opprettet en bruker med navn `terraform` i `tbd-dev` og `tbd-prod` med disse tilgangene.

2. Opprett key for service account for hhv [dev](https://console.cloud.google.com/iam-admin/serviceaccounts?project=tbd-dev-7ff9) og [prod](https://console.cloud.google.com/iam-admin/serviceaccounts?project=tbd-prod-eacd)

   - Velg "Manage keys" fra actions for terraform-kontoen
   - Velg "Add keys" -> "Create new key" -> "Key type=JSON" -> "Create"
   - Key lagres til fil lokalt
   - Flytt filene til hjemmeområde og endre rettigheter slik: chmod go-rwx ~/tbd-terraform-\*.key

3. Legg inn filen med service account keyen i [GitHub secret](https://github.com/navikt/bomlo-bigquery-terraform/settings/secrets/actions) (våre secrets heter GCP_SECRET_DEV og GCP_SECRET_PROD)

4. Installer Terraform lokalt

   F.eks med brew: `brew install terraform`

5. Velg miljø og logg inn

   - Gå til mappe du skal kjøre terraform fra (prod eller dev): `cd dev`
   - Sett context (dev-gcp/prod-gcp): `kubectl config use-context dev-gcp`
   - Kjør kommando: `gcloud auth application-default login`

6. Kjør kode lokalt for å opprette bucket (men ikke prøv å bruke den enda). Se kode i [commit](https://github.com/navikt/bomlo-bigquery-terraform/commit/3a6b7edb78a29052cd1e1dfae54c5ac3404768f8)
   ```
   terraform init
   terraform plan -refresh-only -detailed-exitcode
   ```
7. Gjør eventuelle endringer i terraform-filer, og for å se resultatet av dem kjør følgende kommando:
   ```
   terraform plan -detailed-exitcode
   ```
   (forskjellen på `terraform plan -refresh-only` og `terraform plan` kan du lese om [her](https://medium.com/code-oil/understanding-terraform-plan-apply-refresh-only-the-myths-and-fixing-drift-5963207a1df8))
8. Når du er fornøyd med endringene terraform rapporterer om i punktet over, kjør følgende kommando:
   ```
   terraform apply
   ```
9. Kjør kode lokalt for å bruke bucket for state. Se kode i [commit](https://github.com/navikt/bomlo-bigquery-terraform/commit/42b61393184652e12f2efaf9bb974e7c7cfbeefb)
   ```
   terraform init
   ```
10. Endre context til miljø det ikke er kjørt for å gjenta nødvendige steg over.
11. Nå kan workflowen pushes


## Henvendelser

Spørsmål knyttet til koden eller prosjektet kan stilles som issues her på GitHub.

Interne henvendelser kan sendes via Slack i kanalen [#team-wendelboe](https://nav-it.slack.com/archives/C095TK7F27J).
