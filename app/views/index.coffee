`import Ember from 'ember'`

IndexView = Ember.View.extend
  focusSearch: (->
    @$('.torrent-search input').focus()
  ).on 'didInsertElement'

`export default IndexView`
