navigator.geolocation.getCurrentPosition (pos) ->
  $.post "/set_geolocation",
    latitude: pos.coords.latitude
    longitude: pos.coords.longitude

  return