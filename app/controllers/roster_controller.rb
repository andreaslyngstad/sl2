class RosterController < ApplicationController
  def get_milestones
    @milestones = Milestone.user_milestones_two_weeks(current_firm, current_user)
  end
  def get_tasks
    @tasks_overdue_and_to_day = current_firm.todos.overdue_and_to_day
    
  end
end