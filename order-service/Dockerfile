FROM ruby:3.3.1

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential libpq-dev nodejs curl git bash && \
    rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH=/usr/local/bundle BUNDLE_JOBS=4 BUNDLE_RETRY=3
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
EXPOSE 3000
CMD ["bash", "-lc", "bin/rails db:prepare && bin/rails s -b 0.0.0.0 -p 3000"]
