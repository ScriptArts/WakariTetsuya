require 'yaml'
require 'json'
require 'discordrb'

config = YAML.load_file('config.yml')
bot = Discordrb::Commands::CommandBot.new token: config['token'], client_id: config['client_id'], prefix: config['prefix']

bot.ready do
  bot.game = config['playing']
end

bot.message do |event|
  author_id = event.author.id
  if author_id == !config['client_id']
    return
  elsif event.content =~ /.*わかる.*/
    wakaru = [
      'https://media.mkta.pw/wakaritetsuya/wakaru/2CEL3AYmv8e5.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/3uCgq1Cgj1fX.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/6i13A1lNDbl6.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/9XQoPgNL22UT.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/9ysrgyhaDF42.png',
      'https://media.mkta.pw/wakaritetsuya/wakaru/b1VCm39ptA2X.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/HZd7BNTExtLm.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/JokPZNWleJ4W.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/lqzpoh3TtO6F.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/myn3tvaQ8G6r.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/PBvjYl2QFAJS.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/RcSwa3cDTjfg.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/tuvFpye24VwT.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaru/UA7Xg9W1VAqN.jpg'
    ]
    event.send_message(wakaru.shuffle.shuffle.shuffle.sample)
  elsif event.content =~ /.*わからない.*/
    wakaranai = [
      'https://media.mkta.pw/wakaritetsuya/wakaranai/paFNbrjg9Pq5.jpg',
      'https://media.mkta.pw/wakaritetsuya/wakaranai/QI0r7HfzK1bu.jpg'
    ]
    event.send_message(wakaranai.shuffle.shuffle.shuffle.sample)
  end
end

bot.run
