# README

## 使い方
1. マイグレーション
```
$ rake db:migrate
```
2. メール設定
```
# config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :authentication => :plain,
  :user_name => 'メールアドレス',
  :password => 'パスワード'
}
```

## 参考
http://www.sejuku.net/blog/13378#rake_dbmigrate
http://qiita.com/Salinger/items/873e3c667462746ae707

### 準備
1. gemインストール
```
# Gemfile
gem 'devise'
```
```
$ bundle install
```
2. deviseインストール
```
$ rails g devise:install
```

3. deviseの導入：environmentsファイルにオプションを追加
```
# config/environments/development.rb:

  config.action_mailer.default_url_options = { host: 'localhost', port: 300
0 }
```

4. deviseの導入：routingの設定
```
$ rails g controller home index
```
```
# config/routes.rb
root "home#index"
```

5. deviseの導入：viewの設定
```
# app/views/layouts/application.html.erb
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```

6. モデルの作成
```
$ rails g devise User
$ rake db:migrate
```

## インストール時のログ

```
Running via Spring preloader in process 17410
      create  config/initializers/devise.rb
      create  config/locales/devise.en.yml
===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Her
e
     is an example of default_url_options appropriate for a development environm
ent

     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 300
0 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================
```


## 日本語化
https://github.com/plataformatec/devise/wiki/I18n
https://github.com/tigrish/devise-i18n
https://gist.github.com/kaorumori/7276cec9c2d15940a3d93c6fcfab19f3

1. devise-i18nのインストール
```
# Gemfile
gem 'devise-i18n'
```
```
$ rails g devise:i18n:views
$ ails g devise:i18n:locale ja
```

2. localeの設定
http://docs.komagata.org/5355
```
# config/initializers/i18n.rb
Rails.application.config.i18n.default_locale = :ja
```

## 活用
1. ログイン・サインアップ画面へのリンク追加
```
# views/home/index.html.erb
<% if user_signed_in? %>
  Logged in as <strong><%= current_user.email %></strong>.
  <%= link_to "Settings", edit_user_registration_path, :class => "navbar-link" %> |
  <%= link_to "Logout", destroy_user_session_path, method: :delete, :class => "navbar-link" %>
<% else %>
  <%= link_to "Sign up", new_user_registration_path, :class => 'navbar-link' %> |
  <%= link_to "Login", new_user_session_path, :class => 'navbar-link' %>
<% end %>
```

2. ログイン時のみ内容を確認できるように設定
```
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # ログインしていないときにログイン画面にリダイレクトをかける
  before_action :authenticate_user! # 「user」はモデル名に応じて変更する
  protect_from_forgery with: :exception
end
```

3. ログアウトボタン
```
# app/views/layouts/application.html.erb
<% if user_signed_in? %>
  <p><%= link_to "ログアウト", destroy_user_session_path, method: :delete %></p>
<% end %>
```

4. パスワード再設定メール
事前にgoogleでアプリ用パスワードを払い出しておく
```
# config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :authentication => :plain,
  :user_name => 'メールアドレス',
  :password => 'パスワード'
}
```

5. 新規登録を禁止する
http://qiita.com/iguchi1124/items/bb25cf650348f31ea37e
```
# app/models/user.rb
:registerable # <= 削除する
```
