@isPhantomJS = window.navigator.userAgent.indexOf('PhantomJS') isnt -1
UI.registerHelper 'isPhantomJS', -> isPhantomJS
