# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( admin.css )
Rails.application.config.assets.precompile += %w( admin.js )
Rails.application.config.assets.precompile += %w( *.png *.jpg *.jpeg *.gif )
Rails.application.config.assets.precompile += %w( dashboard.css )
Rails.application.config.assets.precompile += %w( dashboard.js )
Rails.application.config.assets.precompile += %w( atlant/settings.js )
Rails.application.config.assets.precompile += %w( atlant/theme-default.css )

%w( account_types accounts budget_incomes budget_items budget_transactions budgets categories import_transactions incomes master_categories payees tasks houses account_transactions loans shares reports).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js"]
end
