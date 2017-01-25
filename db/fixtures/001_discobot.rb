discobot_username ='mebot'
user = User.find_by("id <> -2 and username_lower = '#{discobot_username}'")

if user
  user.update_attributes!(username: UserNameSuggester.suggest(discobot_username))
end

User.seed do |u|
  u.id = -2
  u.name = discobot_username
  u.username = discobot_username
  u.username_lower = discobot_username
  u.email = "discobot_email"
  u.password = SecureRandom.hex
  u.active = true
  u.admin = true
  u.moderator = true
  u.approved = true
  u.trust_level = TrustLevel[4]
end

bot = User.find(-2)

bot.user_option.update_attributes!(
  email_private_messages: false,
  email_direct: false
)

if !bot.user_profile.bio_raw
  bot.user_profile.update_attributes!(
    bio_raw: I18n.t('discourse_narrative_bot.bio', site_title: SiteSetting.title, discobot_username: bot.username)
  )
end

Group.user_trust_level_change!(-2, TrustLevel[4])

# TODO Pull the user avatar from that thread for now. In the future, pull it from a local file or from some central discobot repo.
UserAvatar.import_url_for_user(
  "https://00e9e64bac392ad26b23b1918fda8fd506abfaa75cba33fa04-apidata.googleusercontent.com/download/storage/v1/b/220d5b896cce2bed16141ec4c7fa4a85f5229606/o/mebot.png?qk=AD5uMEt8eF-Un-cnQJZr3kMhKTA2yN8K4NQkQ08ZdMMgK5lT_YcXiqTG2lPPhLcemAAecbh5kHc7-lrtY_maU6c32tnmD-OcMRe-cNnoLKKTtXY1GGDjIpNSpfUhQHfuPBhDg3WZh2tia3Y_Eebh7wdargc2pDIKftb_4ShyZf1DECRNaxYZqtWw16Kleou78J_5eagdtr7tu01FoIMEfshVqQoPm3vMs2Av_ValwMbLp_Ld8NcK4PFG_1cdCsE-nbAXndrI8YFUKZaFtkTeKEg7g6q4wDqHzwBYBkwVAPFTePM2xP9NSE0ZTJYQQhcNFGLMHXyiZlNpFVqvrSasoQFoVy9MMIY-Hn4FeXGzVigmymcIcI0C_NIf3TYTXamRT7YBs12nijb9OQhZXFFawxEEHrv67pdZW5WkQ-4totcDWtdjgDaAyAgIyD9h-L1BPGl1LYKqhZKoDF0rhWgvL8DklqhiuitrKf__djaLLa7zOjHskRR_ff_CHkvTK_QY1WKJpnl8xRaLemtWRirf9bCOiiw78pe8LYcJFBWtW1bbSM1Ixj7iMkYmYXm62fFAHGYDXlfJb7gQCHJqV7VnyRx4_HuXs8pnMFUy9_52asDQ8zOrVrEdBwpeWTdR3ZxZlKh9gh6PmJ6nP3HHnGYBI-1cAM-NMp45WtNPTOJFMa4O3oiyeppSQrXe8lTb3EOTn6SfVK1amDEX7sVlH2IYuAyvzPyyBeCGf0TKEZHcOSARXN0R9hl8EHRdt8RkRU46wTGT5QwXMmVEniQFMWXbht-lsUfK7UX4ZiKnxM53dkiYpaJ8QzvATXg",
  User.find_by(username: discobot_username),
  override_gravatar: true
)
