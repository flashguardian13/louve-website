$ ->
  loadFacebookSDK()
  bindFacebookEvents() unless window.fbEventsBound

bindFacebookEvents = ->
  $(document)
    .on('turbolinks:load', ->
      FB?.XFBML.parse()
    )
  @fbEventsBound = true

loadFacebookSDK = ->
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/en_US/sdk.js")

initializeFacebookSDK = ->
  FB.init
    appId  : 'rhiannon-louve-facebook-app-id'
    status : true
    cookie : true
    xfbml  : true
    autoLogAppEvents : true
    version: 'v2.11'