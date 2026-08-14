FROM ruby:3.4.4-slim AS base
WORKDIR /rails
ENV RAILS_ENV=production BUNDLE_DEPLOYMENT=1 BUNDLE_WITHOUT="development:test"

FROM base AS build
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libsqlite3-dev git && rm -rf /var/lib/apt/lists/*
COPY Gemfile ./
RUN bundle install
COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

FROM base
RUN apt-get update -qq && apt-get install --no-install-recommends -y sqlite3 curl && rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails
RUN useradd rails --create-home --shell /bin/bash && chown -R rails:rails log storage tmp
USER rails
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
