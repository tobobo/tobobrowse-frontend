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
      request: (path = '', method = 'GET', data = {}) ->
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
          model = @cacheFor(prop) or Ember.A()
          @set 'isLoading', true
          @request 'torrents'
          .then (data) =>
            for torrent in data['torrents']
              @addTorrent model, torrent
            @set 'isLoading', false
          model
      ).property()

      addTorrent: (model, torrent) ->
        dupe = model.find (maybeDupe) =>
          maybeDupe['addedDate'] == torrent['addedDate'] and
            maybeDupe['sizeWhenDone'] == torrent['sizeWhenDone']
        if dupe?
          dupe.setProperties torrent
        else
          model.pushObject Ember.Object.create(torrent)

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
