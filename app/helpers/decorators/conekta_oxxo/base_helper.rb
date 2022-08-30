# frozen_string_literal: true

module Decorators
  module ConektaOxxo
    module BaseHelper
      def self.prepended(base)
        base.module_eval do
          def conekta_oxxo_receipt(payment)
            return unless payment.source_type == 'Spree::OxxoPayPayment'

            response_code = payment.response_code

            render partial: 'spree/conekta/payments/conekta_oxxo',
              locals: { order: payment.order, response_code: response_code }
          end

          def address_name(order)
            if ::SolidusSupport.combined_first_and_last_name_in_address? ||
                order.ship_address.respond_to?(:name)
              order.ship_address&.name
            elsif order.ship_address.respond_to?(:full_name)
              order.ship_address&.full_name
            else
              [
                order.ship_address&.firstname,
                order.ship_address&.lastname
              ].join(' ')
            end
          end
        end
      end

      ::Spree::BaseHelper.prepend(self)
    end
  end
end
