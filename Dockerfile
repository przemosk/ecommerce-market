FROM ruby:3.2.0

RUN mkdir /myapp
WORKDIR /myapp

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
    bundle install --jobs 4

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]