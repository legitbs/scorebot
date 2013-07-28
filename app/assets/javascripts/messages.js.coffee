jQuery ($) ->
  return unless $('#messages').length == 1

  class Messenger
    constructor: ->
      @messages = $('#messages')
      @path = @messages.data 'path'
      @interval = @messages.data 'interval'
      @template = @messages.html()
      @messages.html('')
      @since = 0
      @startPoll()
    startPoll: ->
      window.setTimeout @poll(), 0
    requeue: ->
      finish = new XDate()
      lag = @start.diffMilliseconds(finish)
      window.setTimeout @poll(), @interval - lag
    poll: ->
      return =>
        @start = new XDate()
        $.ajax
          url: @path
          dataType: 'json'
          method: 'get'
          data:
            since: @since
          success: @receive()
    receive: ->
      return (data, textStatus, jqx) =>
        @since = data.since
        h = Mustache.render @template, data
        @messages.html h
        @requeue()

  Messenger.messenger = new Messenger