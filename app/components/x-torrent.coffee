TorrentComponent = Ember.Component.extend
  tagName: 'li'
  isDownloading: (->
    @get('torrent.percentDone') < 100
  ).property('torrent.percentDone')
  isComplete: Ember.computed.not 'isDownloading'

  actions:
    getTorrent: ->
      @get('torrents').getTorrent @get('torrent')

`export default TorrentComponent`
