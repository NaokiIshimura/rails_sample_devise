class ApplicationController < ActionController::Base
  # ログインしていないときにログイン画面にリダイレクトをかける
  # 「user」はモデル名に応じて変更する
  before_action :authenticate_user!, if: :use_before_action?

  protect_from_forgery with: :exception

  # ログインしていないときにログイン画面にリダイレクトをかける
  def use_before_action?
    true
  end

  # ログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
    member_pages_page1_path
  end

  # ログアウト後のリダイレクト先を指定
  def after_sign_out_path_for(resource)
    root_path
  end

end
