jQuery ($) ->
  return unless $('#timers').length == 1

  pad = (n) ->
    return "0#{n}" if n < 10 & n >= 0
    n

  class Countdown
    constructor: ->
      @timers = $('#timers')
      @timerPath = @timers.data('timer-path')
      @interval = @timers.data('timer-interval')
      @template = @timers.html()
      @timers.html('')
      @startPoll()
    startPoll: ->
      window.setTimeout(@poll(), 0)
    requeue: ->
      finish = new XDate()
      lag = @start.diffMilliseconds(finish)
      window.setTimeout(@poll(), @interval - lag)
    poll: ->
      return =>
        @start = new XDate()
        if !@recentTimers? || (@start > @recentTimers.next)
          $.ajax
            url: @timerPath
            dataType: 'json'
            method: 'get'
            success: @receive()
        else
          @lazyUpdate()
    receive: ->
      return (data, textStatus, jqx) =>
        server = new XDate data['time']
        @adjustment = @start.diffMilliseconds(server)
        @recentTimers = data.timers
        @recentTimers.next = @start.clone().addSeconds(15)
        @lazyUpdate()
    lazyUpdate: ->
      server = @start.addMilliseconds(@adjustment)
      game  = @toRemnant(server, new XDate @recentTimers.game)
      today = @toRemnant(server, new XDate @recentTimers.today)
      round = @toRemnant(server, new XDate @recentTimers.round)
      h = Mustache.render @template,
        game: game
        today: today
        round: round
      @timers.html h

      @requeue()
    toRemnant: (now, ending) ->
      try
        diff =
          s: pad(Math.abs(Math.floor(now.diffSeconds(ending) % 60)))
          m: pad(Math.abs(Math.floor(now.diffMinutes(ending) % 60)))
          h: pad(Math.floor(now.diffHours(ending)))
          next: now.diffMilliseconds(ending)
          ending: ending
        return diff
      catch
        return {h: '00', m: '00', s: '00', next: 0, ending: now}

  Countdown.countdown = new Countdown
