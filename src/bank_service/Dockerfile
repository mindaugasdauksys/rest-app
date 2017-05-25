FROM ruby:2.4.1

# Update machine
RUN apt-get update -qq 
RUN apt-get install -y build-essential libpq-dev
RUN apt-get install -y nodejs

# Copy src files
COPY src/ .

# Install gems
RUN bundle install

# Start server
CMD ["bin/rails", "server", "-p8000", "-b0.0.0.0"]
