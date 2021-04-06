FROM elixir:1.11.4

RUN apt-get update -y \
			&& curl -sl https://deb.nodesource.com/setup_10.x | bash - \
			&& apt-get install -y -q --no-install-recommends nodejs \
			&& mix local.rebar --force \
			&& mix local.hex --force

COPY . .
RUN mix do deps.get, compile
RUN cd ./assets \
		  && npm install \
		  && ./node_modules/webpack/bin/webpack.js --mode production \
		  && cd .. \
		  && mix phx.digest

 WORKDIR /stone_bank

EXPOSE 4000