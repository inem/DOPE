// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { identifierForContextKey } from "@hotwired/stimulus-webpack-helpers"
import LocalAuthController from "./local_auth_controller"

eagerLoadControllersFrom("controllers", application)

export function registerControllers(application) {
  application.register("local-auth", LocalAuthController)
}
