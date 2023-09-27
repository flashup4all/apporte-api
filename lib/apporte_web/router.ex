defmodule ApporteWeb.Router do
  use ApporteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApporteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ApporteWeb.Plug.AuthAccessPipeline
  end

  pipeline :branch_admin_auth do
    plug ApporteWeb.Plug.BranchAdminAccessPipeline
  end

  scope "/", ApporteWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", ApporteWeb do
    pipe_through :api

    scope "/v1" do
      scope "/onboarding" do
        post "/register", UserController, :register
        post "/forgot-password", UserController, :forgot_password
        post "/reset-password", UserController, :reset_password



      end

      post "/login", AuthController, :login
      post "/send_mail", AuthController, :send_mail

      # resources "/users", UserController, except: [:new, :edit]
      scope "/" do
        pipe_through :auth

        post "/orders", OrderController, :create

        scope "/settings" do
          resources "/branches", BranchController
          put "/users/:id", UserProfileController, :update
          get "/users/:id", UserProfileController, :show

          scope "/" do
            pipe_through :branch_admin_auth
            post "/user-profiles", UserController, :create_staff
            post "/customers", UserController, :register
            get "/customers", UserProfileController, :get_customers

            get "/user-profiles", UserProfileController, :get_staffs
            get "/user-profiles/:id", UserProfileController, :show
            resources "/vehicles", VehicleController
          end
        end
      end
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:apporte, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ApporteWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
