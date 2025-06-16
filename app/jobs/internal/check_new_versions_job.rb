class Internal::CheckNewVersionsJob < ApplicationJob
  queue_as :scheduled_jobs

  def perform
    # Disabled version checking to prevent enterprise features from being overridden
    return
  end
end

Internal::CheckNewVersionsJob.prepend_mod_with('Internal::CheckNewVersionsJob')
