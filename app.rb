require 'json'
require 'sinatra'

endpoint = "https://949b4bab.ngrok.io"

post '/submit' do
  content_type 'application/json'
  puts "=========================== ~~~~~~~~~~~~  POST SUBMIT  ~~~~~~~~~~~~ ==========================="
  puts response.inspect
  button = '{
    "canvas": {
      "content": {
        "components": [{
          "id": "dog",
          "type": "image",
          "url": "https://images.dog.ceo/breeds/pug/n02110958_12860.jpg",
          "align": "left",
          "width": 340,
          "height": 240,
          "rounded": false
        }, {
          "id": "4a3a1733e96442b0fcc38d2c4f2c",
          "type": "single-select",
          "label": "Rate This Dog",
          "value": "3e0820c0e0af9cb653dbf1ae2752",
          "save_state": "unsaved",
          "options": [
            {
              "id": "3e0820c0e0af9cb653dbf1ae2752",
              "type": "option",
              "text": "😄 Good Boy"
            },
            {
              "id": "a2ae157c6b9878b363aee397590a",
              "type": "option",
              "text": "😍 Great Boy"
            }
          ]
        }]
      },
      "stored_data": {}
    }
  }'
  button.to_json
  button
end

# Endpoint that's hit when the messenger app is loaded in the messenger.
post'/' do
  puts "=========================== ~~~~~~~~~~~~  GET  ~~~~~~~~~~~~ ==========================="
  content_type 'application/json'
  puts response.inspect
  response = '{
      "canvas": {
        "content": {
          "components": [
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
              "label": "Rate This Dog 😍 ",
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
  response.to_json
  response
end

post '/goodboy' do
  puts "wags tail 🐶"
  response = '{"canvas":{"content":{"components":[{"id":"welcome-link","type":"image","url":"https://downloads.intercomcdn.com/i/o/86160844/0f0f53fbdb1c741e2f7bca83/link.jpg","align":"center","width":"130","height":"130","rounded":true},{"id":"get-started","type":"button","label":"Rate This Dog 😍","style":"primary","action":{"type":"submit","url":null},"bottom_margin":false}]},"stored_data":{}}}'
end
