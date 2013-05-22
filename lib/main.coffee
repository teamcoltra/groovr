crypto = require 'crypto'
async = require 'async'
request = require 'request'
cheerio = require 'cheerio'
uuid = require 'node-uuid'
vm = require 'vm'

userAgent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36'
extraInfoRegex = /\{client:"(\S*)",clientRevision:"(\d*)"\}/
clientSaltRegex = /var \S="(\S*)",r=\{faultCodes:/

# mutating state - disgusting but required
sessionUUID = uuid.v4()

randomizer = -> (Math.floor(Math.random()*16).toString(16) for i in [0...6]).join ''

groovr =
  getJSONQuery: (method, commToken, config, extraConfig) ->
    body =
      method: method
      header:
        uuid: sessionUUID
        clientRevision: extraConfig.clientRevision,
        country: config.country
        privacy: 0,
        client: extraConfig.client
        session: config.sessionID

    body.header.token = groovr.getRequestToken(method, commToken, extraConfig.clientSalt) if commToken?

    req =
      method: 'POST'
      url: "https://html5.grooveshark.com/more.php?#{method}"
      headers:
        'User-Agent': userAgent
      json: body
    return req

  getSecretKey: (sessionId) ->
    crypto.createHash('md5').update(sessionId).digest('hex')

  getRequestToken: (method, commToken, salt) ->
    rand = randomizer()
    token = "#{method}:#{commToken}:#{salt}:#{rand}"
    return "#{rand}#{crypto.createHash('sha1').update(token).digest('hex')}"

  getExtraConfig: (cb) ->
    ropt =
      url: "http://html5.grooveshark.com/build/app.min.js"
      headers:
        'User-Agent': userAgent

    request ropt, (err, res, body) ->
      return cb err if err?
      matches = body.match extraInfoRegex
      [full, client, revision] = matches

      matches = body.match clientSaltRegex
      [full, salt] = matches

      out =
        client: client
        clientRevision: revision
        clientSalt: salt
      cb null, out

  getConfig: (cb) ->
    ropt =
      url: "http://html5.grooveshark.com"
      headers:
        'User-Agent': userAgent

    request ropt, (err, res, body) ->
      return cb err if err?
      $ = cheerio.load body
      constants = $('script').eq(1).text()
      script = vm.createScript constants

      ctx =
        window: {}
        GS:
          locales: {}

      script.runInNewContext ctx

      cb null, ctx.window.GS.config


  getCommunicationToken: (cb) ->
    async.parallel [groovr.getConfig, groovr.getExtraConfig], (err, [config, extraConfig]) ->
      return cb err if err?

      ropt = groovr.getJSONQuery 'getCommunicationToken', null, config, extraConfig
      ropt.json.parameters =
        secretKey: groovr.getSecretKey(config.sessionID)

      request ropt, (err, res, body) ->
        return cb err if err?
        cb null, body.result, config, extraConfig

  getPopular: (type, cb) ->
    if typeof type is 'function'
      cb = type
      tiype = 'daily'

    groovr.getCommunicationToken (err, commToken, config, extraConfig) ->
      return cb err if err?

      ropt = groovr.getJSONQuery 'popularGetSongs', commToken, config, extraConfig
      ropt.json.parameters =
        type: type

      request ropt, (err, res, body) ->
        return cb err if err?
        return cb null, body.result.Songs, config, extraConfig

  search: (opt={}, cb) ->
    groovr.getCommunicationToken (err, commToken, config, extraConfig) ->
      return cb err if err?

      ropt = groovr.getJSONQuery 'getResultsFromSearch', commToken, config, extraConfig
      ropt.json.parameters =
        query: opt.query
        type: opt.type

      request ropt, (err, res, body) ->
        return cb err if err?
        return cb null, body.result.result, config, extraConfig

  getSongFile: (songID, cb) ->
    groovr.getCommunicationToken (err, commToken, config, extraConfig) ->
      return cb err if err?

      ropt = groovr.getJSONQuery 'getStreamKeyFromSongIDEx', commToken, config, extraConfig
      ropt.json.parameters =
        prefetch: false
        mobile: true
        songID: songID
        country: config.country

      request ropt, (err, res, body) ->
        return cb err if err?
        return cb "Data not returned - Limit reached?" unless body?.result?.ip? and body?.result?.streamKey?
        body.result.url = "http://#{body.result.ip}/stream.php?streamKey=#{body.result.streamKey}"
        cb null, body.result, config, extraConfig

module.exports = groovr