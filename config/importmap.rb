# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Наши контроллеры
pin "controllers/local_auth_controller", to: "controllers/local_auth_controller.js"
pin "controllers/post_controller", to: "controllers/post_controller.js"
