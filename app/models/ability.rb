class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :update, :index, :show, :to => :crud

    user ||= User.new

    if user.role? 'admin'
      can :manage, :all
    elsif user.role? 'manager'
      can :manage, [Contact, Form, Request, Quote, Template]
      can [:show, :update], User, :id => user.id 
    elsif user.role? 'viewer'
      if user.new_record?
        can :create, [Account, Plan]
      end
      can :read, :all
    else
      can :read, :all
    end
  end
end
