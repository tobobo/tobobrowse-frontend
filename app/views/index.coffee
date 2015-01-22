`import Ember from 'ember'`
`import $ from 'jquery'`

IndexView = Ember.View.extend
  focusSearch: (->
    @torrentInput().focus()
  ).on 'didInsertElement'

  torrents: Ember.computed.alias 'controller.filteredTorrents'
  query: Ember.computed.alias 'controller.query'

  selectedTorrentIndex: -1

  updateSelectedTorrent: (->
    @get 'torrents'
    .filterBy('isSelected', true).forEach (torrent) ->
      torrent.set 'isSelected', false
    if @get('selectedTorrentIndex') >= 0
      @get 'torrents'
      .objectAt(@get('selectedTorrentIndex'))?.set 'isSelected', true
  ).observes 'selectedTorrentIndex', 'torrents'

  clearSelectedTorrent: (->
    @set 'selectedTorrentIndex', -1
  ).observes 'query'

  selectedTorrent: (->
    if @get('selectedTorrentIndex') >= 0
      @get('torrents').objectAt(@get('selectedTorrentIndex'))
  ).property 'selectedTorrentIndex', 'torrents.@each'

  addKeyBindings: (->
    $(window).on 'keydown', (e) =>
      unless @inputIsFocused()
        if e.keyCode == 13
          if @get('selectedTorrent')?
            @get('controller.torrents').getTorrent @get('selectedTorrent')
        else if e.keyCode == 74
          if @get('selectedTorrent')?
            @send 'incrementTorrent'
          else
            @send 'selectFirstTorrent'
        else if e.keyCode == 75
          if @get('selectedTorrent')?
            @send 'decrementTorrent'
          else
            @set 'selectedTorrentIndex', @get('torrents.length') - 1
  ).on 'didInsertElement'

  inputIsFocused: ->
    @torrentInput().is(':focus') or @addTorrentInput().is(':focus')

  torrentInput: ->
    @$('.torrent-search input')

  addTorrentInput: ->
    @$('.torrent-input input')

  actions:
    selectFirstTorrent: ->
      @torrentInput()?.blur()
      @set 'selectedTorrentIndex', 0
      if @get('torrents.length') == 1
        @get('controller.torrents').getTorrent @get('selectedTorrent')

    incrementTorrent: ->
      if @get('selectedTorrentIndex') < @get('torrents.length') - 1
        @incrementProperty 'selectedTorrentIndex'

    decrementTorrent: ->
      if @get('selectedTorrentIndex') > 0
        @decrementProperty 'selectedTorrentIndex'

`export default IndexView`
