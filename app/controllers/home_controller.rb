class HomeController < ApplicationController

  # ログインしていないときにログイン画面にリダイレクトをかけない
  def use_before_action?
    false
  end

  def index
    # ユーザーがサインインしているかどうかの判定
    # 戻り値が true ならサインイン済み。
    p user_signed_in?
    # サインインしている全ユーザー取得
    p current_user
    # ユーザーのセッション情報
    p user_session
  end
  
  def show
  end
end
