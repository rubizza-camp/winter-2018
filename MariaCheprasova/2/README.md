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