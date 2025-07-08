class AddApiEndpointToExistingSupportSquadAiHooks < ActiveRecord::Migration[7.0]
  def up
    # Update existing SupportSquadAI hooks to include the default API endpoint
    # if they don't already have one
    Integrations::Hook.where(app_id: 'support_squad_ai').find_each do |hook|
      if hook.settings['api_endpoint'].blank?
        hook.settings['api_endpoint'] = 'https://api.openai.com/v1/chat/completions'
        hook.save!
      end
    end
  end

  def down
    # Remove api_endpoint from all SupportSquadAI hooks
    Integrations::Hook.where(app_id: 'support_squad_ai').find_each do |hook|
      hook.settings.delete('api_endpoint')
      hook.save!
    end
  end
end 