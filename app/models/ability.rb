class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :update, :index, :show, :to => :crud

    user ||= User.new

    if user.role? 'super'
      can :manage, :all
    elsif user.role? 'admin'
      can :manage, [Form, Request, Quote, Template, Account, Plan, Contact]
      can :manage, User, account_id: user.account_id
    elsif user.role? 'manager'
      can :manage, [Form, Request, Quote, Template]
      can [:show, :update], User, :id => user.id 
    elsif user.role? 'viewer'
      if user.new_record?
        can :create, [Account, Plan]
      end
      can :read, :all
      can :create, Request
    else
      can :read, :all
      can :create, Request
    end
  end
end
