require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'net/http'#httpリクエストをするためのライブラリ
require 'uri'#uriを扱うためのライブラリ

get '/' do
  base_url='http://wikipedia.simpleapi.net/api?output=html&keyword='
  if params[:keyword]
    keyword=URI.escape(params[:keyword])
    url=URI.parse(base_url+keyword)
    @result=Net::HTTP.get(url).force_encoding("utf-8")
  end
  erb:index
end