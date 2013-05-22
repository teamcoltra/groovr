groovr = require '../'
should = require 'should'
require 'mocha'

describe 'groovr', ->
  describe 'getConfig()', ->
    it 'should return config data', (done) ->
      groovr.getConfig (err, config) ->
        should.not.exist err
        should.exist config
        should.exist config.country
        should.exist config.sessionID
        should.exist config.lang
        done()

  describe 'getExtraConfig()', ->
    it 'should return config data', (done) ->
      groovr.getExtraConfig (err, config) ->
        should.not.exist err
        should.exist config
        should.exist config.client
        should.exist config.clientRevision
        should.exist config.clientSalt
        done()

  describe 'getCommunicationToken()', ->
    it 'should return config data', (done) ->
      groovr.getCommunicationToken (err, token, config, extraConfig) ->
        should.not.exist err
        should.exist token
        should.exist config
        should.exist extraConfig
        done()

  describe 'getSongFile(songId)', ->
    it 'should return stream url', (done) ->
      groovr.getSongFile "25279036", (err, file, config, extraConfig) ->
        should.not.exist err
        should.exist file
        should.exist file.url
        should.exist config
        should.exist extraConfig
        console.log file
        done()

  describe 'getPopular()', ->
    it 'should return songs for daily', (done) ->
      groovr.getPopular (err, res, config, extraConfig) ->
        should.not.exist err
        should.exist res
        should.exist config
        should.exist extraConfig
        Array.isArray(res).should.equal true
        res.length.should.not.equal 0
        done()

    it 'should return songs for monthly', (done) ->
      groovr.getPopular 'monthly', (err, res, config, extraConfig) ->
        should.not.exist err
        should.exist res
        should.exist config
        should.exist extraConfig
        Array.isArray(res).should.equal true
        res.length.should.not.equal 0
        done()

  describe 'search()', ->
    it 'should return search results for flying lotus as songs', (done) ->
      opt =
        query: "flying lotus"
        type: "Songs"

      groovr.search opt, (err, res, config, extraConfig) ->
        should.not.exist err
        should.exist res
        should.exist config
        should.exist extraConfig
        Array.isArray(res).should.equal true
        res.length.should.not.equal 0
        done()

    it 'should return search results for flying lotus as artists', (done) ->
      opt =
        query: "flying lotus"
        type: "Artists"

      groovr.search opt, (err, res, config, extraConfig) ->
        should.not.exist err
        should.exist res
        should.exist config
        should.exist extraConfig
        Array.isArray(res).should.equal true
        res.length.should.not.equal 0
        done()