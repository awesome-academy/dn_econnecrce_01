class Ability
  include CanCan::Ability

  def initialize user, controller_namespace
    can :read, [Product, Category]
    can :manage, :cart
    if user.present?
      can :manage, User, id: user.id
      can :read, [Product, Category]
      can :manage, :cart
      can [:create, :update], Purchase, user_id: user.id
      if user.admin?
        case controller_namespace
        when "Admin"
          can :manage, :all
        end
      else
        can :update, Purchase, status: Purchase.statuses[:pending]
        can :update, Purchase, status: Purchase.statuses[:confirmed]
      end
    end
  end
end
