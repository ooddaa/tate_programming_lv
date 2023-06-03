defmodule HelpWeb.Router do
  use HelpWeb, :router

  import HelpWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {HelpWeb.Layouts, :root})
    # plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    # HelpWeb.UserAuth.fetch_current_user puts :current_user = %User{} into assigns
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelpWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:help, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: HelpWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", HelpWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{HelpWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", HelpWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{HelpWeb.UserAuth, :ensure_authenticated}] do
      live("/", CompanyLive.Index, :index)
      live("/companies", CompanyLive.Index, :index)
      live("/companies/new", CompanyLive.Index, :new)
      live("/companies/:id/edit", CompanyLive.Index, :edit)

      live("/companies/:id", CompanyLive.Show, :show)
      live("/companies/:id/show/edit", CompanyLive.Show, :edit)

      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
      live("/guess", WrongLive)

      live("/products", ProductLive.Index, :index)
      live("/products/new", ProductLive.Index, :new)
      live("/products/:id/edit", ProductLive.Index, :edit)

      live("/products/:id", ProductLive.Show, :show)
      live("/products/:id/show/edit", ProductLive.Show, :edit)

      live("/promo", PromoLive, :index)
      live("/card", CardLive, :index)
      live("/search", SearchLive, :index)
      live("/survey", SurveyLive, :index)
      live("/button", ButtonLive, :index)
      live("/admin-dashboard", Admin.DashboardLive)
    end
  end

  scope "/", HelpWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{HelpWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end
end
