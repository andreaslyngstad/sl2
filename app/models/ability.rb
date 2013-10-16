class Ability
  include CanCan::Ability
  
  def initialize(user)
     if user.role == "Admin"
        can :manage, Firm
        can :manage, User, :firm => {:id => user.firm_id}
        can :manage, Customer, :firm => {:id => user.firm_id}
        can :manage, Project, :firm => {:id => user.firm_id}  
        can :create, Project 
        can :archive, Project
        can :activate_projects, Project            
        can :manage, Log, :firm => {:id => user.firm_id}
        can :manage, Todo, :firm => {:id => user.firm_id}
     end
     if user.role == "Member"
        can :read, Firm
        can :manage, User do |member|
          member.firm == user.firm && member == user
        end
        can :manage, Customer, :firm => {:id => user.firm_id}
        can :read, Project, :firm => {:id => user.firm_id}
        can :manage, Todo do |todo|
          todo.firm == user.firm && todo.user == user
        end
        can :manage, Project do |project|
          project.firm == user.firm && project.users.include?(user)
        end
        can :create, Project
        cannot :archive, Project
        cannot :activate_projects, Project
        can :manage, Log do |log|
           log.firm == user.firm && log.user == user
        end
        can :read, Log, :firm => {:id => user.firm_id}
     end   
       
     if user.role == "External user"
      
      can :manage, Project do |project|
        project.firm == user.firm && project.users.include?(user)
      end
      can :manage, Todo do |todo|
        todo.firm == user.firm && todo.user == user
      end
      cannot :archive, Project
      can :manage, Log do |log|
        log.firm == log.firm && log.user == user
      end
      can :read, Log do |log|
        log.firm == log.firm && log.user == user
      end

     end     
   end
end
