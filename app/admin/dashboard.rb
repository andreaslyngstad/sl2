ActiveAdmin.register_page "Dashboard" do
  controller do
      # This code is evaluated within the controller class

    def scoped_collection
      Firm.includes(:subscription, :users)
    end
 
    def subscription_chart_data
     @data = AdminChart.new.subscription_count
    end
    def firms_chart_data
     @data = AdminChart.new.firms_count
    end
    def firms_resources_chart_data
     @data = AdminChart.new.firms_resources_count
    end
    def new_firms_count_chart_data
     @data = AdminChart.new.new_firms_count
    end
  end
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      column do
        panel "Recent Firms" do
          table_for Firm.recent.map do
            column :name do |firm|
              link_to firm.name, [:obeqaslksdssdfnfdfysdfxm, firm]
            end
            column "Admin User" do |firm|
              mail_to firm.users.where(role: "Admin").first.email
            end      
            column "Subscription", :sortable => :subscription_id do |firm|
              firm.subscription.name
            end
            end
           strong { link_to "View All Firms", obeqaslksdssdfnfdfysdfxm_firms_path }
        end
      end
    column do
        panel "Firms by subscription" do
          
          content_tag :div, :id => "chart" do
           content_tag :svg do
             
           end
           end
        end
       end
    end
    columns do
      column do
        div :class => "total_counters" do
          panel "Firms" do
            Statistics.last.try(:firms)
          end  
        end
        div :class => "total_counters" do
          panel "Free subscriptions" do
            Statistics.last.try(:free)
          end  
        end
        div :class => "total_counters" do
          panel "Bronze subscriptions" do
            Statistics.last.try(:bronze)
          end  
        end
        div :class => "total_counters" do
          panel "Silver subscriptions" do
            Statistics.last.try(:silver)
          end  
        end
        div :class => "total_counters" do
          panel "Gold subscriptions" do
            Statistics.last.try(:gold)
          end  
        end
        div :class => "total_counters" do
          panel "Free subscriptions" do
            Statistics.last.try(:platinum)
          end  
        end
        div :class => "total_counters" do
          panel "Logs" do
            Statistics.last.try(:logs)
          end  
        end
        div :class => "total_counters" do
          panel "Projects" do
            Statistics.last.try(:projects)
          end  
        end
        div :class => "total_counters" do
          panel "Customers" do
            Statistics.last.try(:customers)
          end  
        end
        div :class => "total_counters" do
          panel "Users" do
            Statistics.last.try(:users)
          end  
        end
      end
    column do
        panel "New firms" do
          
          div :id => "new_firms" do
           content_tag :svg do
             
           end
           end
        end
       end
    end
    columns do
    column do
        panel "Firms by subscription" do
          div :id => "stacked" do
            content_tag :svg do    
            end
          end
           
        end
       end
       end
       columns do
    column do
        panel "Firms resorses" do
          div :id => "resorses" do
            content_tag :svg do    
            end
          end
           
        end
       end
    
    end
   
    
 
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, obeqaslksdssdfnfdfysdfxm_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
