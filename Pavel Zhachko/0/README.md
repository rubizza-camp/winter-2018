# Homework 0

### Before start

* Data for this homework should be downloaded from this [webpage](http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/) and placed into `data` folder.

## Usage

1. bundle install
2. ruby parser.rb
3. Enter name of item what you want to find.

Examples

```
#1
ruby parcer.rb
What price are you looking for?
Соль
'Соль' is 0.55 BYN in these days.
Lowest was on 2009/01 at price 0.05 BYN
Maximum was on 2018/09 at price 0.56 BYN
There is no items with similar price.

#2
What price are you looking for?
Хлеб
'Хлеб' is 1.61 BYN in these days.
Lowest was on 2018/10 at price 1.52 BYN
Maximum was on 2018/03 at price 1.7 BYN
There is no items with similar price.
'Хлеб' is 2.74 BYN in these days.
Lowest was on 2009/07 at price 0.24 BYN
Maximum was on 2018/11 at price 2.74 BYN
There is no items with similar price.
'Хлеб' is 1.52 BYN in these days.
Lowest was on 2009/01 at price 0.17 BYN
Maximum was on 2016/04 at price 1.71 BYN
For similar price you also can afford 'сигареты с фильтром отечественные', 'уксус' and 'топливо дизельное'.

#3
What price are you looking for?
Абсент
'Абсент' can not be found in database.
```
