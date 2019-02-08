require "json"
require "sinatra"
require "intercom"

# Useful tools for manipulating JSON
## https://codebeautify.org/jsonminifier
## https://codebeautify.org/javascript-escape-unescape

# Create an Intercom client to make REST API calls
access_token = ENV['TOKEN']
intercom = Intercom::Client.new(token: access_token)

post'/' do # Send default state of the card when the app is first loaded by the messenger
  rateThisDogHomeCard = "{\"canvas\":{\"content\":{\"components\":[{\"id\":\"rate-this-dog-header\",\"type\":\"text\",\"text\":\"Rate This Dog\",\"style\":\"header\",\"align\":\"center\",\"bottom_margin\":false},{\"id\":\"welcome-link\",\"type\":\"image\",\"url\":\"https://downloads.intercomcdn.com/i/o/86160844/0f0f53fbdb1c741e2f7bca83/link.jpg\",\"align\":\"center\",\"width\":130,\"height\":130,\"rounded\":true},{\"id\":\"b57a7c7047a3674d6876063a2e3a\",\"type\":\"button\",\"label\":\"Start Rating\",\"style\":\"primary\",\"action\":{\"type\":\"submit\",\"url\":null},\"bottom_margin\":false}]},\"stored_data\":{}}}"
  rateThisDogHomeCard # Return the card
end

# Ping another API to grab an image url
def fetchImage
  url = "https://dog.ceo/api/breeds/image/random"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  imgURL = JSON.parse(response)
  output = imgURL["message"]
end

post '/submit' do # When a user presses a button in your app, return a card
  button1 = "Good Boy" # Variable for voting button
  button2 = "Great Boy" # Variable for voting button
  image = fetchImage # Pull a new image using the function above
  response_from_messenger = JSON.parse(request.body.read) # Store the webhook fired on submission

  # Send a new card to the messenger including some of our variables
  votingCard = "{\"canvas\":{\"content\":{\"components\":[{\"id\":\"dog\",\"type\":\"image\",\"url\":\"#{image}\",\"align\":\"left\",\"width\":340,\"height\":240,\"rounded\":false},{\"id\":\"votingSelection\",\"type\":\"single-select\",\"label\":\ null,\"value\":\"3e0820c0e0af9cb653dbf1ae2752\",\"save_state\":\"unsaved\",\"options\":[{\"id\":\"3e0820c0e0af9cb653dbf1ae2752\",\"type\":\"option\",\"text\":\"#{button1}\"},{\"id\":\"a2ae157c6b9878b363aee397590a\",\"type\":\"option\",\"text\":\"#{button2}\"}],\"action\":{\"type\":\"submit\"}}]},\"stored_data\":{}}}"

  # puts "======================================================"
  # isvote = response_from_messenger["current_canvas"]["content"][0]
  # puts "here is the id value: #{response_from_messenger}"
  # puts "======================================================"


  # Store Event for the person interacting w/ the card
  intercom.events.create(
  event_name: "rated-dog",
  created_at: Time.now.to_i,
  id: response_from_messenger["user"]["id"], # grab their ID value from webhook
  metadata: {
    "dog:" => response_from_messenger["current_canvas"]["content"]["components"][0]["url"]
  })


  puts "======================================================"
  puts "Here's the #{intercom_id}"
  puts "======================================================"
  # if intercom_id.nil?
  #   puts "no id value"
  # else

  # 2019-02-07T02:53:09.524320+00:00 app[web.1]: 2019-02-07 02:53:09 - Intercom::ResourceNotFound - User Not Found:
  # 2019-02-07T02:53:09.524358+00:00 app[web.1]: 	/app/vendor/bundle/ruby/2.4.0/gems/intercom-3.7.3/lib/intercom/request.rb:170:in `raise_application_errors_on_failure'


  # Return the new card
  votingCard


end
