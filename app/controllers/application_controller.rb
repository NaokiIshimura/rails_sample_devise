class ApplicationController < ActionController::Base
  # ログインしていないときにログイン画面にリダイレクトをかける
  # 「user」はモデル名に応じて変更する
  before_action :authenticate_user!, if: :use_before_action?

  protect_from_forgery with: :exception

  # ログインしていないときにログイン画面にリダイレクトをかける
  def use_before_action?
    true
  end

end
