FROM ruby:2.6.4

ENV RAILS_ON_DOCKER=yes

# Install nodejs 11
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
  apt-get install -y nodejs
RUN apt-get install -y parallel
RUN echo "will cite\n" | parallel --citation &>/dev/null # Tell parallel that we will,
                                                         # in fact, cite it if we use
                                                         # it in an academic publication

# Install yarn
RUN npm install --global yarn

# cd into /app
ENV APP_PATH=/app

# Install gems
RUN mkdir -p $APP_PATH
COPY Gemfile ${APP_PATH}/Gemfile
COPY Gemfile.lock ${APP_PATH}/Gemfile.lock
WORKDIR ${APP_PATH}
RUN bundle install

COPY package.json ${APP_PATH}/package.json
COPY yarn.lock ${APP_PATH}/yarn.lock
RUN yarn install --check-files

# Copy application files
COPY . ${APP_PATH}

# Attempt to build elm packages to pull in dependencies
RUN bash -c "yarn run elm make /app/javascript/Main.elm --output=/dev/null 2>/dev/null || true"

COPY bin/entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
