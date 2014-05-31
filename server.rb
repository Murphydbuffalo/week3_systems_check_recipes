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

def get_recipes_sql
  query = "SELECT name, id FROM recipes"
end

def get_ingredients_sql

end

get '/recipes' do 
  @recipes = access_db {|conn| conn.exec(get_recipes_sql) }
  erb :index
end

get '/' do 
  redirect 'recipes'
end

get '/recipes/:id' do 
  @recipe_id = params[:id] #use this to select the right ingredients
  @recipes = #connect to DB, select appropriate values
  @ingredients = #connect to DB, select values matching recipe_id
  erb :show
end



