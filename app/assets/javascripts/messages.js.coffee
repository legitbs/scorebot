jQuery ($) ->
  return unless $('#messages').length == 1

  class Messenger
    constructor: ->
      @messages = $('#messages')
      @messageList = @messages.children('ul')
      @path = @messages.data 'path'
      @interval = @messages.data 'interval'
      @template = @messageList.html()
      @messageList.html('')
      @since = 0
      @startPoll()
      @built = false
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
        @messageList.prepend h
        @requeue()

  Messenger.messenger = new Messenger