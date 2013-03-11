require 'whois'
require 'open-uri'

class Unamegen
  def generate
    # generates the username
    vowels     = ["a","e","i","o","u"]
    consanants = ["b","c","d","f","g","h","j","k","l","m","n","p","r","s","t","v","w","x","y","z"]

    little = 3
    big    = 7

    length = rand(little..big)
    name   = ""

    length.times do |i|
      letter = ""
      if i % 2 == 0
        letter = vowels[(rand() * vowels.count).floor]
      else
        letter = consanants[(rand() * consanants.length).floor]
      end

      name = name + letter
    end

    return name
  end

  def check_twitter(username)
    req_url = "https://twitter.com/" + username
    req = open(req_url)
    if req.status[0] == "200"
      false
      #puts "TC: ES 200"
    elsif req.status[0] == "404"
      true
      #puts "TC: ES 404"
    else
      true
      #puts "TC: ES else: " + req.status[0] + req.status[1]
    end
  rescue Exception => e
    case e.message
      when /404/ then
        return true
        #puts "TC: ES 404 exception"
      when /505/ then
        return true
        #puts "TC: ES 505 exception"
      else
        return true
        #puts "TC: other exception: " + e.message
    end
  end

  def check_github(username)
    req_url = "https://github.com/" + username
    req = open(req_url)
    if req.status[0] == "200"
      false
    elsif req.status[0] == "404"
      true
    else
      true
    end
  rescue Exception => e
    case e.message
      when /404/ then return true
      when /505/ then return true
      else return true
    end
  end

  def check_dotcom(username)
    c = Whois.whois(username + ".com")
    return c.available?
  rescue Exception => e
    return false
  end

end

20.times do
  u = Unamegen.new
  username = u.generate
  stat_dotcom = u.check_dotcom(username)
  if stat_dotcom
    stat_twitter = u.check_twitter(username)
  end
  if stat_twitter
    stat_github = u.check_github(username)
  end

  puts username if stat_github

  sleep 0.5 # whois will start to refuse connections if done too fast.
end