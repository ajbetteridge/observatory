#!
# Copyright(c) 2013 Superstring Software
# Based on Sencha Labs logger
#

Observatory = if Observatory? then Observatory else {}

_.extend Observatory,

  logger: (req, res, next) ->
    if not TLog._log_http
      next()
      return

    req._startTime = new Date
    end = res.end
    res.end = (chunk, encoding) ->
      res.end = end
      res.end chunk, encoding

      # TODO: LOG HERE!!!
      obj =
        url: req.originalUrl or req.url
        method: req.method
        referrer: req.headers["referer"] or req.headers["referrer"]
        remoteAddress:
          if req.ip
            req.ip
          else
            if req.socket.socket
              req.socket.socket.remoteAddress
            else
              req.socket.remoteAddress
        status: res.statusCode
        httpVersion: req.httpVersionMajor + "." + req.httpVersionMinor
        userAgent: req.headers["user-agent"]
        #contentLength: parseInt(res.getHeader('Content-Length'), 10)
        timestamp: new Date
        responseTime: new Date - req._startTime

      console.dir obj
      TLog.addToLogsBuffer obj
    next()


  ###
  request header
  ###
  _tokenReq: (req, res, field) ->
    req.headers[field.toLowerCase()]


  ###
  response header
  ###
  _tokenRes: (req, res, field) ->
    (res._headers or {})[field.toLowerCase()]


(exports ? this).Observatory = Observatory