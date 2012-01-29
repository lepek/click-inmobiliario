module Datatables
  module Renderers
    class Base
      def render(controller, adapter, options = {})
        controller.render(:text => '')
      end
    end
  end
end
