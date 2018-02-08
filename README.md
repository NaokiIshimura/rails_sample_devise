# README

## 環境変数

```
# 通知用メール
$ export GMAIL_MAIL_ADDRESS=xxxxx
$ echo $GMAIL_MAIL_ADDRESS

$ export GMAIL_MAIL_PASSWORD=xxxxx
$ echo $GMAIL_MAIL_PASSWORD
```

## 使い方
1. マイグレーション
```
$ rake db:migrate
```
2. メール設定
```
# config/environments/development.rb
  :user_name => 'メールアドレス',
  :password => 'パスワード'
```

## 参考
http://www.sejuku.net/blog/13378#rake_dbmigrate
http://qiita.com/Salinger/items/873e3c667462746ae707

## 準備
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

### 参考サイト
https://github.com/plataformatec/devise/wiki/I18n
https://github.com/tigrish/devise-i18n
https://gist.github.com/kaorumori/7276cec9c2d15940a3d93c6fcfab19f3

### エラーメッセージ日本語化
http://gaku3601.hatenablog.com/entry/2014/10/04/185947

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
### ログイン・サインアップ画面へのリンク追加
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

### ログイン時のみ内容を確認できるように設定
```
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # ログインしていないときにログイン画面にリダイレクトをかける
  before_action :authenticate_user! # 「user」はモデル名に応じて変更する
  protect_from_forgery with: :exception
end
```

### ログアウトボタン
```
# app/views/layouts/application.html.erb
<% if user_signed_in? %>
  <p><%= link_to "ログアウト", destroy_user_session_path, method: :delete %></p>
<% end %>
```

### パスワード再設定メール
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

### 新規登録を禁止する
http://qiita.com/iguchi1124/items/bb25cf650348f31ea37e
```
# app/models/user.rb
:registerable # <= 削除する
```

### ログイン・ログアウト時のリダイレクト先を指定する
http://morizyun.github.io/blog/devise-customize-login-register-path/
```
# app/controllers/application_controller.rb
def after_sign_in_path_for(resource)
  admin_root_path
end
def after_sign_out_path_for(resource)
  admin_root_path
end
```

## Lockable

https://qiita.com/inodev/items/eeb26ea9408d4627bf0a

```
# db/migrate/xxx.rb

## Lockable
t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
t.string   :unlock_token # Only if unlock strategy is :email or :both
t.datetime :locked_at
```

```
# app/model/user.rb

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable
end
```

```
# config/initializers/devise.rb
config.lock_strategy = :failed_attempts # 一定回数ログインミスでロック
config.unlock_strategy = :time          # ロック解除条件は時間経過のみ
config.maximum_attempts = 10            # 10回連続ミスでロック
config.unlock_in = 1.hour               # 1時間ロック継続
config.last_attempt_warning = false    # あと1回ミスしてロックされる時に警告を出さない
```

Unable to unlock user with link from unlock e-mail
https://github.com/plataformatec/devise/issues/3559

```
# app/views/devise/mailer/unlock_instructions.html.erb

- link_to 'Unlock my account', unlock_url(@resource, :unlock_token => @resource.unlock_token)
+ link_to 'Unlock my account', unlock_url(@resource, :unlock_token => @token)
```
