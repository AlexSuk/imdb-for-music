Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1885070241764617', '1ecb98b87fac99ce718ae8a161f3596f',
           :scope => 'email',
           :display => 'popup',
           #callback_path: "/auth/facebook/callback",
           client_options: {
               site: 'https://graph.facebook.com/v2.2',
               authorize_url: "https://www.facebook.com/v2.2/dialog/oauth"
           }, token_params: { parse: :json }
end
