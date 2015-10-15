`import Ember from 'ember'`
`import ajax from 'ic-ajax'`
`import config from '../config/environment'`

injectTorrents =
  name: 'inject-torrents'
  after: ['store']
  initialize: (container, application) ->

    injection_type = 'torrents'
    container.typeInjection type, 'store', 'store:main'

    key = "#{injection_type}:main"
    container.register key, Ember.ArrayController.extend
      sortProperties: ['addedDate']
      sortAscending: false
      url: config.transmissionURL
      httpURL: config.httpURL
      request: (path = '', method = 'GET', data = {}, timeout = -1) ->
        ajax
          method: method
          url: "#{config.backendURL}#{path}"
          data: data
          timeout: timeout
          dataType: 'json'
          xhrFields:
            withCredentials: true

      model: ((prop, value) ->
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
        delayBase = if requestTime < 2000
          2000
        else if requestTime > 10000
          10000
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
          Ember.RSVP.resolve @get('model')

      _addTorrent: (torrent) ->
        dupe = @get('model').find (maybeDupe) =>
          sameDate = maybeDupe.get('addedDate') == torrent['addedDate']
          if torrent['sizeWhenDone'] > 0
            sameDate
          else
            sameDate and maybeDupe.get('sizeWhenDone') == torrent['sizeWhenDone']
        if dupe?
          dupe.setProperties torrent
        else
          @get('model').pushObject Ember.Object.create(torrent)

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
        @get('model').removeObject torrent
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

`export default injectTorrents`
