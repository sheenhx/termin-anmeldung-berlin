FROM mcr.microsoft.com/playwright:v1.43.1-jammy

WORKDIR /home/pwuser/

COPY package.json .

RUN npm i

COPY . .

ENV NODE_ENV=production

ENTRYPOINT [ "npm" ]

CMD [ "start" ]
