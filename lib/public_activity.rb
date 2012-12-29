require 'active_support'
require 'action_view'
require 'active_record'

# +public_activity+ keeps track of changes made to models
# and allows you to display them to the users.
#
# Check {PublicActivity::Tracked::ClassMethods#tracked} for more details about customizing and specifying
# ownership to users.
module PublicActivity
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload
  autoload :Config
  autoload :Tracked, 'public_activity/roles/tracked.rb'
  autoload :Creation, 'public_activity/actions/creation.rb'
  autoload :Update, 'public_activity/actions/update.rb'
  autoload :Destruction, 'public_activity/actions/destruction.rb'
  autoload :VERSION
  autoload :Common
  autoload :Renderable

  # Switches PublicActivity on or off.
  # @param value [Boolean]
  # @since 0.5.0
  def self.enabled=(value)
    PublicActivity.config.enabled = value
  end

  # Returns `true` if PublicActivity is on, `false` otherwise.
  # Enabled by default.
  # @return [Boolean]
  # @since 0.5.0
  def self.enabled?
    !!PublicActivity.config.enabled
  end

  # Returns PublicActivity's configuration object.
  # @since 0.5.0
  def self.config
    @@config ||= PublicActivity::Config.instance
  end

  # Module to be included in ActiveRecord models. Adds required functionality.
  module Model
    extend ActiveSupport::Concern
    included do
      include Tracked
      include Activist
    end
  end
end

require 'public_activity/orm/active_record'

require 'public_activity/utility/store_controller'
require 'public_activity/utility/view_helpers'
