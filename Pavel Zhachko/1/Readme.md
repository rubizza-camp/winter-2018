# Homework 1

### Before start

Token for your own task you can get from @BotFather -> /token -> /newbot -> choose a name for your bot. -> profit!


## Usage

* local usage
0. export TOKEN='your token'
1. bundle install
2. run redis-server
3. ruby run.rb
4. open Telegram and find your own bot.
* /start for beginning. Bot greet you with slang of "What's up?"
* /wordplay for getting random wordplay from db
* Cuz bot is dumb he dosen't know other commands. So if you try type smth else - he'll be confused.


* heroku usage

1. git init & git add . & git commit -m 'heroku init'
2. heroku create
3. heroku config:set TOKEN='your token'
4. git push heroku master
5. don't forget add redis addon to your heroku app
6. profit


Examples

```
Go to @pzh_wordplay_bot and ask smth.
