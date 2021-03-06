`import Ember from 'ember'`

hhmmssHelper = Ember.Handlebars.makeBoundHelper (seconds) ->
  separator = ":"
  sections = []

  if seconds == Infinity
    sections.push "&#8734;"
  else
    minutesInHour = 60
    secondsInMinute = 60
    secondsInHour = minutesInHour*secondsInMinute

    hours = Math.floor seconds/secondsInHour
    hoursRemainder = seconds%secondsInHour
    minutes = Math.floor hoursRemainder/secondsInMinute
    seconds = Math.floor hoursRemainder%secondsInMinute

    if hours > 0 then sections.push "#{hours}"

    if hours > 0 or minutes > 0
      if (hours == 0 and minutes == 0) or (hours > 0 and minutes < 10) then sections.push "0#{minutes}"
      else sections.push "#{minutes}"

    if seconds < 10 and (hours > 0 or minutes > 0) then sections.push "0#{seconds}"
    else if hours == 0 and minutes == 0 then sections.push "#{seconds}s"
    else sections.push "#{seconds}"

  new Ember.Handlebars.SafeString sections.join(separator)

`export default hhmmssHelper`
