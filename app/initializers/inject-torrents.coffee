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
      request: (path = '', method = 'GET', data = {}) ->
        console.log 'data is', data
        new Ember.RSVP.Promise (resolve, reject) =>
          Ember.$.ajax
            method: method
            url: "http://chips.whatbox.ca:8000/#{path}"
            data: data
            dataType: 'json'
            xhrFields:
              withCredentials: true
          .then ((data) -> Ember.run -> resolve data)
          , ((error) -> Ember.run -> reject error)

      content: ((prop, value) ->
        if value? then value
        else
          @refreshTimer()
      ).property()

      _getTorrents: (model) ->
        @set 'isLoading', true
        @request 'torrents'
        .then (data) =>
          for torrent in data['torrents']
            @_addTorrent model, torrent
          @set 'isLoading', false

      refreshTimer: ->
        Ember.run.later =>
          @refreshTimer()
        , 5000
        @refresh()

      refresh: ->
        model = @cacheFor('model') or Ember.A()
        @_getTorrents model
        model

      _addTorrent: (model, torrent) ->
        console.log 'adding torrent', torrent
        dupe = model.find (maybeDupe) =>
          sameDate = maybeDupe['addedDate'] == torrent['addedDate']
          if torrent['sizeWhenDone'] > 0
            sameDate
          else
            sameDate and maybeDupe['sizeWhenDone'] == torrent['sizeWhenDone']
        if dupe?
          dupe.setProperties torrent
        else
          model.pushObject Ember.Object.create(torrent)

      addTorrent: (url) ->
        @request 'torrents', 'POST',
          torrent:
            url: url

      getTorrent: (torrent) ->
        torrent.set 'gettingInfo', true
        @request "torrents/#{torrent.get('name')}"
        .then (data) =>
          torrent.set 'gettingInfo', false
          torrent.setProperties data['torrent']

      setCredentials: (username, passwd) ->
        @setProperties
          username: username
          passwd: passwd

    for type in ['controller', 'route']
      for name in [injection_type]
        container.typeInjection type, name, key

`export default torrentsInitializer`
