require 'sinatra'
require 'sinatra/reloader' if development?

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    if params[:post]
      name = params['post']
      post = load_post(File.join('posts', name))
      pass if post.nil?
      return haml :post, locals: { post: post }
    end

    haml :index, locals: { posts: latest_posts }
  end

  not_found { haml :not_found, locals: {} }

  private

  def latest_posts
    Dir['./posts/*.md'].sort_by { |file| File.mtime(file) }.map do |path|
      load_post(path)
    end
  end

  def load_post(path)
    basename_without_extension = File.basename(path, '.md')
    content = File.read(path)
    basename = File.basename(path)
    {
      title: basename_without_extension.gsub('-', ' ').capitalize,
      path: "/?post=#{basename}",
      preview: "#{content[0..30]}...",
      content: content
    }
  rescue StandardError
    nil
  end
end
