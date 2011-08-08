require 'rubygems'  
require 'sinatra'  
require 'datamapper'
require 'builder'

SITE_TITLE = "gnomurl"
SITE_DESCRIPTION = ""

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/gnomurl.db")
class Link
  include DataMapper::Resource
  property :id, Serial
  property :link, String #, :required => true
  property :code, String
  property :created_at, DateTime
end
DataMapper.finalize.auto_upgrade!

def random_string(length)  
    rand(36**length).to_s(36)  
end

get '/' do
  @title = 'All Notes'
  erb :home
end

post '/' do
  @shortcode = random_string 5
  @lk = Link.create(
    :link       => params[:url],
    :code       => @shortcode,
    :created_at => Time.now
  )
  @shorturl = @lk.code
  erb :home
end


get '/:id' do
  @url = repository(:default).adapter.select('SELECT link FROM links WHERE code = ?', params[:id])
  @title = @url.to_s
  redirect @title || '/'  
end