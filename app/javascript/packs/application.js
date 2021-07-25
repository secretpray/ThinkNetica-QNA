// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "@rails/actioncable"
import "channels"
import "@fortawesome/fontawesome-free/css/all"
// import "@fortawesome/fontawesome-free/js/all"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require('coffee')
require("utilities/auto_hide_flash")
require('utilities/addFields')
require('utilities/removeFields')
require('utilities/links_visible')
require('utilities/votes')
require('utilities/show_hide_comment')

// window.Rails = Rails
