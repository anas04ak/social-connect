# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.0.0
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test"

# -------------------------------
# Build Stage
# -------------------------------
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential \
  git \
  libsqlite3-dev \
  libvips \
  pkg-config \
  curl \
  gnupg2 \
  nodejs \
  yarn \
  chromium \
  chromium-driver \
  libgtk-3-0 \
  libnss3 \
  libxss1 \
  libasound2 \
  redis-tools \
  && rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy rest of the app
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# -------------------------------
# Final Stage
# -------------------------------
FROM base

# Install runtime packages only
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  libsqlite3-0 \
  libvips \
  nodejs \
  yarn \
  chromium \
  chromium-driver \
  libgtk-3-0 \
  libnss3 \
  libxss1 \
  libasound2 \
  redis-tools \
  && rm -rf /var/lib/apt/lists/*

# Copy app and dependencies from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Copy start script
COPY start.sh /rails/start.sh
RUN chmod +x /rails/start.sh

# Create and switch to non-root user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails:rails

WORKDIR /rails

EXPOSE 3000

# Use start.sh as entrypoint
ENTRYPOINT ["/rails/start.sh"]
