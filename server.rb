require 'sinatra' #need to be all lowercase to work on Linux servers
require 'pg'
require 'pry'

def access_db
  begin
    connection = PG.connect(dbname: 'systems_check_recipes')
    yield(connection)
  ensure
  	connection.close
  end
end

def get_recipes(page_offset)
  query = "SELECT name, description, id FROM recipes
           ORDER BY name LIMIT 10 OFFSET (10 * #{page_offset}) "
end

def get_ingredients
  query = "SELECT name FROM ingredients WHERE recipe_id = #{params[:id]}"
end

def get_single_recipe
  query = "SELECT name, description, instructions FROM recipes WHERE id = #{params[:id]}"
end

get '/recipes' do 
  params[:page].to_i == 0 ? @page = 1 : @page = params[:page].to_i 
  @page > 1 ? (page_offset = @page - 1) : (page_offset = 0)
  @all_recipes = access_db {|conn| conn.exec(get_recipes(page_offset)) }

  erb :index
end

get '/' do 
  redirect 'recipes'
end

get '/recipes/:id' do 
  @single_recipe = access_db {|conn| conn.exec(get_single_recipe)}.first #PG will always return an array of hashes, even if only one item (hash) is selected.
  @ingredients = access_db {|conn| conn.exec(get_ingredients) }

  erb :show
end



