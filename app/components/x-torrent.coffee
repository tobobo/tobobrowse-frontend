`import Ember from 'ember'`

TorrentComponent = Ember.Component.extend
  tagName: 'li'

  formattedName: (->
    name = @get('torrent.name')
    for char in ['\\.', '\\+']
      name = name.replace new RegExp(char, 'g'), "#{char.replace(/\\/g, '')}&#8203;"
    new Ember.Handlebars.SafeString name
  ).property 'torrent.name'

  isDownloading: (->
    @get('torrent.percentDone') < 100
  ).property('torrent.percentDone')
  isComplete: Ember.computed.not 'isDownloading'

  sortedFiles: (->
    files = Ember.A(@get('torrent.files'))
    files.sortBy 'name'
  ).property 'torrent.files'

  percentStr: (->
    @get('torrent.percentDone').toString().substr 0, 5
  ).property 'torrent.percentDone'

  progressStyle: (->
    "width: #{@get('torrent.percentDone')}%;"
  ).property 'torrent.percentDone'

  eta: (->
    if @get('torrent.eta') > 0
      @get('torrent.eta')
    else if @get('torrent.percentDone') == 0
      Infinity
    else
      0
  ).property 'torrent.eta'

  actions:

    getTorrent: ->
      @get('torrents').getTorrent @get('torrent')

    delete: ->
      if confirm("Are you sure you want to delete \"#{@get('torrent.name')}\"?")
        @get('torrents').deleteTorrent @get('torrent')

`export default TorrentComponent`
