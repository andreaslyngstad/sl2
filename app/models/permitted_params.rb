class PermittedParams < Struct.new(:params, :current_user)
  def project
    params.require(:project).permit(*project_attributes)
  end
  def project_attributes
    if current_user
      [:name,:description,:active,:budget,:hour_price,:customer_id,:created_at,:updated_at,:customer]
    end
  end

  def todo
    params.require(:todo).permit(*todo_attributes)
  end
  def todo_attributes
    if current_user
      [:name,:user_id,:project_id,:customer_id,
   :due,:completed,:created_at,:updated_at,:project,:customer,:user,:done_by_user,:done_by_user_id,:prior,:firm]
    end
  end

  def milestone
    params.require(:milestone).permit(*milestone_attributes)
  end
  def milestone_attributes
    if current_user
      [:goal,:due,:completed,:project_id,:created_at,:updated_at, :project,:firm]
    end
  end
  def customer
    params.require(:customer).permit(*customer_attributes)
  end
  def customer_attributes
    if current_user
      [:name,:phone,:email,:address,:created_at,:updated_at, :firm]
    end
  end
  def employee
    params.require(:employee).permit(*employee_attributes)
  end
  def employee_attributes
    if current_user
      [:name,:phone,:email,:customer_id,:created_at,:updated_at,:customer,:firm]
    end
  end
  def firm
    params.require(:firm).permit(*firm_attributes)
  end
  def firm_attributes
  	  
    if current_user
      [:subscription_id,:plan, :name,:subdomain,:address,:phone, :currency, :time_zone, :language,:time_format,:date_format,:clock_format,:closed]
    else
      [:name,:subdomain,:address,:phone, :currency, :time_zone, :language,:time_format,:date_format,:clock_format,:closed]
    end
  end
  def plan
    params.require(:plan).permit(*plan_attributes)
  end
  def plan_attributes
    if current_user
      [:name, :price,:customers, :logs, :projects, :users, :paymill_id]
    end
  end
  def user
    params.require(:user).permit(*user_attributes)
  end
  def user_attributes
    if current_user
      [:role,:phone,:name,:hourly_rate,:avatar, :email,:password, :password_confirmation, :remember_me]
    else
      [:phone, :name, :email, :remember_me,:password, :password_confirmation, :role, :firm_id, :firm]
    end
  end
  def first_user
    params.require(:user).permit(*first_user_attributes)
  end
  def first_user_attributes
      [:phone, :name, :email, :remember_me,:password, :password_confirmation, :role, :firm_id, :firm, :user]
  end
  def log
    params.require(:log).permit(*log_attributes)
  end
  def log_attributes
    if current_user
      [:event,:customer_id,:user_id,:project_id,:employee_id,:todo_id,:tracking,:begin_time,:end_time,:log_date,
	 :hours,:project,:customer,:user,:todo, :firm]
    end
  end
  def subscription
    params.require(:subscription).permit(*subscription_attributes)
  end
  
  def subscription_attributes
    if current_user
      [:name, :email, :card_type, :paymill_id, :active,:paymill_card_token, :plan_id,:firm_id, :plan,:card_expiration , :card_zip,:firm, :last_four, :next_bill_on, :card_holder]
    end
  end
  def payment
    params.require(:payment).permit(*payment_attributes)
  end
  def payment_attributes
    if current_user
      [:card_type, :firm_id, :amount, :plan_name, :last_four]
    end
  end 

  def guides_category
    params.require(:guides_category).permit(*guides_category_attributes)
  end
  def guides_category_attributes
    if current_user
      [:title]
    end
  end
  
  def guides
    params.require(:guides).permit(*guides_attributes)
  end
  def guides_attributes
    if current_user
      [:content, :title, :guides_category_id]
    end
  end
  def blog
    params.require(:blog).permit(*blog_attributes)
  end
  def blog_attributes
    if current_user
      [:content, :title, :author]
    end
  end
  def invoice
    params.require(:invoice).permit(*invoice_attributes)
  end
  def invoice_attributes
    if current_user
      [:invoice_number,:content,:project_id,:customer_id,:firm_id,:paid,:reminder_sent,:due]
    end
  end
end

 