module UsersHelper

   # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 170 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image = user.picture || gravatar_url
    image_tag(image, alt: user.name, class: "gravatar")
  end

end
