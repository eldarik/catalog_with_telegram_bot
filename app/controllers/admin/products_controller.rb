module Admin
  class ProductsController < Admin::ApplicationController
    def create
      resource = resource_class.new(resource_params)

      if resource.save
        resource.images = params.dig('product', 'image')
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def update
      if requested_resource.update(resource_params)
        requested_resource.images = params.dig('product', 'image')
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end
  end
end
