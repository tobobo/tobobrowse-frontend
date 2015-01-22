`import Ember from 'ember'`

IndexRoute = Ember.Route.extend

  actions:

    addTorrent: ->
      @get('torrents').addTorrent @get('controller.url')
      .then =>
        @set 'controller.url', null

`export default IndexRoute`
