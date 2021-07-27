# 💎 Crawler Bot App

[![Ruby](https://github.com/nhthach/crawler_bot/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/nhthach/crawler_bot/actions/workflows/ruby.yml)

App: https://crawler-bot.herokuapp.com/

This is sample project that crawling the latest best news and show them.

### Version
- Current ruby version 3.0.0
- Bundler version 2.2.3
- Rails version 6.1.X
- Mysql


### Dependencies
Some main gems such as:

- puma
- bootsnap
- dotenv
- nokogiri
- ruby-readability
- httparty
- redis-rails
- fastimage
- ....

 ### 🚀 Quick start

--------------------------
1. Clone this repo:

    ```ruby
    git clone https://github.com/nhthach/crawler_bot.git crawler_bot
    cd crawler_bot
    ```

2. Clone .env_example to .env for local development. We set it up with default rails 3000 and client 8000 ports:

    ```
    cp .env_example .env
    ```

3. Install the dependencies:

    ```ruby
    bundle install
    yarn install
    ```
4. Run DB

    Make sure the Mysql is running on localhost.
    
    ```ruby
    rake db:create
    rake db:migrate
    ```
5. Run redis server

    a. Install `redis` server:
    ```
    brew install redis
    ```
    b.  Run `redis` server:

    ```
    redis-server
    ```

6. Run the development server:

    ```ruby
    rails s
    ```

### 🎁 How to work
1. You can run rake task by manual: ` rails scheduler:crawling`
2. Access `http://localhost:3000/`. Let's enjoy the result :)