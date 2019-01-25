require 'json'
require 'sinatra'
require 'net/http'
require 'intercom'

# ~~~~~~ FUNCTIONS USED BY YOUR APP ~~~~~~ #
# This function makes a call to an external service and parses the response for an image URL.
def getDoggo
  url = "https://dog.ceo/api/breeds/image/random"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  dogUrl = JSON.parse(response)
  output = dogUrl["message"]
end

intercom = Intercom::Client.new(token: 'dG9rOjc0YjliN2QyXzcwZDVfNDg4Yl84YjQ5XzE3OWNhMTAwNWUwOToxOjA=')


# ~~~~~~ ENDPOINTS USED BY INTERCOM ~~~~~~ #
# INITIALIZE FLOW WEBHOOK URL
# Endpoint that's hit when your app is loaded in the messenger / home screen
post'/' do
  content_type 'application/json'
  puts response.inspect
  response = '{
      "canvas": {
        "content": {
          "components": [
              {
               "id": "rate-this-dog-header",
               "type": "text",
               "text": "Rate This Dog [Staging]",
               "style": "header",
               "align": "center",
               "bottom_margin": false
             },
            {
              "id": "welcome-link",
              "type": "image",
              "url": "https://downloads.intercomcdn.com/i/o/86160844/0f0f53fbdb1c741e2f7bca83/link.jpg",
              "align": "center",
              "width": 130,
              "height": 130,
              "rounded": true
            },
            {
              "id": "b57a7c7047a3674d6876063a2e3a",
              "type": "button",
              "label": "Start Rating",
              "style": "primary",
              "action": {
                "type": "submit",
                "url": null
              },
              "bottom_margin": false
            }
          ]
        },
        "stored_data": {}
      }
    }'
  response
end

# SUBMIT FLOW WEBHOOK URL
# Sent when an end-user interacts with your app, via a button, link, or text input. This flow can occur multiple times as an end-user interacts with your app.
post '/submit' do
  # Ingest webhook
  request.body.rewind
  payload_body = request.body.read
  response = JSON.parse(payload_body)

  # Pull out variables
  rating = response["input_values"]["rating-value"]
  image_url = response["current_canvas"]["content"]["components"][1]["url"]
  user = response["user"]["id"]

  # Output variables to console
  puts "Rating Recevied: #{rating}"
  puts "Dog: #{image_url}"
  puts "User ID: #{user}"
  puts "=========================== ~~~~~~~~~~~~  RATING SUBMITED  ~~~~~~~~~~~~ ==========================="

  intercom.events.create(
    event_name: "Rated Dog",
    created_at: Time.now.to_i,
    id: user,
    metadata: {
      "Rating:" => "#{rating}",
      "Dog:" => "#{image_url}"
    }
  )

  # Pull a new dog url
  doggo = getDoggo

  # Insert url into new button object
  button = "{\"canvas\":{\"content\":{\"components\":[{\"id\":\"rate-this-dog-header\",\"type\":\"text\",\"text\":\"Rate This Dog [Staging]\",\"style\":\"header\",\"align\":\"center\",\"bottom_margin\":false},{\"id\":\"dog\",\"type\":\"image\",\"url\":\"#{doggo}\",\"align\":\"left\",\"width\":340,\"height\":240,\"rounded\":false},{\"id\":\"rating-value\",\"type\":\"single-select\",\"label\":\ null,\"value\":\"good\",\"save_state\":\"unsaved\",\"options\":[{\"id\":\"good\",\"type\":\"option\",\"text\":\"Good Boy\"},{\"id\":\"great\",\"type\":\"option\",\"text\":\"Great Boy\"}],\"action\":{\"type\":\"submit\"}}]},\"stored_data\":{}}}"

  # Send the JSON button as a response to the messenger
  button
end

get '/' do
  "Bark bark bark, there is nothing here."
end
