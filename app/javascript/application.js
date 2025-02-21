// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// Импортируем контроллеры
import LocalAuthController from "controllers/local_auth_controller"
import PostController from "controllers/post_controller"

// Запускаем Stimulus
const application = Application.start()

// Регистрируем контроллеры
application.register("local-auth", LocalAuthController)
application.register("post", PostController)
