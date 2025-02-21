# Pin npm packages by running ./bin/importmap

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"

# Наши контроллеры
pin "application", preload: true
pin "controllers/local_auth_controller", to: "controllers/local_auth_controller.js"

pin "@faker-js/faker", to: "https://ga.jspm.io/npm:@faker-js/faker@8.4.1/dist/esm/index.mjs"
