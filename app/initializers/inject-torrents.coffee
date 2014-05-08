`import ajax from 'ic-ajax'`

torrentsInitializer =
  name: 'injectTorrents'
  after: ['store']
  initialize: (container, application) ->

    injection_type = 'torrents'
    container.typeInjection type, 'store', 'store:main'

    key = "#{injection_type}:main"
    container.register key, Ember.ArrayController.extend
      sortProperties: ['addedDate']
      sortAscending: false
      url: 'http://chips.whatbox.ca:30446'
      request: (path = '', method = 'GET', data = {}, timeout = -1) ->
        ajax
          method: method
          url: "http://chips.whatbox.ca:8000/#{path}"
          data: data
          timeout: timeout
          dataType: 'json'
          xhrFields:
            withCredentials: true

      content: ((prop, value) ->
        Ember.run.next => @refreshTimer()
        Ember.A()
      ).property()

      refreshTimer: ->
        if @get('timerRef')?
          Ember.run.cancel @get('timerRef')
        refresh = @refresh()
        afterRefresh = =>
          timerRef = Ember.run.later =>
            @refreshTimer()
          , @get('requestDelay')
          @set 'timerRef', timerRef
        refresh.then afterRefresh, afterRefresh

      requestTime: 0
      requestDelay: (->
        requestTime = @get('requestTime')
        delayBase = if requestTime < 500
          500
        else if requestTime > 5000
          5000
        else
          requestTime
        delayBase*2
      ).property 'requestTime'

      refresh: ->
        @set 'isLoading', true
        startTime = Date.now()
        @request 'torrents'
        .then (data) =>
          @set 'requestTime', Date.now() - startTime
          for torrent in data['torrents']
            @_addTorrent torrent
          @set 'isLoading', false
          Ember.RSVP.resolve @get('content')

      _addTorrent: (torrent) ->
        dupe = @get('content').find (maybeDupe) =>
          sameDate = maybeDupe.get('addedDate') == torrent['addedDate']
          if torrent['sizeWhenDone'] > 0
            sameDate
          else
            sameDate and maybeDupe.get('sizeWhenDone') == torrent['sizeWhenDone']
        if dupe?
          dupe.setProperties torrent
        else
          @get('content').pushObject Ember.Object.create(torrent)

      addTorrent: (url) ->
        @request 'torrents', 'POST',
          torrent:
            url: url
        .then =>
          @refreshTimer()

      getTorrent: (torrent) ->
        torrent.set 'gettingInfo', true
        @request "torrents/#{torrent.get('name')}", 'GET', {}, 10000
        .then (data) =>
          torrent.set 'gettingInfo', false
          torrent.setProperties data['torrent']

      deleteTorrent: (torrent) ->
        torrent.set 'deleting', true
        @get('content').removeObject torrent
        @request "torrents/#{torrent.get('name')}", 'DELETE'
        .then =>
          @refreshTimer()

      setCredentials: (username, passwd) ->
        @setProperties
          username: username
          passwd: passwd

    for type in ['controller', 'route']
      for name in [injection_type]
        container.typeInjection type, name, key

`export default torrentsInitializer`
