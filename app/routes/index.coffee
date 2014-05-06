IndexRoute = Ember.Route.extend
  model: ->
    ['red', 'yellow', 'blue']

  actions:
    getTorrent: (torrent) ->
      @get('torrents').getTorrent(torrent)

`export default IndexRoute`
