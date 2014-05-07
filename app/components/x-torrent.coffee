TorrentComponent = Ember.Component.extend
  tagName: 'li'
  isDownloading: (->
    @get('torrent.percentDone') < 100
  ).property('torrent.percentDone')
  isComplete: Ember.computed.not 'isDownloading'
  sortedFiles: (->
    files = Ember.A(@get('torrent.files'))
    files.sortBy 'name'
  ).property 'torrent.files'

  sortedFilesDidChange: (->
    console.log @get('sortedFiles')
  ).observes('sortedFiles.@each')

  actions:
    getTorrent: ->
      @get('torrents').getTorrent @get('torrent')
    delete: ->
      if confirm("Are you sure you want to delete \""#{@get('torrent.name')}\"?")
        @get('torrents').deleteTorrent @get('torrent')

`export default TorrentComponent`
