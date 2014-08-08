class Dingus
  KEY = 'a' * 32

  def initialize(dingus, opts={  })
    if opts[:plaintext]
      @dingus_pt = dingus
    else
      @dingus_ct = dingus
    end
  end

  def plaintext
    return @dingus_pt if defined? @dingus_pt

    c = cipher

    buf = c.update @dingus_ct
    @dingus_pt = buf + c.final
  end

  def to_h
    return @to_h if defined? @to_h

    tag, team_num, uid, clocktime, timesopened = plaintext.unpack("S>CSLL")

    @to_h = { 
      tag: tag,
      team_num: team_num,
      uid: uid,
      clocktime: clocktime,
      timesopened: timesopened
    }
  end

  def cipher
    cipher = OpenSSL::Cipher.new 'AES-256-ECB'
    cipher.decrypt
    cipher.padding = 0
    cipher.key = KEY

    return cipher
  end
end
