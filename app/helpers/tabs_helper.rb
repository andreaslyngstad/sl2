module TabsHelper
  def get_instance(params)
    @klass = get_klass(params[:class]).find(params[:id])
  end
  def get_klass(params)
    eval(params.chomp('s').capitalize)
  end

  def return_symbol(instance)
  	(instance.class.to_s + '_id').downcase.to_sym
  end
  def string_for_klass(klass)
  	klass.class.to_s.downcase.pluralize
  end
end
