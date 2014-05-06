IndexRoute = Ember.Route.extend
  model: ->
    ['red', 'yellow', 'blue']

  actions:

    addTorrent: ->
      @get('torrents').addTorrent @get('controller.url')
      .then =>
        @set 'controller.url', null
        @get('torrents').refresh()

`export default IndexRoute`
