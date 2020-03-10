# ./Dockerfile

# Extend from the official Elixir image
FROM elixir:latest

# install hex package manager
RUN mix local.hex --force

# install node
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

# create app folder
RUN mkdir /app
COPY . /app
WORKDIR /app

# setting the port and the environment (prod = PRODUCTION!)
ENV MIX_ENV=prod
ENV PORT=4000

ENV SECRET_KEY_BASE=Jmt80Y25wpWFi/2UlXVXXlupO9eYZePtg++5MgmRV1BfoUUDlFaci6Ak69h63Psi

# install dependencies (production only)
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile

# install node dependencies
RUN npm install
# build only the things for production
RUN node node_modules/brunch/bin/brunch build --production

# create the digests
RUN mix phoenix.digest

# run phoenix in production on PORT 4000
CMD mix phoenix.server