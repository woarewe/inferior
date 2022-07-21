# frozen_string_literal: true

module RuntimeInterfaces
  module Core
      module DSL
        module Class
          def implements(interface)
            interfaces.add(interface)
          end

          def verify_interfaces!
            interfaces.each { interface.verify!() }
          end

          private

          def interfaces
            @interfaces ||= Set.new
          end
        end
      end
  end
end
