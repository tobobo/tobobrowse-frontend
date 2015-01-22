`import Ember from 'ember'`

IndexController = Ember.Controller.extend
  filteredTorrents: []
  filterTorrents: (->
    Ember.run.throttle @, @runTorrentFilter, 500
    Ember.run.debounce @, @runTorrentFilter, 500
  ).observes 'torrents', 'torrents.@each', 'query'
  runTorrentFilter: ->
    if @get('query') and @get('query').length > 1
      @set 'filteredTorrents', @get('torrents').filter (torrent) =>
        torrent.get('name').toLowerCase().indexOf(@get('query').toLowerCase()) > -1
    else
      @set 'filteredTorrents', @get('torrents')

`export default IndexController`
