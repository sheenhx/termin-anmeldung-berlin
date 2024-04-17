# anmeldung-berlin

This app will find and book any [service.berlin.de](https://service.berlin.de) appointment that can be booked online.

## Quickstart

### 1. Get a MailSlurp API Key

Get a [MailSlurp API key here](https://app.mailslurp.com/sign-up/).

### 2a. Run with Docker (recommended)

Build & run Docker container.

```bash
# Update stealth evasions
npx extract-stealth-evasions

#install all dependencies
sudo apt-get update
sudo apt-get install ca-certificates fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils

# Build
docker build -t anmeldung-berlin .
# Book an "Anmeldung einer Wohnung" appointment
docker run \
    -v $(pwd)/playwright-report:/home/pwuser/playwright-report \
    -v $(pwd)/test-results:/home/pwuser/test-results \
    -e MAILSLURP_API_KEY=*your-api-key* \
    -e FORM_NAME=*your-first-name* \
    -e FORM_PHONE=*your-phone-number* \
    anmeldung-berlin
# Book an "Blaue Karte EU auf einen neuen Pass übertragen" appointment on/after 01 Feb 2024 & before/on 28 Feb 2024 at any time.
docker run \
    -v $(pwd)/playwright-report:/home/pwuser/playwright-report \
    -v $(pwd)/test-results:/home/pwuser/test-results \
    -e MAILSLURP_API_KEY=*your-api-key* \
    -e FORM_NAME=*your-name* \
    -e FORM_PHONE=*your-phone-number* \
    -e APPOINTMENT_SERVICE="Blaue Karte EU auf einen neuen Pass übertragen" \
    -e APPOINTMENT_EARLIEST_DATE="2024-02-01 GMT" \
    -e APPOINTMENT_LATEST_DATE="2024-02-28 GMT" \
    anmeldung-berlin
```


## Deployment

Set [playwright.config.js](/playwright.config.js) `retries` to a high number, if you want to run the app locally until a successful booking is made. You will definitely be blocked for exceeding a rate limit. In this case, try setting `PROXY_URL` to a back-connect proxy URL. try my [referal code](https://www.webshare.io/?referral_code=5ejqko5w971n)

## Parameters

The app is parameterized via environment variables at runtime, which have default values (sometimes `null`) defined in the [Playwright test](./tests/appointment.test.js)

For [making an appointment](/tests/appointment.test.js), the parameters are:

Environment Variable | Parameter Default | Description
---------|----------|---------
 `MAILSLURP_API_KEY` | `null` | API key for MailSlurp service. [Required]
 `MAILSLURP_INBOX_ID` | `null` | Inbox ID for MailSlurp service. Use to avoid creating many MailSlurp inboxes.
 `FORM_NAME` | `null` | Your name. [Required]
 `FORM_PHONE` | `null` | Your phone number. [Required]
 `FORM_NOTE` | `null` | Your note for the Amt on your booking.
 `FORM_TAKE_SURVEY` | `"false"` | If you want to take the Amt's survey.
 `APPOINTMENT_SERVICE` | `"Anmeldung einer Wohnung"` | Name of the appointment type.
 `APPOINTMENT_LOCATIONS` | `null` | Comma separated location names for appointment.
 `APPOINTMENT_EARLIEST_DATE` | `"1970-01-01 GMT"` | Earliest date for appointment.
 `APPOINTMENT_LATEST_DATE` | `"2069-12-31 GMT"` | Latest date for appointment.
 `APPOINTMENT_EARLIEST_TIME` | `"00:00 GMT"` | Earliest time for appointment.
 `APPOINTMENT_LATEST_TIME` | `"23:59 GMT"` | Latest time for appointment.

## Environment Variables

Variable | Default | Description
---------|----------|---------
`LOGLEVEL` | "info" | Set to "debug" to get stdout.
`CONCURRENCY` | "16" | Max number of concurrent Pages.
`PROXY_URL` | `http://p.webshare.io:9999` | You will be surely blocked, so need to [use a proxy](https://www.webshare.io/?referral_code=5ejqko5w971n).

## Debugging

```bash
MAILSLURP_API_KEY=*your-api-key* FORM_NAME=*your-name* FORM_PHONE=*your-phone-number* \
    npm run debug
```

## Output

[playwright-report](./playwright-report) will contain one or two .html files that are the body of the emails received during the booking process. There will also be an .ics file to add to your calendar. Check your MailSlurp email inbox for the appointment confirmations.

```bash
npx playwright show-report
```

## Known Issues

- We can be blocked by a Captcha in some cases.

## Contributing

If you're planning to contribute to the project, install dev dependencies and use `eslint` and `prettier` for linting and formatting, respectively.

```bash
npm i --include=dev
npx eslint --fix tests/ src/ playwright.config.js
npx prettier -w tests/ src/ playwright.config.js
```
