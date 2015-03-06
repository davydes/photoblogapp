class SitemapController < ApplicationController
   def index
     @static_pages = [root_url]
     @articles = Article.published
     respond_to do |format|
       format.xml
     end
   end
 end
