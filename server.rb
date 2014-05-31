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

def get_recipes
  query = "SELECT name, description, id FROM recipes"
end

def get_ingredients
  query = "SELECT name FROM ingredients WHERE recipe_id = #{params[:id]}"
end

def get_single_recipe
  query = "SELECT name, description FROM recipes WHERE id = #{params[:id]}"
end

get '/recipes' do 
  @all_recipes = access_db {|conn| conn.exec(get_recipes) }
  erb :index
end

get '/' do 
  redirect 'recipes'
end

get '/recipes/:id' do 
  @single_recipe = access_db {|conn| conn.exec(get_single_recipe)}.first
  @ingredients = access_db {|conn| conn.exec(get_ingredients) }

  erb :show
end



