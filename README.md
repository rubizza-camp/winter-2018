# Rubizza Survival Camp: Winter 2018

![](https://s3.eu-central-1.amazonaws.com/rubizza/rubizza-logo.png)


# [How to submit homework](#how-to-submit)

To submit your homework you need to do following:

* Everyone need to [fork](http://lmgtfy.com/?q=%D1%84%D0%BE%D1%80%D0%BA%D0%BD%D1%83%D1%82%D1%8C) this repo with his personal github account.
* Everyone should create separate folder with his name and surname and upload it to this repo ( for example __Valentine Zavadskiy__ ).
* Every task should be executed on separate [branch](http://lmgtfy.com/?q=github+fork) and you need to create a folder inside your pesonal folder, representing number of homework ( for example for homework #0 - __Valentine Zavadskiy/0/__ )
* After you finished your homework - you need to send a [pull request](http://lmgtfy.com/?q=pull+request) ( PR here and futher ) to master-branch of this repository. Name format of this PR should be __#{first_name} #{last_name}__ - __#{homework number}__ ( for example __Valentine Zavadskiy - 0__ ). Please make sure you filled all fields on template.
* After submitting PR it will be automatically checked against code styles. Please make sure you fixed all warnings. We are not accepting homeworks with style violations.
* After all warnings are fixed - we will assign mentor to your homework, so he can manually look throught your code and leave his comments.
* After you discussed your work with mentor and he decided that it is OK - your pull request will be merged to main repository. Only at this moment your work will be considered as accepted.


# Homework 0

If you looking into Belarussian IT industry - you might hear about [Viktor Prokopenya](https://en.wikipedia.org/wiki/Viktor_Prokopenya), who is a famous enterpreneur here. Recently he gave [interview](https://www.youtube.com/watch?v=9efHso_5FOc) on youtube. During this interview one of keypoints which was discovered - he does not know how much bread costs these days. Our goal for todays homework will be help such people to learn about pricing for different basic items.

### Requirements

* Data for this homework should be downloaded from this [webpage](http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/)
* You should NOT include this date to your pull request, just place everything to `data` folder and ignore it.

## Level 1

On this level you should create a basic program, where you can enter a name ( in Russian ) and it will give you an answer if item is found.

Examples:

```
ruby run.rb
What price are you looking for?
> Хлеб
'Хлеб' is 1.14 BYN in Minsk these days.
> Профитроли
'Профитроли' can not be found in database.
```
## Level 2

On this level you should add more power to your program and make it look for minimal and maximum pricing over the time.

Examples

```
ruby run.rb
What price are you looking for?
> Хлеб
'Хлеб' is 1.14 BYN in Minsk these days
Lowest was on 2017/01 at price 0.72 1.73BYN
Maximum was on 2012/04 at 1.73BYN
```
## Level 3

With this level you also should tell user what else he can get for similar price.

Examples

```
ruby run.rb
What price are you looking for?
> Хлеб
'Хлеб' is 1.14 BYN in Minsk these days.
Lowest was on 2017/01 at price 0.72 1.73BYN
Maximum was on 2012/04 at 1.73BYN
For similar price you also can afford 'Йогурт' and 'Кефир'.
```

### Deadline

2018-12-09 23:59:59 UTC+3

# Homework 1

If you are familiar with battle-rap, you probable heard about word plays. If you never heard about that, you can go and check this [link](https://www.thoughtco.com/word-play-definition-1692504) to get some understanding. On this homeword we will try to write a telegram-bot, who could help different people generate some wordplays.

### Goal

On this homework we will practise how to:

* Write data scrapers from website
* Create telegram bots
* Structure your code with multiple classes
* Use third party gems
* Store persisted data on database

### Requirements

* Data for wordplays should be parsed with custom script and saved to database. Those scripts should be included to your submission
* For database storage you should use `redis` database and use 'redis' gem for this.
* For telegram bot you should use `telegram-bot-ruby` gem.
* Your code should be well-scructured with multiple classes
* You can choose any language you love ( Russian, English, whatever ) to get a data for this.

### Hints

* It's up to you how you will define wordplays or get data for them. In the very end it should be just funny. One of the best ways of detecting and generating them is to do some simple sound analysis about different words in a vocabulary. Or you can lookup some website with wordplays and parse it.

### Level 1

For this homeword we are going to have only one level will have only one command, which will simply take one wordplay or phrase from database and print it on your telegram.

Here is an example:

```
> Hey bot!
> Hey bro!
> /wordplay
> Here is your random wordplay:
> She got a big __booty__, so I call her big __booty__
```

### Deadline

2018-01-31 23:59:59 UTC+3

# Homework 2

So new homework is about keeping you in fit, so just track what you eat and you'll live forever.
Or a fairy tale about one more foodtracker.

### Goal

On this homework we will practise how to:

* Create simple rails application
* Use generators
* Use associations
* Use third party gems
* Store persisted data on database

### Requirements

* There are three entities: a user, a dish and an ingestion.
* Each entity has set of fields.
  - User: first_name, last_name, age, weight and height
  - Dish: name, weight, calorie_value, proteins, carbohydrates and fats
  - Ingestion is who ate and what was eaten
* For database storage you should use `postgresql` database and use 'pg' gem for this.
* Your code should be well-scructured with multiple classes
* Nobody should die of eyes bleeding. Use CSS power!
### Hints

* Check previous lectures for help.

### Level 1

The easiest thing you can do is implement functionality for user who can perform following operations: sign up/log in/log out and profile editing.
If you think that it's enough - you are wrong. You need to add all entities and needed operations for foodtracker.

### Level 2

It's not funny to look at number of rows in tables, so please show stats in charts

### Level 3

Rails world has number of cool gems for managing DB, please use any of them to manage your new shiny app.
### Deadline

2019-02-29 23:59:59 UTC+3
