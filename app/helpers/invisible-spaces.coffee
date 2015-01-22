`import Ember from 'ember'`

invisibleSpaces = Ember.Handlebars.makeBoundHelper (string) ->
  if string?
    for char in ['\\.', '\\+']
      string = string.replace new RegExp(char, 'g'), "#{char.replace(/\\/g, '')}&#8203;"
    new Ember.Handlebars.SafeString string

`export default invisibleSpaces`
