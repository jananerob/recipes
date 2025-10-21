class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action :check_private_access!, only: [:show]
  before_action :authorize_user!, only: %i[edit update destroy] 

  # GET /recipes
  def index
    @recipes = Recipe.where(is_private: false)

    if user_signed_in?
      @recipes = @recipes.or(Recipe.where(user: current_user, is_private: true))
    end
  end
  
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: "Recipe was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy!
    redirect_to recipes_url, notice: "Recipe was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:title, :instructions, :prep_time, :cook_time, :is_private, :calories)
    end

  def check_private_access!
    # Check 1: Is it private? AND Check 2: Does the current user NOT own it?
    if @recipe.is_private? && @recipe.user != current_user
      redirect_to recipes_path, alert: "You are not authorized to view this private recipe."
    end
  end

    def authorize_user!
    unless @recipe.user == current_user
      redirect_to recipes_path, alert: "You are not authorized to modify this recipe."
    end
  end
end