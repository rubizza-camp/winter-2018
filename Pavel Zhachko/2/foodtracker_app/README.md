# Foodtracker app

Simple foodtracker app build by ruby on rails.

## Getting Started

1. ruby-2.5.3
2. rails 5+



### Installing
After you clone the app.

```
db:create db:migrate
```
Then run `bundle install`.

Visit **`http://localhost:3000`**

You can register new user by clicking on Register link.

To get admin permition to registered user:
Change `config.verify_access_proc = proc { |controller| controller.current_user.admin? }`in
 **`config/initializers/rails_db.rb`** to `config.verify_access_proc = proc { |controller| true }`

Then edit user and save. After that change config to permition only for admin.


## Authors

* **Pavel Zhachko** - *Initial work* - [SadTigger](https://github.com/SadTigger)
