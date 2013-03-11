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
    if req.status[0] == 200
      false
    elsif req.status[0] == 404
      true
    else
      true
    end
  rescue Exception => e
    case e.message
      when /404/ then
        return true
      when /505/ then
        return true
      else
        log(username + " other error: " + e.message)
        return true
    end
  end

  def check_github(username)
    req_url = "http://www.github.com/" + username
    req = open(req_url)
    if req.status[0] == 200
      false
    elsif req.status[0] == 404
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

3.times do
  u = Unamegen.new
  username = u.generate

  print username

  if u.check_dotcom(username)
    print " | .com avail"
  else
    print " | .com taken"
  end

  if u.check_twitter(username)
    print " | twit avail"
  else
    print " | twit taken"
  end

  if u.check_github(username)
    print " | github avail"
  else
    print " | github taken"
  end

  print "\n"
  sleep 1.5 # whois will start to refuse connections if done too fast.
end