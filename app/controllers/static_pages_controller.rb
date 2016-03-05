class StaticPagesController < ApplicationController
  #has a corespoding view with .html and .erb extansions
  def home
    #render(text: "Home method in StaticPages controller class");
  end
  #has a corespoding view with .html and .erb extansions
  def help
    #render(text: "Help method in StaticPages controller class");
  end
  
  def about
  end
  
  def contact
    #render(text:"This text is beinged rendered...no html.")
  end
end
