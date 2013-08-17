require 'erpify/liquid/drops/base'
require 'ooor'

module Erpify
  module Liquid
    module Drops
      class OoorModel < Base

        def before_method(method_or_key)
          if not @@forbidden_attributes.include?(method_or_key.to_s)
            model = _source.const_get(method_or_key)
            filter_and_order_list(model)
          else
            nil
          end
        end

        protected

        def filter_and_order_list(model)
          if @context['with_domain']
            conditions  = HashWithIndifferentAccess.new(@context['with_domain'])
            order_by    = conditions.delete(:order_by).try(:split)
            offset      = conditions.delete(:offset)
            limit       = conditions.delete(:limit)
            fields      = conditions.delete(:fields).try(:split)
            context = @context['context'] #FIXME not very cool
            model.where(conditions).offset(offset).limit(limit).order(order_by).all(fields: fields, context: context || {})
          else
            model.all(context: @context['context'] || {})
          end
        end

      end
    end
  end
end