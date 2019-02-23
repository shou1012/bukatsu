Community.create([{id:1,name:"デザイナー部"},{id: 2,name:"イラスト部"},{id:3,name:"アプリ部"},{id:4,name:"ゲーム部"},{id:5,name:"うぇ部"},{id:6,name:"映像部"},{id:7,name:"カメラ部"},{id:8,name:"音楽部"},{id:9,name:"新聞部"},{id:10,name:"マネージャー"}])

30.times do |n|
  User.create(id:n,name: "User #{n}",email: "user-#{n}@example.com",password:"hogehoge",password_confirmation:"hogehoge")
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
