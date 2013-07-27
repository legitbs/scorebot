jQuery ($) ->
  return unless $('#timers').length == 1
  
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
        $.ajax
          url: @timerPath
          dataType: 'json'
          method: 'get'
          success: @receive()
    receive: ->
      return (data, textStatus, jqx) =>
        server = new XDate data['time']
        timers = data.timers
        game  = @toRemnant(server, new XDate timers.game)
        today = @toRemnant(server, new XDate timers.today)
        round = @toRemnant(server, new XDate timers.round)
        h = Mustache.render @template,
          game: game
          today: today
          round: round
        @timers.html h
        @requeue()
    toRemnant: (now, ending) ->
      diff =
        s: Math.floor(now.diffSeconds(ending) % 60)
        m: Math.floor(now.diffMinutes(ending) % 60)
        h: Math.floor(now.diffHours(ending))
      return diff

  Countdown.countdown = new Countdown