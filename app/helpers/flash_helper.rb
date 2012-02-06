##
# Helper methods relating to the flash hash
#
module FlashHelper
  ##
  # Renders an HTML fragment for any flash messages in the queue.
  #  Fading is controlled by javascript in application.js
  #
  def flash_messages
    flash.each do |level, message|
      # Only display error/info/warning/success messages
      # Other flash messages are displayed by hand, elsewhere
      if [:error, :info, :warning, :success].include?(level)
        concat(content_tag(:div, raw(message), :id => level.to_s,
          :class => "alert-message block-message #{level.to_s}"))
      end
    end
    nil
  end
end
