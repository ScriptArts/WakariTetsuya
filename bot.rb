require 'yaml'
require 'json'
require 'redis'
require 'discordrb'

config = YAML.load_file('config.yml')
bot = Discordrb::Commands::CommandBot.new token: config['discord']['token'], client_id: config['discord']['client_id'], prefix: config['discord']['prefix']
redis = Redis.new host: config['redis']['db_host'], port: config['redis']['db_port']

bot.ready do
  bot.game = config['playing']
end

bot.command :mute do |event|
  status = redis.get event.channel.id
  if status != 'mute'
    redis.set event.channel.id, 'mute'
    event.send_message "#{event.channel.name}(id: #{event.channel.id})を無視するようになりました"
  else
    event.send_message 'このチャンネルは既にミュートされています'
  end
end

bot.command :unmute do |event|
  status = redis.get event.channel.id
  if status == 'mute'
    redis.del event.channel.id
    event.send_message "#{event.channel.name}(id: #{event.channel.id})でのわかる監視を開始しました"
  else
    event.send_message 'このチャンネルはミュートされていません'
  end
end

bot.message do |event|
  author_id = event.author.id
  status = redis.get event.channel.id
  if author_id == !config['client_id'] || status == 'mute'
  elsif event.content =~ /.*わかる.*/
    wakaru = [
      'https://media.makotia.me/wakaritetsuya/wakaru/2CEL3AYmv8e5.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/3uCgq1Cgj1fX.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/6i13A1lNDbl6.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/9XQoPgNL22UT.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/9ysrgyhaDF42.png',
      'https://media.makotia.me/wakaritetsuya/wakaru/b1VCm39ptA2X.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/HZd7BNTExtLm.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/JokPZNWleJ4W.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/lqzpoh3TtO6F.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/myn3tvaQ8G6r.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/PBvjYl2QFAJS.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/RcSwa3cDTjfg.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/tuvFpye24VwT.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaru/UA7Xg9W1VAqN.jpg'
    ]
    event.send_message(wakaru.shuffle.shuffle.shuffle.sample)
  elsif event.content =~ /.*わからない.*/
    wakaranai = [
      'https://media.makotia.me/wakaritetsuya/wakaranai/paFNbrjg9Pq5.jpg',
      'https://media.makotia.me/wakaritetsuya/wakaranai/QI0r7HfzK1bu.jpg'
    ]
    event.send_message(wakaranai.shuffle.shuffle.shuffle.sample)
  end
end

bot.reaction_add do |event|
  if event.message.author.id.to_i == config['discord']['client_id'].to_i
    event.message.delete
  end
end

bot.run
