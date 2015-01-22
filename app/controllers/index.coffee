`import Ember from 'ember'`

IndexController = Ember.Controller.extend
  filteredTorrents: Ember.computed 'torrents', 'torrents.@each', 'query', ->
    if @get('query') and @get('query').length > 1
      @get('torrents').filter (torrent) =>
        torrent.get('name').toLowerCase().indexOf(@get('query').toLowerCase()) > -1
    else
      @get('torrents')

`export default IndexController`
