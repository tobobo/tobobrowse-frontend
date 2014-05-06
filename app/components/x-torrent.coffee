TorrentComponent = Ember.Component.extend
  tagName: 'li'
  isDownloading: (->
    comparison = @get('torrent.percentDone') < 100
    console.log @get('torrent.percentDone'), 100, comparison
    comparison
  ).property('torrent.percentDone')
  isComplete: Ember.computed.not 'isDownloading'

  actions:
    getTorrent: ->
      @get('torrents').getTorrent @get('torrent')

`export default TorrentComponent`
