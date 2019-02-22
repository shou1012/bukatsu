Community.create([{name:"デザイナー部"},{name:"イラスト部"},{name:"アプリ部"},{name:"ゲーム部"},{name:"うぇ部"},{name:"映像部"},{name:"カメラ部"},{name:"音楽部"},{name:"新聞部"},{name:"マネージャー"}])

30.times do |n|
  User.create(name: "User #{n}",email: "user-#{n}@example.com",password:"hogehoge",password_confirmation:"hogehoge")
end

# 　・デザイナー部
# 　・イラスト部
# 　・アプリ部
# 　・ゲーム部
# 　・うぇ部
# 　・カメラ部
# 　・音楽部
# 　・映像部
# 　・マネージャー
# 　・新聞部
