# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($)->
  return unless $('#team_row_template').length == 1


  calculateWidth = (score) ->
    0.0004 * score

  logoHtml = $($('#team_logos').html())
  extractLogo = (id) ->
    logoHtml.filter("#logo_#{id}").html()

  class Scoreboard
    constructor: ->
      @body = $('tbody#scoreboard_body')
      @path = @body.data 'refresh-path'
      @interval = @body.data 'refresh-interval'

      @template = $('#team_row_template').html()
      @startPoll()
    startPoll: ->
      window.setTimeout(@poll(), @interval)
    poll: ->
      return =>
        $.ajax
          url: @path
          dataType: 'json'
          method: 'get'
          success: @receive()
    receive: ->
      return (data, textStatus, jqx) =>

        rows = for row in data.standings
          row['width'] = calculateWidth row['score']
          row['logo'] = extractLogo row['id']
          row['display_name'] = data.display_names[row['id']]
          Mustache.render @template, row
        @body.html rows.join()
        @body.attr 'data-response-id', jqx.getResponseHeader('X-Request-Id')
        @startPoll()

  Scoreboard.scoreboard = new Scoreboard
